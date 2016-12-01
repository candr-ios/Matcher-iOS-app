//
//  Tournament.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Tournament.h"
#import "League.h"
#import "NSMutableArray+Shuffling.h"
#import "Statistics.h"
#import "Competition.h"

@implementation Tournament

+ (NSDictionary *) defaultPropertyValues {
    return @{@"isGroupStageCompleted": @(false),@"isCompleted": @(false), @"isInitialized":@(false), @"hasGroupStage" : @(false), @"has2stages": @(false),@"shouldHaveGroups": @(false)};
}

+ (NSString *)primaryKey {
    return @"id";
}

- (BOOL) isTournamentSetupValid {
    NSInteger x = self.players.count;
    return  (x != 0) && ((x & (x - 1)) == 0);
}

- (BOOL) canCreateGroups {
    NSInteger x = self.players.count;
    return  [self isTournamentSetupValid] && x >= 8;
}

+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"competition": [RLMPropertyDescriptor descriptorWithClass:Competition.class propertyName:@"tournament"],
             };
}

#pragma mark - Initialization

/// Make initialization for Tournament object with players and reakm
/// Choose to generate Knockout stage OR Groups based on players count
- (instancetype)initWithPlayers:(RLMArray<Player *><Player> *)players
{

    self = [super init];
    if (self) {
        // id
        self.id = [Utils uniqueId];
        //
        self.players = players;
        if ([self isTournamentSetupValid] && !self.isInitialized) {
            if ([players count] >= 16) {
                [self generateGroups];
            } else if ([players count] <= 8) {
                [self generateInitialKnockoutStage];
            }
        }
    }
    return self;
}


#pragma mark - Transition GroupStage -> KnockoutStage

/// Generate Knockout Stage(initial) when Players in all groups played all matches
- (void) generateKnockoutStagesFromGroups {
    if (self.isGroupStageCompleted) {
        RLMArray<Player *><Player> *groupWinners = [self getGroupsWinners];
        [self.realm beginWriteTransaction];
        self.groupWinners = groupWinners;
        [self.realm commitWriteTransaction];
        [self generateInitialKnockoutStage];
    } else {
        NSLog(@"Not completed group stage");
    }
}



/// return players on 1st & 2nd place on each group
- (NSArray<Player>*) getGroupsWinners
{

    NSMutableArray<Player *> *winners = [NSMutableArray array];
    for (Group *group in self.groups) {
        RLMResults<StatisticsItem *> * table = [group.statistics.items sortedResultsUsingDescriptors:@[
                                                                [RLMSortDescriptor  sortDescriptorWithProperty:@"score" ascending:false],
                                                                [RLMSortDescriptor  sortDescriptorWithProperty:@"goalsFor" ascending:false],
                                                                [RLMSortDescriptor sortDescriptorWithProperty:@"goalsDiff" ascending:false]]];
        
        [winners addObject:table[0].player];
        [winners addObject:table[1].player];
    }
    return [winners copy];
}


- (int) currentWeek {
    int minWeek = 1;
    if (self.hasGroupStage) {
        for (Group * group in self.groups) {
            minWeek =  MIN(group.currentWeek, minWeek);
        }
        return minWeek;
    }
    
    return -1;
}


#pragma mark - For Initial Stage

- (RLMArray<Group*><Group> *) generateGroups {
    
    if (![self canCreateGroups] || self.hasGroupStage || self.isInitialized) {
        return nil;
    }
    
    self.isInitialized = true;
    self.hasGroupStage = true;

    NSMutableArray<Player *> * players = [[League convertPlayersToNSArray:self.players] mutableCopy];
    
    [players shuffle];
    
    NSInteger numberOfGroups = self.players.count / 4;
    NSMutableArray<Group *> * groups = [[NSMutableArray alloc] initWithCapacity:numberOfGroups];
    
    
    NSArray * groupLetters = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"K", @"L", @"M", @"N"];
    for (int i = 0; i < numberOfGroups; i++) {
        
        Group * group = [Group new];
        group.id = [Utils uniqueId];
        group.name = groupLetters[i];
        
        NSArray<Player *> * groupPlayers = [players subarrayWithRange:NSMakeRange(i * 4, 4)];
        
        int i = 1;
        for (Player * p in groupPlayers) {
            p.index = i;
            i++;
        }
        
        [group.players addObjects:groupPlayers] ;
        [group.weeks addObjects:[League generateScheduleFrom:groupPlayers hasTwoStages:self.has2stages]];
        group.statistics = [Statistics new];
        [groups addObject:group];
    }
    
    [self.groups addObjects:groups];
    
    // generate initial statistics for groups
    [self generateInitialStatistics];
    
    return self.groups;
}

- (void) generateInitialStatistics {
    for (Group * group in self.groups) {
        group.statistics = [Statistics new];
        for (Player * player in group.players) {
            StatisticsItem * item = [[StatisticsItem alloc] init];
            item.player = player;
            item.id = [Utils uniqueId];
            
            [group.statistics.items addObject:item];
        }
    }
    
}


- (void) updateStatistics {
    BOOL isGroupStageCompleted = true;
    for (Group * group in self.groups) {
        [group updateStatistics];
        isGroupStageCompleted = group.isCompleted && isGroupStageCompleted;
    }
    
    [self.realm beginWriteTransaction];
    self.isGroupStageCompleted = isGroupStageCompleted;
    [self.realm commitWriteTransaction];
}

#pragma mark - KnockoutStage

- (KnockoutStage *) generateInitialKnockoutStage {
    
    KnockoutStage *initialStage;
    
    if (self.isGroupStageCompleted) {
        initialStage = [[KnockoutStage alloc] init];
        [initialStage.players addObjects:self.groupWinners];
    } else {
        initialStage = [[KnockoutStage alloc] init];
        [initialStage.players addObjects:self.players];
    }
    [initialStage typeOfInitialStage];
    [initialStage generateMathesForCurrenrStage:self.isGroupStageCompleted];
    
    [self.realm beginWriteTransaction];
    [self.knockoutStages addObject:initialStage];
    self.currentStage = initialStage;
    [self.realm commitWriteTransaction];
    
    return self.currentStage;
}


- (KnockoutStage *) generateNextKnockoutStage
{
    
    if (self.currentStage == nil) {
        return nil;
    }
   
    RLMRealm *realm = [RLMRealm defaultRealm];

    if([self.currentStage isAllMatchesPlayed] && self.currentStage.type == SemiFinal) {
        KnockoutStage * thirdStage = [[KnockoutStage alloc] init];
        [thirdStage.players addObjects:[self.currentStage losersOfStage]];
        thirdStage.type = ThirdPlace;
        [thirdStage generateMathesForCurrenrStage: false];
        
        KnockoutStage * finalStage = [[KnockoutStage alloc] init];
        [finalStage.players addObjects:[self.currentStage winnersOfStage]];
        finalStage.type = Final;
        [finalStage generateMathesForCurrenrStage: false];
        
        
        [realm beginWriteTransaction];
        self.currentStage.isComplete = YES;
        [self.knockoutStages addObjects:@[thirdStage, finalStage]];
        self.currentStage = thirdStage;
        [realm commitWriteTransaction];
        return self.currentStage;
    }
    
    if([self.currentStage isAllMatchesPlayed]  && self.currentStage.type == ThirdPlace) {
        [realm beginWriteTransaction];
        self.currentStage.isComplete = YES;
        self.currentStage = self.knockoutStages.lastObject;
        [realm commitWriteTransaction];
        return self.currentStage;
    }
    
    if ([self.currentStage isAllMatchesPlayed]  && self.currentStage.type == Final) {
        Competition * comp = [self.competition firstObject];
        [realm beginWriteTransaction];
        self.currentStage.isComplete = YES;
        self.winner = [[self.currentStage winnersOfStage] objectAtIndex:0];
       
        comp.winner = self.winner;
        self.isCompleted = YES;
        [realm commitWriteTransaction];
        return nil;
    }

    if ([self.currentStage isAllMatchesPlayed]) {
        
        
        KnockoutStage *newStage = [[KnockoutStage alloc] init];
        [newStage.players addObjects:[self.currentStage winnersOfStage]];
        
        newStage.type = self.currentStage.type >> 1;
        [newStage generateMathesForCurrenrStage: false];
        
        [realm beginWriteTransaction];
        self.currentStage.isComplete = YES;
        [self.knockoutStages addObject:newStage];
        self.currentStage = newStage;
        [realm commitWriteTransaction];
        return self.currentStage;
    }

    return nil;
}

@end

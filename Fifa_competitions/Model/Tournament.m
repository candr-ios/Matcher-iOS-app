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

@implementation Tournament

+ (NSDictionary *) defaultPropertyValues {
    return @{@"isGroupStageCompleted": @(false),@"isCompleted": @(false), @"isInitialized":@(false), @"hasGroupStage" : @(false)};
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
    }
    if (![self isTournamentSetupValid]) {
        return nil;
    }
    
    return self;
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
        [group.weeks addObjects:[League generateScheduleFrom:groupPlayers hasTwoStages:true]];
        group.statistics = [Statistics new];
        [groups addObject:group];
    }
    
    [self.groups addObjects:groups];
    
    return self.groups;
}


- (void) updateStatistics {
    for (Group * group in self.groups) {
        [group updateStatistics];
    }
}

- (KnockoutStage *) generateInitialKnockoutStage {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KnockoutStage *initialStage = [[KnockoutStage alloc] initWithPlayers:_players];
    [initialStage typeOfCurrentStage];
    [initialStage generateMathesForCurrenrStage];
    
    [realm beginWriteTransaction];
    [self.knockoutStages addObject:initialStage];
    self.currentStage = initialStage;
    [realm commitWriteTransaction];
    [initialStage setRandomGoalsForMatches];
    
    return nil;
}


- (KnockoutStage *) generateNextKnockoutStage
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if ([self.currentStage isComplete] && [self.currentStage.matches count] == 1) {
        if (!self.isCompleted) {
            [realm beginWriteTransaction];
            self.winner = [[self.currentStage winnersOfStage] objectAtIndex:0];
            self.isCompleted = YES;
            [realm commitWriteTransaction];
        }
    } else {
        
        KnockoutStage *newStage = [[KnockoutStage alloc] initWithPlayers:[self.currentStage winnersOfStage]];
        
        newStage.type = [newStage typeOfCurrentStage];
        [newStage generateMathesForCurrenrStage];

        [realm beginWriteTransaction];
        [self.knockoutStages addObject:newStage];
        self.currentStage = newStage;
        [realm commitWriteTransaction];
    }
    return nil;
}

@end

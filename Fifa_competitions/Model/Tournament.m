//
//  Tournament.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Tournament.h"
#import "Tournament+Checking.h"

@implementation Tournament

+ (NSDictionary *) defaultPropertyValues {
    return @{@"isGroupStageCompleted": @(false),@"isCompleted": @(false), @"isInitialized":@(false)};
}

+ (NSString *)primaryKey {
    return @"id";
}


#pragma mark - Initialization

- (instancetype)initWithPlayers:(RLMArray<Player *><Player> *)players
{
    self = [super init];
    if (self) {
        self.players = players;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:players];
        [realm commitWriteTransaction];
        
        if ([self validNumberOfPlayers]) {
            [self.players count] <= 16 ? [self genereteInitialKnockoutStage] : [self generateGroups];
        }
    }
    return self;
}


#pragma mark - For Initial Stage

- (NSError *) genereteInitialKnockoutStage
{
    KnockoutStage *initialStage = [[KnockoutStage alloc] init];
    initialStage.players = self.players;
    [initialStage setTypeOfCurrentStage];
    [initialStage generateMathesForCurrenrStage];
    self.currentStage = initialStage;
    [self.realm beginWriteTransaction];
    [self.realm addObject:self.currentStage];
    [self.realm commitWriteTransaction];
    ///TODO: return KnockoutStage
    return nil;
}


#pragma mark - Next Stages

- (NSError *) nextStage
{
    if (!self.isCompleted) {
        [self.currentStage setRandomGoalsForMatches];
        if (self.currentStage.isComplete) {
            [self.currentStage shiftsStage];
        }
        [self generateMatchesForNextStage];
        return nil;
    } else {
        NSLog(@"Winner: %@", [self.players objectAtIndex:0]);
    }
    return nil;
}


- (NSError *) generateMatchesForNextStage {
    [self generatePlayersForNextStage];
    [self.currentStage generateMathesForCurrenrStage];
    return nil;
}

///Optional for remove defeated players from database
- (void) generatePlayersForNextStageWithRemovingFromDatabase
{
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    for (Match *match in self.currentStage.matches) {
//        <#statements#>
//    }
}


- (void) generatePlayersForNextStage {
    
    if ([self winner]) {
        NSLog(@"Only 1 player left: %@", [self.players lastObject]);
    } else {
        NSMutableArray *newPlayers = [NSMutableArray array];
        RLMRealm *realm = [RLMRealm defaultRealm];

        for (Match *match in self.currentStage.matches) {
            [realm beginWriteTransaction];
            // pick up matches winners
            Player *winnerOfTheMatch = [self winerOfMatch:match];
            [newPlayers addObject:winnerOfTheMatch];
            [realm commitWriteTransaction];
        }
        [realm beginWriteTransaction];

        self.currentStage.players = (RLMArray<Player*><Player>*)newPlayers;
        [realm commitWriteTransaction];
    }

}

- (Player*) winerOfMatch:(Match*)match {
    Player *winner = nil;
    if (match.homeGoals > match.awayGoals) {
        winner = match.home;
    } else if (match.homeGoals < match.awayGoals) {
        winner = match.away;
    } else {
        // penalty series
    }
    return winner;
}

#pragma mark - Checks

- (BOOL) winner
{
    return [self.currentStage.players count] == 1 ? YES && self.isCompleted == YES : NO;
}

@end

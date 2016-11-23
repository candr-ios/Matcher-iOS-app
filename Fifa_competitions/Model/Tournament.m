//
//  Tournament.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Tournament.h"
#import "Tournament+Checking.h"
#import "Utils.h"

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
        self.id = [Utils uniqueId];
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

- (NSError *) generateNextKnockoutStage
{
    if (![self winner]) {
        [self.currentStage shiftsStage];
    }
    return nil;
}

- (void) generatePlayersForNextStage {
    
    if ([self winner]) {
        NSLog(@"Only 1 player left: %@", [self.players lastObject]);
    } else {
        NSMutableArray *newPlayers = [NSMutableArray array];
        
        for (Match *match in self.currentStage.matches) {
            [self.realm beginWriteTransaction];
            // pick up matches winners
            Player *winnerOfTheMatch = [self winerOfMatch:match];
            [newPlayers addObject:winnerOfTheMatch];
            [self.realm commitWriteTransaction];
        }
        [self.realm beginWriteTransaction];

        self.currentStage.players = (RLMArray<Player*><Player>*)newPlayers;
        [self.realm commitWriteTransaction];
    }

}

- (Player*) winerOfMatch:(Match*)match {
    Player *winner = nil;
    if (match.homeGoals > match.awayGoals) {
        winner = match.home;
    } else {
        winner = match.home;
    }
    return winner;
}

#pragma mark - Checks

- (BOOL) winner
{
    // check for valid
    return [self.currentStage.players count] == 1 ? YES && self.isCompleted == YES : NO;
}

@end

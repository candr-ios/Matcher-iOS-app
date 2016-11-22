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
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    self.currentStage = [[KnockoutStage alloc] init];
    self.currentStage.players = self.players;
    
    [self setTypeOfInitialRound];
    [self.currentStage generateMathesForCurrenrStage];
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:self.currentStage];
    [realm commitWriteTransaction];
    
    return nil;
}


#pragma mark - Next Stages

- (NSError *) nextStage
{
    if (self.currentStage.isComplete) {
        self.currentStage.type = self.currentStage.type >> 1;
    }
    [self generateMatchesForNextStage];
    return nil;
}


- (NSError *) generateMatchesForNextStage {
    [self generatePlayersForNextStage];
    [self.currentStage generateMathesForCurrenrStage];
    return nil;
}


- (void) generatePlayersForNextStage {
    NSMutableArray *newPlayers = [NSMutableArray array];
    for (Match *match in self.currentStage.matches) {
        // pick up matches winners
        Player *winnerOfTheMatch = [self winerOfMatch:match];
        [newPlayers addObject:winnerOfTheMatch];
    }
    self.currentStage.players = (RLMArray<Player*><Player>*)newPlayers;
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

@end

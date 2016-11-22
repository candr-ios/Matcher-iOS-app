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

- (NSError *) genereteInitialKnockoutStage
{
    self.currentStage = [[KnockoutStage alloc] init];
    self.currentStage.players = self.players;

    [self typeOfInitialRound];
    [self.currentStage generateMathesForCurrenrStage];
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:self.currentStage];
    [realm commitWriteTransaction];
    
    
    return nil;
}

- (NSError *) nextStage
{
    self.currentStage.type = self.currentStage.type >> 1;
    return nil;
}




@end

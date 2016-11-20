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
    return @{@"isGroupStageCompleted": @(false),@"isCompleted": @(false), @"isInitialized":@(false), @"currentStage": @(-1)};
}

+ (NSString *)primaryKey {
    return @"id";
}

- (instancetype)initWithPlayers:(RLMArray<Player*><Player>*)players
{
    self = [super init];
    if (self) {
        self.players = players;
        if ([self validNumberOfPlayers]) {
            [self.players count] <= 16 ? [self genereteInitialKnockoutStage] : [self generateGroups];
        }
    }
    return self;
}

- (NSError *) genereteInitialKnockoutStage
{
    self.currentStage = [self typeOfInitialRound];
    return nil;
    
}

- (NSError *) nextStage
{
    self.currentStage.type = self.currentStage.type << 1;
    return nil;
}


@end

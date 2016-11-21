//
//  KnockoutStage.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "KnockoutStage.h"

@implementation KnockoutStage

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *) defaultPropertyValues {
    return  @{@"type": @(Round16)};
}

- (instancetype)initWithStageType:(KnockoutStageType)stageType andPlayers:(RLMArray<Player *><Player>*)players
{
    self = [super init];
    if (self) {
        self.type = stageType;
        self.players = players;
    }
    return self;
}

- (NSError*) generateMathesForCurrenrStage;
{
    NSMutableArray *matches = [NSMutableArray array];
    for (int i = 0; i < [self.players count]; i++) {
        Match *match = [[Match alloc] init];
        match.home = self.players[i];
        match.away = self.players[i-1];
        [matches addObject:match];
    }
    self.matches = matches;
    return nil;
}


@end

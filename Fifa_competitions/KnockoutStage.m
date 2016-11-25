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

- (instancetype)initWithPlayers:(id)players
{
    self = [super init];
    if (self) {
        self.id = [Utils uniqueId];
        self.players = players;
    }
    return self;
}

#pragma mark - Stage Methods

/// return StageType of tournament(1/16, 1/8, 1/4, 1/2, final) based on enum KnockoutStageType
/// using shifted bytes
- (KnockoutStageType) typeOfInitialStage
{
    int numberOfPlayers = (int)[self.players count];
    
    BOOL stageIsFound = NO;
    
    while (!stageIsFound) {
        if (numberOfPlayers == self.type) {
            stageIsFound = YES;
        } else {
            [self.realm beginWriteTransaction];
            self.type = self.type >> 1;
            [self.realm commitWriteTransaction];
        }
    }
    return self.type;
}


- (NSError*) generateMathesForCurrenrStage
{
    
//    [self checkForWinner];
    
    [self.realm beginWriteTransaction];
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            Player *homePlayer = self.players[i-1];
            match.home = homePlayer;
            Player *awayPlayer = self.players[i];
            match.away = awayPlayer;
            [self.realm addObject:match];
            [self.matches addObject:match];
        }
    }
    [self.realm commitWriteTransaction];
    
    return nil;
}

- (NSArray<Player>*) winnersOfStage {
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    
    for (Match *match in self.matches) {
        if (match.homeGoals > match.awayGoals) {
            [winners addObject:match.home];
        } else {
            [winners addObject:match.away];
        }
    }
    
    return winners;
}


#pragma mark - Test

/// For test
/// Set up random score between Players in each match of Stage
- (void)setRandomGoalsForMatches
{
    [self.realm beginWriteTransaction];
    for (Match *match in self.matches) {
        match.homeGoals = arc4random() % 5;
        match.awayGoals = arc4random() % 5;
        if (match.homeGoals == match.awayGoals) {
            match.homeGoals = match.homeGoals+1;
        }
    }
    self.isComplete = YES;
    [self.realm commitWriteTransaction];
}




@end

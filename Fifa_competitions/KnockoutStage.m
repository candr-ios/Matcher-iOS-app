//
//  KnockoutStage.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "KnockoutStage.h"
#import "League.h"
#import "Utils.h"

@implementation KnockoutStage

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *) defaultPropertyValues {
    return  @{@"type": @(Round16), @"isComplete": @(false)};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.id = [Utils uniqueId];
    }
    return self;
}

#pragma mark - Stage Methods

- (NSString *) typeString {
    switch (self.type) {
        case ThirdPlace:
            return  @"Third Place";
            break;
        case Final:
            return  @"Final";
            break;
        case SemiFinal:
            return  @"SemiFinal";
            break;
        case QuaterFinal:
            return  @"Quater Final";
            break;
        case Round8:
            return  @"Round 8";
            break;
        case Round16:
            return @"Round 16";
            break;
        default:
            return @"Unknown";
    }
}

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


- (NSError*) generateMathesForCurrenrStage: (BOOL) fromGroups
{
    
    if (fromGroups) {
       [self.matches addObjects: [self generateMatchesForCurrentStageFromGroupsWinners]];
        return nil;
    }
    
    NSMutableArray<Match *> * matches = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            Player *homePlayer = self.players[i-1];
            match.home = homePlayer;
            Player *awayPlayer = self.players[i];
            match.away = awayPlayer;
            
            [matches addObject:match];
        }
    }
    
    [self.matches addObjects:matches];
   
    return nil;
}

- (RLMArray<Match *><Match> *) generateMatchesForCurrentStageFromGroupsWinners {
    
    long factor = self.players.count / 2;
    
    NSArray<Player *> * players = [self.players valueForKey:@"self"];
    
    NSArray<Player*> * top = [players subarrayWithRange:NSMakeRange(0, factor)];
    NSArray<Player*> * bottom = [[players subarrayWithRange:NSMakeRange(factor, factor)] reversedArray];
    
    
    Week * week = [League generateFirstWeekWithTop:top bottom:bottom];
    return week.matches;
}

- (NSArray<Player*>*) winnersOfStage {
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    
    for (Match *match in self.matches) {
        if (match.homeGoals > match.awayGoals) {
            [winners addObject:match.home];
        } else if(match.homeGoals < match.awayGoals) {
            [winners addObject:match.away];
        }
    }
    return winners;
}

/*
         else if(match.homeGoals == match.awayGoals) {
            
            PenaltySeries *penalty = [[PenaltySeries alloc] initWithFirstPlayer:match.home andSecondPlayer:match.away];
            
            /// for test
            [self setRandomGoalsForPenaltySeries:penalty];
            ///
            [winners addObject:[self getWinnerOfPenaltySeries:penalty]];
            
            [self.realm beginWriteTransaction];
            match.penalty = penalty;
            [self.penaltySeries addObject:penalty];
            [self.realm commitWriteTransaction];
        }
    
    }
    if (![self checkAllPenaltyPlayed]) {
        return nil;
    } else {
    return winners;
    }
}
*/

- (BOOL) isAllMatchesPlayed {
    BOOL completed = true;
    for (Match * match in self.matches) {
        completed = match.played && completed;
    }
    
    return completed;
}



- (NSArray<Player*>*) losersOfStage {
    NSMutableArray *losers = [[NSMutableArray alloc] init];
    
    for (Match *match in self.matches) {
        if (match.homeGoals < match.awayGoals) {
            [losers addObject:match.home];
        } else if(match.homeGoals > match.awayGoals) {
            [losers addObject:match.away];
        }
        
    }
    return losers;
}
/*
        else if(match.homeGoals == match.awayGoals) {
            
            PenaltySeries *penalty = [[PenaltySeries alloc] initWithFirstPlayer:match.home andSecondPlayer:match.away];
            
            /// for test
            [self setRandomGoalsForPenaltySeries:penalty];
            ///
            [losers addObject:[self getWinnerOfPenaltySeries:penalty]];
            
            [self.realm beginWriteTransaction];
            match.penalty = penalty;
            [self.penaltySeries addObject:penalty];
            [self.realm commitWriteTransaction];
        }
    }
    if (![self checkAllPenaltyPlayed]) {
        return nil;
    } else {
 
    }
}
*/


#pragma mark - Test

/// For test
/// Set up random score between Players in each match of Stage
- (void)setRandomGoalsForMatches
{
    [self.realm beginWriteTransaction];
    for (Match *match in self.matches) {
        match.homeGoals = arc4random() % 5;
        match.awayGoals = arc4random() % 5;
    }
    self.isComplete = YES;
    [self.realm commitWriteTransaction];
}

- (void)setRandomGoalsForPenaltySeries:(PenaltySeries*)penalty
{
    [self.realm beginWriteTransaction];
    penalty.homeGoals = arc4random() % 5;
    penalty.awayGoals = arc4random() % 5;
    if (penalty.homeGoals == penalty.awayGoals) {
        penalty.awayGoals = penalty.awayGoals + 1;
    }
    [self.realm commitWriteTransaction];
}


- (Player*) getWinnerOfPenaltySeries:(PenaltySeries*)penalty
{
    Player* penaltyWinner = nil;
    
    if (penalty.homeGoals > penalty.awayGoals) {
        penaltyWinner =  penalty.home;
    } else {
        penaltyWinner = penalty.away;
    }
    penalty.played = YES;
    return penaltyWinner;
}

- (BOOL) checkAllPenaltyPlayed {
    BOOL result = nil;
    for (PenaltySeries *penalty in self.penaltySeries) {
        if (penalty.played) {
            result = YES;
        } else {
            result = NO;
            NSLog(@"Penalty series: %@, not played", penalty);
        }
    }
    return result;
}


@end

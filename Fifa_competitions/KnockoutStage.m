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
#import "NSMutableArray+Shuffling.h"

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
            return  @"1/16";
            break;
        case Round16:
            return @"First Round";
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
    
    RLMRealm * realm = [RLMRealm defaultRealm];
    
    if (numberOfPlayers == 2) {
        [realm beginWriteTransaction];
        
        self.type = Final;
        
        [realm commitWriteTransaction];
    } else {
        [realm beginWriteTransaction];
        
        self.type = numberOfPlayers;
        
        [realm commitWriteTransaction];
    }
    
    return self.type;
}


- (NSError*) generateMathesForCurrenrStage: (BOOL) fromGroups
{
    
    if (fromGroups) {
        [self.matches addObjects: [self _generateMatchesForCurrentStage]];
        return nil;
    }
    
    
    NSArray<Match *> * matches = [self _generateMatchesForCurrentStage];
    
    [self.matches addObjects:matches];
   
    return nil;
}

- (NSArray<Match *> *) _generateMatchesForCurrentStage {
    
    
    
//    NSArray<Player *> * players = [self.players valueForKey:@"self"];

    NSMutableArray<Match *> * matches = [[NSMutableArray alloc] init];

    int count = (int)self.players.count;
    for (int i = 0; i < count - 1; i = i + 2) {
//        if (i % 2 == 0) {
//            continue;
//        }
        Match * match = [[Match alloc] init];
        match.home = self.players[i];
        match.away = self.players[i + 1];
        [matches addObject:match];
    }
    
    return [matches copy];
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

//
//  Group.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Group.h"

@implementation Group

+ (NSDictionary *) defaultPropertyValues {
    return @{@"currentWeek": @(1)};
}

+ (NSString *)primaryKey {
    return @"id";
}

- (void) updateStatistics {
    
    if (self.weeks.count < self.currentWeek) {
        [self.realm beginWriteTransaction];
        
        self.isCompleted = true;
        
        [self.realm commitWriteTransaction];
        
        return;
    }
    
    Week * currentWeek = [self.weeks objectAtIndex:self.currentWeek - 1];
    
    BOOL allMatchesPlayed = true;
    for (Match * match in currentWeek.matches) {
        
        if (match.played) {
            if (!match.statsFlag) {
                NSPredicate * homePred = [NSPredicate predicateWithFormat:@"player == %@", match.home];
                StatisticsItem * homeItem = [[self.statistics.items objectsWithPredicate:homePred] firstObject];
                
                NSPredicate * awayPred = [NSPredicate predicateWithFormat:@"player == %@", match.away];
                StatisticsItem * awayItem = [[self.statistics.items objectsWithPredicate:awayPred] firstObject];
                
                
                [self.realm beginWriteTransaction];
                
                [homeItem.matches addObject:match];
                [awayItem.matches addObject:match];
                
                match.statsFlag = true;
                
                homeItem.gamesPlayed += 1;
                awayItem.gamesPlayed += 1;
                
                if(match.homeGoals > match.awayGoals) {
                    homeItem.wins += 1;
                    homeItem.score += 3;
                    awayItem.loses += 1;
                } else if (match.homeGoals < match.awayGoals) {
                    homeItem.loses += 1;
                    awayItem.wins += 1;
                    awayItem.score += 3;
                } else {
                    homeItem.draws += 1;
                    awayItem.draws += 1;
                    awayItem.score += 1;
                    homeItem.score += 1;
                }
                
                homeItem.goalsFor += match.homeGoals;
                homeItem.goalsAgainst += match.awayGoals;
                awayItem.goalsFor += match.awayGoals;
                awayItem.goalsAgainst += match.homeGoals;
                
                homeItem.goalsDiff = homeItem.goalsFor - homeItem.goalsAgainst;
                awayItem.goalsDiff = awayItem.goalsFor - awayItem.goalsAgainst;
                
                [self.realm commitWriteTransaction];
                
            }
            
        } else {
            allMatchesPlayed = false;
        }
        
    }
    
    if (allMatchesPlayed) {
        [self.realm beginWriteTransaction];
        
        currentWeek.isCompleted = true;
        self.currentWeek +=1;
        
        [self.realm commitWriteTransaction];
    }
    
    BOOL allWeeksCompleted = true;
    for (Week * w in self.weeks) {
        allWeeksCompleted = w.isCompleted && allWeeksCompleted;
    }
    
    if (allWeeksCompleted) {
        [self.realm beginWriteTransaction];
        
        self.isCompleted = true;
        
        [self.realm commitWriteTransaction];
    }
    
}


@end

//
//  League.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "League.h"
#import "Utils.h"
#import "Statistics.h"
#import "NSMutableArray+Shuffling.h"
#import "Competition.h"

@implementation League

+ (NSDictionary *) defaultPropertyValues {
    return @{@"isCompleted": @(false), @"twoStages": @(false), @"currentWeek": @(1)};
}

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"competition": [RLMPropertyDescriptor descriptorWithClass:Competition.class propertyName:@"league"],
             };
}

- (NSError *) generateMatches {
    
    if (_players.count < 2) {
        return [[NSError alloc] initWithDomain:@"LeagueError" code:400 userInfo:@{@"description": @"Number of players must be > than 1"}];
    }
    
    [self.weeks addObjects:[self generateSchedule]];
    
    [self generateInitialStatistics];
    
    return nil;
}

- (void) generateInitialStatistics {
    self.statistics = [Statistics new];
    for (Player * player in self.players) {
        StatisticsItem * item = [[StatisticsItem alloc] init];
        item.player = player;
        item.id = [Utils uniqueId];
        
        [self.statistics.items addObject:item];
    }
}

+ (NSArray<Week *> *) generateScheduleFrom:(NSArray<Player *> *) _players hasTwoStages: (BOOL) twoStages {
    
    NSUInteger count = _players.count;
    BOOL addDummy = [_players indexOfObjectPassingTest:^BOOL(Player * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if( [obj.name isEqualToString:@"Dummy"]) {
            *stop = true;
            return true;
        }
        return false;
    }] != NSNotFound;
    
    NSUInteger n = count;

    NSUInteger limit = n - 1;
    NSUInteger factor = n / 2;
    
    NSArray<Player *> * players = _players;
    
    // Separate players into 2 equal arrays
    NSArray<Player*> * top = [players subarrayWithRange:NSMakeRange(0, factor)];
    NSArray<Player*> * bottom = [[players subarrayWithRange:NSMakeRange(factor, factor)] reversedArray];
    

    
    
    Week * firstWeek = [self generateFirstWeekWithTop:top bottom:bottom];
    
    NSMutableArray<Week *> * weeks = [[NSMutableArray alloc] init];
    [weeks addObject:firstWeek];
    Week * runningWeek = firstWeek;
    
    for (int i = 1; i < limit; i++) {
        Week * tmpWeek = [Week new];
        tmpWeek.number = i + 1;
        
        for (Match * match in runningWeek.matches) {
            Player * home;
            Player * away;
            
            if (match.home.index != n) {
                NSInteger index = [players indexOfObjectPassingTest:^BOOL(Player * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return  obj.index == [Utils addA:factor andB:match.home.index withLimit:limit];
                }];
                home = [players objectAtIndex:index];
            }else {
                home = [players lastObject];
            }
            
            if (match.away.index != n) {
                NSInteger index = [players indexOfObjectPassingTest:^BOOL(Player * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return  obj.index == [Utils addA:factor andB:match.away.index withLimit:limit];
                }];
                away = [players objectAtIndex:index];
            }else {
                away = [players lastObject];
            }
            
            
            Match * tmpMatch = [Match new];
            tmpMatch.home = home;
            tmpMatch.away = away;
            tmpMatch.id = [Utils uniqueId];
            
            [tmpWeek.matches addObject:tmpMatch];
        }
        
        Match * firstMatch = [tmpWeek.matches firstObject];
        [tmpWeek.matches replaceObjectAtIndex:0 withObject:[firstMatch swap]];
        
        runningWeek = tmpWeek;
        [weeks addObject:tmpWeek];
        
    }
    
    // remove matches with dummy player
    if (addDummy) {
        [self removeDummyGames: weeks];
    }
    
    //TODO: Implement Issue #1
    if (twoStages) {
        [weeks addObjectsFromArray:[self reversedWeeksFrom:weeks]];
    }
    
    
    return weeks;
}

+ (NSArray<Week *> *) reversedWeeksFrom: (NSArray<Week *> *) weeks {
    NSMutableArray<Week *> * weeksRes = [[NSMutableArray alloc] initWithCapacity:weeks.count];
    int number = (int)weeks.count;
    for (Week * week in weeks) {
        Week * weekTmp = [Week new];
        weekTmp.number = number + 1;
        
        for (Match * match in week.matches) {
            [weekTmp.matches addObject:[match swap]];
        }
        
        [weeksRes addObject:weekTmp];
        number++;
    }
    
    return weeksRes;
    
}

- (NSArray<Week *> *) generateSchedule {
    return  [League generateScheduleFrom:[League convertPlayersToNSArray:self.players] hasTwoStages:self.twoStages];
}

+ (void) removeDummyGames: (NSArray<Week*> *) weeks  {
    
    for (Week * week in weeks) {
       // NSUInteger index = [week.matches indexOfObjectWhere:@"name == Dummy"];
        [week.matches removeObjectAtIndex:0];
    }
    
}

+ (Week *) generateFirstWeekWithTop: (NSArray<Player *> *) top bottom: (NSArray<Player *> *) bottom {
    Week * week = [Week new];
    week.number = 1;
    NSInteger count = top.count;
    
    for (int i = 0; i < count; i++) {
        Match * m = [Match new];
        m.id = [Utils uniqueId];
        
        m.home = bottom[i];
        m.away = top[i];
        
        [week.matches addObject:m];
        
    }
    
    return  week;
    
}

+ (NSArray<Player *> *) convertPlayersToNSArray: (RLMArray<Player *><Player> *) players {
    NSUInteger count = players.count;
    NSMutableArray<Player *> * _players = [[players valueForKey:@"self"] mutableCopy];
    [_players shuffle];
    
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:(count % 2 == 1)? count + 1: count];
    
    int i = 1;
    for (Player * player in _players) {
        player.index = i;
        [array addObject:player];
        i++;
    }
    
    
    
    if (count % 2 == 1) {
        
        [array addObject: [[Player alloc] initWithValue:@{@"name": @"Dummy", @"index": @(i) }]];
    }
    
    
    return array;
    
}

/// 
- (void) updateStatistics {
    
    if (self.weeks.count < self.currentWeek) {
        [self markAsCompleted];
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
        [self markAsCompleted];
    }
    
}

- (void) markAsCompleted {
    Competition * comp = [self.competition firstObject];
    [self.realm beginWriteTransaction];
    
    self.isCompleted = true;
    
    
    comp.winner = [[self.statistics.items sortedResultsUsingDescriptors:@[
                                                                         [RLMSortDescriptor  sortDescriptorWithProperty:@"score" ascending:false],
                                                                         [RLMSortDescriptor  sortDescriptorWithProperty:@"goalsFor" ascending:false],
                                                                         [RLMSortDescriptor sortDescriptorWithProperty:@"goalsDiff" ascending:false]]] firstObject].player;
    [self.realm commitWriteTransaction];
}

@end

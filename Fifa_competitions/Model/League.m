//
//  League.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "League.h"
#import "Utils.h"

@implementation League

+ (NSDictionary *) defaultPropertyValues {
    return @{@"isCompleted": @(false)};
}

+ (NSString *)primaryKey {
    return @"id";
}

- (NSError *) generateMatches {
    
    [self.weeks addObjects:[self generateSchedule]];
    
    return nil;
}

- (NSArray<Week *> *) generateSchedule {
    
    NSUInteger count = self.players.count;
    BOOL addDummy = count % 2 == 1;
    NSUInteger n = count;
    
    if (addDummy) {
        n += 1;
    } 
    
    NSUInteger limit = n - 1;
    NSUInteger factor = n / 2;
    
    // convert RLMArray of Players to NSArray (add Dummy if n % 2 == 1)
    NSArray<Player *> * players = [self convertPlayersToNSArray];
    
    // Separate players into 2 equal arrays
    NSArray<Player*> * top = [players subarrayWithRange:NSMakeRange(0, factor)];
    NSArray<Player*> * bottom = [[players subarrayWithRange:NSMakeRange(factor, factor)] reversedArray];
    
    NSLog(@"Top: %@",top);
    NSLog(@"Bottom: %@", bottom);
    
    
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
            
            [tmpWeek.matches addObject:tmpMatch];
        }
        
        Match * firstMatch = [tmpWeek.matches firstObject];
        tmpWeek.matches[0] = [firstMatch swap];
        
        runningWeek = tmpWeek;
        [weeks addObject:tmpWeek];
        
    }
    
    // remove matches with dummy player
    if (addDummy) {
        [self removeDummyGames: weeks];
    }
    
    
    return weeks;
}

- (void) removeDummyGames: (NSArray<Week*> *) weeks  {
    
    for (Week * week in weeks) {
        [week.matches removeObjectAtIndex:0];
    }
    
    
    
}

- (Week *) generateFirstWeekWithTop: (NSArray<Player *> *) top bottom: (NSArray<Player *> *) bottom {
    Week * week = [Week new];
    week.number = 1;
    NSInteger count = top.count;
    
    for (int i = 0; i < count; i++) {
        Match * m = [Match new];
        
        m.home = top[i];
        m.away = bottom[i];
        
        [week.matches addObject:m];
        
    }
    
    return  week;
    
}

- (NSArray<Player *> *) convertPlayersToNSArray {
    NSUInteger count = self.players.count;
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:(count % 2 == 1)? count + 1: count];
    
    int i = 1;
    for (Player * player in self.players) {
        player.index = i;
        [array addObject:player];
        i++;
    }
    
    if (count % 2 == 1) {
        [array addObject: [[Player alloc] initWithValue:@{@"name": @"Dummy", @"index": @(i) }]];
    }
    
    return array;
    
}

@end

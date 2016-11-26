//
//  Match.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Match.h"


@implementation Match

+ (NSDictionary *)defaultPropertyValues {
    return @{@"homeGoals" : @(-1), @"awayGoals": @(-1), @"played": @(false), @"statsFlag" : @(false)};
}

+ (NSString *) primaryKey {
    return @"id";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.id = [Utils uniqueId];
    }
    return self;
}

- (Match *) swap {
    
    Match * newMatch = [[Match alloc] init];
    newMatch.id = [Utils uniqueId];
    
    newMatch.home = self.away;
    newMatch.away = self.home;
    
    return newMatch;
    
}

@end

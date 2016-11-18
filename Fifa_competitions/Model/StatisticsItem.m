//
//  StatisticsItem.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "StatisticsItem.h"

@implementation StatisticsItem

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"gamesPlayed": @(0),
             @"wins" : @(0),
             @"draws": @(0),
             @"loses" : @(0),
             @"goalsFor": @(0),
             @"goalsAgainst" : @(0),
             @"goalsDiff": @(0)
             };
}

+ (NSString *)primaryKey {
    return @"id";
}

@end

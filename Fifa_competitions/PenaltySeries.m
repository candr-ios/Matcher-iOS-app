//
//  PenaltySeries.m
//  Fifa_competitions
//
//  Created by Stepan Paholyk on 11/25/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "PenaltySeries.h"

@implementation PenaltySeries


+ (NSDictionary *)defaultPropertyValues {
    return @{@"homeGoals" : @(-1), @"awayGoals": @(-1), @"played": @(false)};
}

+ (NSString *) primaryKey {
    return @"id";
}

- (instancetype)initWithFirstPlayer:(Player*)player1 andSecondPlayer:(Player*)player2
{
    self = [super init];
    if (self) {
        self.home = player1;
        self.away = player2;
        self.id = [Utils uniqueId];
    }
    return self;
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end

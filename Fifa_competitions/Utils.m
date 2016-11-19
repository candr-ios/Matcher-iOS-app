//
//  Utils.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/19/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSUInteger) addA: (NSUInteger) a andB: (NSUInteger)b withLimit: (NSUInteger) limit {
    NSUInteger res = (a + b ) % limit;
    return (res == 0) ? limit : res;
}

@end

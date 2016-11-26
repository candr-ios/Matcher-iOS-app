//
//  NSMutableArray+Shuffling.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/25/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"
@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    if (count < 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end

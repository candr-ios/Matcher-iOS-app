//
//  Utils.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/19/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSUInteger) addA: (NSUInteger) a andB: (NSUInteger)b withLimit: (NSUInteger) limit;

+ (NSString *) uniqueId;

@end


@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end

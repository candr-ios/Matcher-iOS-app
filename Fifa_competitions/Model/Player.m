//
//  Player.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Player.h"


@implementation Player

+ (NSArray<NSString *> *) indexedProperties {
    return  @[@"index"];
}

+ (NSString *) primaryKey {
    return @"id";
}

- (instancetype)initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.id = [Utils uniqueId];
    }
    return self;
}
@end

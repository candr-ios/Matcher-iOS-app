//
//  KnockoutStage.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "KnockoutStage.h"

@implementation KnockoutStage

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *) defaultPropertyValues {
    return  @{@"type": @(Round16)};
}

- (NSError*) generateMathesForCurrenrStage
{
    NSMutableArray *matches = [NSMutableArray array];
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            match.home = self.players[i-1];
            match.away = self.players[i];
            [matches addObject:match];
        }
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObjectsFromArray:matches];
    [realm commitWriteTransaction];
    
    self.matches = matches;
    return nil;
}


@end

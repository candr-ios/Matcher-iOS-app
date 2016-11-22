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
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            match.home = self.players[i-1];
            match.away = self.players[i];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:match];
            [realm commitWriteTransaction];
            [self.matches addObject:match];
        }
    }
    
    return nil;
}


@end

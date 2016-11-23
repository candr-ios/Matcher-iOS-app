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
    
//    [self checkForWinner];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            match.home = self.players[i-1];
            match.away = self.players[i];
            [realm addOrUpdateObject:match];
            [self.matches addObject:match];
        }
    }
    [realm commitWriteTransaction];
    
    return nil;
}

- (void)setRandomGoalsForMatches
{
    
    [self.realm beginWriteTransaction];
    for (Match *match in self.matches) {
        match.homeGoals = arc4random() % 5;
        match.awayGoals = arc4random() % 5;
        if (match.homeGoals == match.awayGoals) {
            match.homeGoals = match.homeGoals+1;
        }
    }
    self.isComplete = YES;
    [self.realm commitWriteTransaction];
}


- (void) shiftsStage
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.type = self.type >> 1;
    [realm commitWriteTransaction];
}
@end

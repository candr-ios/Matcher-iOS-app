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
    
    [self.realm beginWriteTransaction];
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            match.home = self.players[i-1];
            match.away = self.players[i];
            [self.realm addObject:match];
            [self.matches addObject:match];
        }
    }
    [self.realm commitWriteTransaction];
    
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

/// return StageType of tournament(1/16, 1/8, 1/4, 1/2, final) based on enum KnockoutStageType
/// using shifted bytes
- (void) setTypeOfCurrentStage
{
    int numberOfPlayers = (int)[self.players count];
    
    BOOL stageIsFound = NO;
    
    while (!stageIsFound) {
        
        if (numberOfPlayers == self.type) {
            stageIsFound = YES;
            
        } else {
            
            [self.realm beginWriteTransaction];
            self.type = self.type >> 1;
            [self.realm commitWriteTransaction];
            
        }
    }
    
}
@end

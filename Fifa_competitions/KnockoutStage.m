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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.id = [Utils uniqueId];
    }
    return self;
}

#pragma mark - Initial

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

#pragma mark -

- (NSError*) generateMathesForCurrenrStage
{
    
//    [self checkForWinner];
    
    [self.realm beginWriteTransaction];
    for (int i = 0; i < [self.players count]; i++) {
        if (i%2 == 1) {
            Match *match = [[Match alloc] init];
            Player *homePlayer = self.players[i-1];
            match.home = homePlayer;
            Player *awayPlayer = self.players[i];
            match.away =awayPlayer;
            [self.realm addObject:match];
            [self.matches addObject:match];
        }
    }
    [self.realm commitWriteTransaction];
    
    return nil;
}


/// Get winners of currentstage matches
/// Creates temp array with winners and => self.players
- (void) generatePlayersForCurrentStage {
    
    NSMutableArray *newPlayers = [NSMutableArray array];

    for (Match *match in self.matches) {
        // get matches winners
        Player *winnerOfTheMatch = [self winerOfMatch:match];
        [newPlayers addObject:winnerOfTheMatch];
    }
    [self.realm beginWriteTransaction];     /// TODO: self.realm
    
    self.players = (RLMArray<Player*><Player>*)newPlayers;
    [self.realm commitWriteTransaction];    /// TODO: self.realm

}



/// If round 16 is played >> round8(QuaterFinal) AND SO ON
- (void) shiftsStage
{
    [self.realm beginWriteTransaction];
    self.type = self.type >> 1;
    [self.realm commitWriteTransaction];
}

/// Takes as arg. a singme Match
/// Return -> winners of that Match
- (Player*) winerOfMatch:(Match*)match {
    Player *winner;
    if (match.homeGoals > match.awayGoals) {
        winner = match.home;
    } else {
        winner = match.away;
    }
    return winner;
}

#pragma mark - Test

/// For test
/// Set up random score between Players in each match of Stage
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

@end

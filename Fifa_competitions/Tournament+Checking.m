//
//  Tournament+Checking.m
//  Fifa_competitions
//
//  Created by Stepan Paholyk on 11/20/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Tournament+Checking.h"

@implementation Tournament (Checking)

/// Check for [number of players must be dividable by log(numberOfPlayers)]
- (BOOL) validNumberOfPlayers
{
    NSUInteger numberOfPlayers = [self.players count];

    while (numberOfPlayers > 1) {
        numberOfPlayers = numberOfPlayers / 2;
    }
    if (numberOfPlayers == 1) {
        return true;
    } else {
        return false;
    }
}

/// return StageType of tournament(1/16, 1/8, 1/4, 1/2, final) based on enum KnockoutStageType
/// using shifted bytes
- (KnockoutStage*) typeOfInitialRound
{
    KnockoutStage *stage = [KnockoutStage new];
    NSUInteger numberOfPlayers = [self.players count];
    BOOL stageIsFound = NO;
    stage.type = Round16;

    while (!stageIsFound) {
        if (numberOfPlayers == stage.type) {
            stageIsFound = YES;
        } else {
            stage.type = stage.type << 1;
            numberOfPlayers = numberOfPlayers/2;
        }
    }
    return stage;
}

@end

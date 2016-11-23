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

@end

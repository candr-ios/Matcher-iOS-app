//
//  Competition.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Competition.h"
#import "Tournament.h"
#import "League.h"

@implementation Competition

+ (NSString *)primaryKey {
    return @"id";
}

- (BOOL) completeSetup {
    
    if (self.type == CompetitionTypeTournament) {
        Tournament * t = self.tournament;
        
        if (t == nil && t.players.count == 0) {
            return false;
        }
        
        // if group tournament
        if (t.shouldHaveGroups) {
            if( [t generateGroups] == nil) {
                return false;
            }
        } else if ([t generateInitialKnockoutStage] == nil) {
            return false;
        }
        
        // Save competition
        [self save];
        
        return true;
    }
    
    // Setup league
    League *  l = self.league;
    
    if (l == nil && l.players.count == 0) {
        return false;
    }
    
    [l generateMatches];
    
    [self save];

    return true;
}

- (void) save {
    RLMRealm * realm = [RLMRealm defaultRealm];
    
    // Save competition
    [realm beginWriteTransaction];
    
    [realm addOrUpdateObject:self];
    
    [realm commitWriteTransaction];
}

@end

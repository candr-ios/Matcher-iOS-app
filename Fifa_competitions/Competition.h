//
//  Competition.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Player.h"
@class League;
@class Tournament;

typedef enum : int {
    CompetitionTypeLeague,
    CompetitionTypeTournament
} CompetitionType;

@interface Competition : RLMObject

@property NSString * id;
@property CompetitionType  type;
@property NSString * title;
@property NSDate * dateCreated;
@property Player * winner;
@property League * league;
@property Tournament * tournament;


/// Prepare competition for usage.
/// Generate groups, matches and save it into data base
///
/// ! Competition should not be saved in db
///
/// Returns: true if all right, false it players not setted or league or tournament don't exist

- (BOOL) completeSetup;

@end

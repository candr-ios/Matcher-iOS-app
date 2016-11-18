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

@interface Competition : RLMObject

@property NSString * id;
@property int  type;
@property NSString * title;
@property NSDate * dataCreated;
@property Player * winner;
@property League * league;
@property Tournament * tournament;

@end

//
//  Match.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Utils.h"
@class Player;

@interface Match : RLMObject

@property NSString * id;

@property Player * home;
@property Player * away;

@property int homeGoals;
@property int awayGoals;

@property BOOL played;

@property BOOL statsFlag; // if already in statistics;

- (Match *) swap;


@end
RLM_ARRAY_TYPE(Match)

//
//  Group.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Player.h"
#import "Week.h"
#import "Statistics.h"


@interface Group : RLMObject

@property NSString * id;
@property NSString * name;
@property RLMArray<Player *><Player> * players;
@property RLMArray<Week *><Week> * weeks;
@property Statistics * statistics;

@end

RLM_ARRAY_TYPE(Group)

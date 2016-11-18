//
//  StatisticsItem.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Match.h"
@class Player;

@interface StatisticsItem : RLMObject

@property Player * player;

@property NSString * id;
@property int gamesPlayed;
@property int wins;
@property int draws;
@property int loses;
@property int goalsFor;
@property int goalsAgainst;
@property int goalsDiff;
@property int score;
@property int full_score;
@property RLMArray<Match *><Match> * matches;



@end

RLM_ARRAY_TYPE(StatisticsItem)

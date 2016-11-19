//
//  League.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Player.h"
#import "Week.h"
@class Statistics;

@interface League : RLMObject

@property  NSInteger id;
@property BOOL twoStages;
@property RLMArray<Player *><Player> * players;
@property RLMArray<Week *><Week> * weeks;
@property Statistics * statistics;
@property BOOL isCompleted;

- (NSError *) generateMatches;


@end

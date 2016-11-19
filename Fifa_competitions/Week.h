//
//  Week.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Match.h"

@interface Week : RLMObject

@property int number;

@property BOOL isCompleted;
@property RLMArray<Match *><Match> * matches;

@end

RLM_ARRAY_TYPE(Week)


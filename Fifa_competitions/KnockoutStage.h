//
//  KnockoutStage.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Match.h"


typedef enum : int {
    Round16 = 16,
    Round8 = 8,
    Round4 = 4,
    Round2 = 2,
    RoundForThirdPlace = 1,
} KnockoutStageType;

@interface KnockoutStage : RLMObject

@property NSString * id;
@property KnockoutStageType  type;
@property RLMArray<Match *><Match> * matches;

@end


RLM_ARRAY_TYPE(KnockoutStage)

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
    FirstRound,
    Round16,
    Quarterfinal,
    Semifinal,
    Final
} KnockoutStageType;

@interface KnockoutStage : RLMObject

@property NSString * id;
@property int  type;
@property RLMArray<Match *><Match> * matches;

@end


RLM_ARRAY_TYPE(KnockoutStage)

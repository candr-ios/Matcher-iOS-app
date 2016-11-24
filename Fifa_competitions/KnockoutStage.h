//
//  KnockoutStage.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Match.h"
#import "Player.h"
#import "Utils.h"


typedef enum : int {
    Round16 = 16,
    QuaterFinal = 8,
    SemiFinal = 4,
    Final = 2,
    ThirdPlace = 1,
} KnockoutStageType;

@interface KnockoutStage : RLMObject

@property NSString * id;
@property KnockoutStageType  type;
@property RLMArray<Match *><Match> * matches;
@property RLMArray<Player *><Player> *players;
@property BOOL isComplete;
//new

- (instancetype)initWithPlayers:(id)players;

- (KnockoutStageType) typeOfCurrentStage;

- (NSArray*) winnersOfStage;
- (NSError*) generateMathesForCurrenrStage;

- (void)setRandomGoalsForMatches;

@end

RLM_ARRAY_TYPE(KnockoutStage)

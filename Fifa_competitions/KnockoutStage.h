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
#import "PenaltySeries.h"


typedef enum : int {
    Round16 = 32,
    Round8 = 16,
    QuaterFinal = 8,
    SemiFinal = 4,
    ThirdPlace = 2,
    Final = 1
} KnockoutStageType;

@interface KnockoutStage : RLMObject

@property NSString * id;
@property KnockoutStageType type;
@property RLMArray<Match *><Match> * matches;
@property RLMArray<Player *><Player> *players;
@property BOOL isComplete;
@property RLMArray<PenaltySeries*><PenaltySeries>* penaltySeries;
//new
- (NSString *) typeString;

- (BOOL) isAllMatchesPlayed;

- (KnockoutStageType) typeOfInitialStage;
- (instancetype)initWithPlayers:(NSArray<Player *> *)players;

- (NSArray<Player*>*) winnersOfStage;
- (NSError*) generateMathesForCurrenrStage;

- (NSArray<Player*>*) losersOfStage;
- (void)setRandomGoalsForMatches;

@end

RLM_ARRAY_TYPE(KnockoutStage)

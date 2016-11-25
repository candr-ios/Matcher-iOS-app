//
//  Tournament.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Player.h"
#import "Group.h"
#import "KnockoutStage.h"
#import "Utils.h"

@interface Tournament : RLMObject


@property KnockoutStage *currentStage;
@property BOOL isInitialized;
@property NSString * id;
@property RLMArray<Player *><Player> * players;
@property BOOL hasGroupStage;
@property RLMArray<Group*><Group> * groups;
@property BOOL isGroupStageCompleted;
@property RLMArray<KnockoutStage*><KnockoutStage> * knockoutStages;
@property BOOL isCompleted;
@property Player * winner;

- (instancetype)initWithPlayers:(RLMArray<Player *><Player> *)players;

- (NSError *) generateGroups;
- (NSError *) generateInitialKnockoutStageFromGroups;

- (NSError*) genereteInitialKnockoutStageWithPlayers:(RLMArray<Player*><Player>*)players;
- (NSError *) generateNextKnockoutStage;

@end

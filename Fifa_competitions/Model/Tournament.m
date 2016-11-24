//
//  Tournament.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "Tournament.h"
#import "Tournament+Checking.h"


@implementation Tournament

+ (NSDictionary *) defaultPropertyValues {
    return @{@"isGroupStageCompleted": @(false),@"isCompleted": @(false), @"isInitialized":@(false)};
}

+ (NSString *)primaryKey {
    return @"id";
}


#pragma mark - Initialization


/// Make initialization for Tournament object with players and reakm
/// Choose to generate Knockout stage OR Groups based on players count
- (instancetype)initWithPlayers:(RLMArray<Player *><Player> *)players
{
    self = [super init];
    if (self) {
        // id
        self.id = [Utils uniqueId];
        //
        self.players = players;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:players];
        [realm commitWriteTransaction];
        
        if ([self validNumberOfPlayers]) {
            [self.players count] <= 16 ? [self genereteInitialKnockoutStageWithPlayers:players] : [self generateGroups];
            self.isInitialized = YES;
        }
    }
    return self;
}


#pragma mark - For Initial Stage

///new
- (NSError*) genereteInitialKnockoutStageWithPlayers:(RLMArray<Player*><Player>*)players {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KnockoutStage *initialStage = [[KnockoutStage alloc] initWithPlayers:players];
    [initialStage typeOfCurrentStage];
    [initialStage generateMathesForCurrenrStage];
    
    [realm beginWriteTransaction];
    [self.knockoutStages addObject:initialStage];
    self.currentStage = initialStage;
    [realm commitWriteTransaction];
    [initialStage setRandomGoalsForMatches];
    
    return nil;
}


- (NSError*) generateNextKnockoutStage
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if ([self.currentStage isComplete] && [self.currentStage.matches count] == 1) {
        if (!self.isCompleted) {
            [realm beginWriteTransaction];
            self.winner = [[self.currentStage winnersOfStage] objectAtIndex:0];
            self.isCompleted = YES;
            [realm commitWriteTransaction];
        }
    } else {
        
        KnockoutStage *newStage = [[KnockoutStage alloc] initWithPlayers:[self.currentStage winnersOfStage]];
        
        newStage.type = [newStage typeOfCurrentStage];
        [newStage generateMathesForCurrenrStage];

        [realm beginWriteTransaction];
        [self.knockoutStages addObject:newStage];
        self.currentStage = newStage;
        [realm commitWriteTransaction];
    }
    return nil;
}

@end

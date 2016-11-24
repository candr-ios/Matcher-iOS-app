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
            [self.players count] <= 16 ? [self genereteInitialKnockoutStage] : [self generateGroups];
        }
    }
    return self;
}


#pragma mark - For Initial Stage


/// Create KnockotStage add there players from tournament
/// Decide what round corresponds to this stage, generate matches for stage
/// Add Stage in Realm model db
- (NSError *) genereteInitialKnockoutStage
{
    
    
    KnockoutStage *initialStage = [[KnockoutStage alloc] init];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [self.realm beginWriteTransaction];
    initialStage.players = self.players;
    [self.realm beginWriteTransaction];
    
    
    [initialStage setTypeOfCurrentStage];
    [initialStage generateMathesForCurrenrStage];
    
    self.currentStage = initialStage;
    
    [self.realm beginWriteTransaction];
    [self.realm addOrUpdateObject:self.currentStage];
    [self.realm commitWriteTransaction];

    return nil;
}


#pragma mark - Next Stages

/// Call's out of this class scope for prepape
/// Create new kcockout stage {
///     generate next type of stage
///     setUp Players
///     setUpMatches
/// }
- (NSError *) generateNextKnockoutStage
{
    if (![self winner] && [self.currentStage isComplete]) {
        [self.currentStage shiftsStage];
        [self.currentStage generatePlayersForCurrentStage];
        [self.currentStage generateMathesForCurrenrStage];
    }
    return nil;
}

#pragma mark - Checks

// If 1 players left in Stage --> YES
- (BOOL) winner
{
    return [self.currentStage.players count] == 1 ? YES && self.isCompleted == YES : NO;
}

@end

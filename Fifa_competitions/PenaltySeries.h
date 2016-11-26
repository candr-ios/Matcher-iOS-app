//
//  PenaltySeries.h
//  Fifa_competitions
//
//  Created by Stepan Paholyk on 11/25/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "Player.h"
#import "Utils.h"

@interface PenaltySeries : RLMObject
@property NSString * id;

@property Player * home;
@property Player * away;

@property int homeGoals;
@property int awayGoals;

@property BOOL played;


- (instancetype)initWithFirstPlayer:(Player*)player1 andSecondPlayer:(Player*)player2;

@end


// This protocol enables typed collections. i.e.:
// RLMArray<PenaltySeries>
RLM_ARRAY_TYPE(PenaltySeries)

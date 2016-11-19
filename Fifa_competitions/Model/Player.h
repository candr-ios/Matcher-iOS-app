//
//  Player.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
@class Club;

@interface Player : RLMObject

@property NSString * id;
@property NSString * name;
@property Club * club;
@property int index;

@end

RLM_ARRAY_TYPE(Player)

//
//  Club.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>

@interface Club : RLMObject

@property NSString * title;
@property NSString * logoImageName;

@end

RLM_ARRAY_TYPE(Club);

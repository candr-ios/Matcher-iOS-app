//
//  Statistics.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/18/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <Realm/Realm.h>
#import "StatisticsItem.h"

@interface Statistics : RLMObject
// we can add few properties for overall statistics

@property RLMArray<StatisticsItem *><StatisticsItem> * items;

@end

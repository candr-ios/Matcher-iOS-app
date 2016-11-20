//
//  PlayerSetupViewController.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "CreateCompetitionBaseViewController.h"
@class Competition;

@interface PlayerSetupViewController : CreateCompetitionBaseViewController

@property (nonatomic, strong) Competition * competition;
@property (assign) NSInteger count;
@property (assign) NSUInteger numberOfPlayers;

@end

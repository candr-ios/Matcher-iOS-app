//
//  CongratulationWinnerViewController.h
//  Fifa_competitions
//
//  Created by Stepan Paholyk on 11/28/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "ViewController.h"
#import "Player.h"

@interface CongratulationWinnerViewController : ViewController

@property (nonatomic, weak) Player* player;
@property (nonatomic, weak) UIImageView *clubImageView;
@end

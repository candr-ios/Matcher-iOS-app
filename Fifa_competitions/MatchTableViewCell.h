//
//  MatchTableViewCell.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/14/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface MatchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *awayLogoImageView;

@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *awayScoreTextField;

@property (weak, nonatomic) IBOutlet UILabel *homeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayNameLabel;

@property (nonatomic, strong) Match * match;

@end

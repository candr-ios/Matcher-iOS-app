//
//  CompetitionTableViewCell.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 12/1/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Competition;

@interface CompetitionTableViewCell : UITableViewCell

@property (nonatomic, strong) Competition * competition;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *competitionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *winnerClubImageView;
@property (weak, nonatomic) IBOutlet UILabel *winnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

@end

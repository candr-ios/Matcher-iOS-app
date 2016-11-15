//
//  StatsTableViewCell.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/15/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString * statisticsItem; //TODO: replace with real statistics item object

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gpLabel;
@property (weak, nonatomic) IBOutlet UILabel *wLabel;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;
@property (weak, nonatomic) IBOutlet UILabel *lLabel;
@property (weak, nonatomic) IBOutlet UILabel *gfLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaLabel;
@property (weak, nonatomic) IBOutlet UILabel *gdLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIView *formStatsContrainer;




@end

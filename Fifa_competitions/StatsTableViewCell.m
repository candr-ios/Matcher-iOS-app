//
//  StatsTableViewCell.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/15/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "StatsTableViewCell.h"

@implementation StatsTableViewCell

- (void)setStatisticsItem:(NSString *)statisticsItem {
    _statisticsItem = statisticsItem;
    
    // Configure views
    
    self.gpLabel.text = @"5";
    self.wLabel.text = @"3";
    self.dLabel.text = @"0";
    self.lLabel.text = @"2";
    self.gfLabel.text = @"8";
    self.gaLabel.text = @"7";
    self.gdLabel.text = @"+1";
    self.pointsLabel.text = @"9";
    self.logoImageView.image = [UIImage imageNamed:@"barca"];
    self.playerNameLabel.text = @"Stepanch";
    
    self.playerNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.playerNameLabel.minimumScaleFactor = 0.8;
    self.playerNameLabel.adjustsFontSizeToFitWidth = YES;
    
    
    self.pointsLabel.minimumScaleFactor = 0.6;
    self.pointsLabel.adjustsFontSizeToFitWidth = YES;
    
    // 6:32
    self.formStatsContrainer.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < 4; i++ ) {
        UIView * box = [UIView new];
        box.frame = CGRectMake(0, i * 8, 6, 6);
        
        if (i < 2) {
            box.backgroundColor = [UIColor colorWithRed:0.27 green:0.86 blue:0.37 alpha:1.00];
        } else if (i == 2) {
            box.backgroundColor = [UIColor colorWithRed:1.00 green:0.16 blue:0.32 alpha:1.00];
        } else {
            box.backgroundColor = [UIColor colorWithRed:1.00 green:0.80 blue:0.00 alpha:1.00];
        }
        
        [self.formStatsContrainer addSubview:box];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

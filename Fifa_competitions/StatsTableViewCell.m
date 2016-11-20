//
//  StatsTableViewCell.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/15/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "StatsTableViewCell.h"
#import "Player.h"
#import "Club.h"

@implementation StatsTableViewCell

- (void)setStatisticsItem:(StatisticsItem *)statisticsItem {
    _statisticsItem = statisticsItem;
    
    // Configure views
    
    self.gpLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.gamesPlayed];
    self.wLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.wins] ;
    self.dLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.draws] ;
    self.lLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.loses] ;
    self.gfLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.goalsFor] ;
    self.gaLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.goalsAgainst];
    self.gdLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.goalsDiff];
    self.pointsLabel.text = [NSString stringWithFormat:@"%d",statisticsItem.score];
    self.logoImageView.image = [UIImage imageNamed:statisticsItem.player.club.logoImageName];
    self.playerNameLabel.text = statisticsItem.player.name;
    
    self.playerNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.playerNameLabel.minimumScaleFactor = 0.8;
    self.playerNameLabel.adjustsFontSizeToFitWidth = YES;
    
    
    self.pointsLabel.minimumScaleFactor = 0.6;
    self.pointsLabel.adjustsFontSizeToFitWidth = YES;
    
    // 6:32
    self.formStatsContrainer.backgroundColor = [UIColor clearColor];
    
    int count = 1;
    int x = 0;
    for (int i = (int)statisticsItem.matches.count - 1; i >= 0 && count < 5 ;x++, i--,count++ ) {
        
        UIView * box = [UIView new];
        box.frame = CGRectMake(0, x * 8, 6, 6);
        
        Match * m = statisticsItem.matches[i];
        
        
        BOOL condition = false;
        if( m.home.id == statisticsItem.player.id) {
            condition = m.homeGoals > m.homeGoals;
        } else {
            condition = m.homeGoals < m.homeGoals;
        }
        
        
        
        if (condition) {
            box.backgroundColor = [UIColor colorWithRed:0.27 green:0.86 blue:0.37 alpha:1.00];
        } else if (m.homeGoals == m.homeGoals) {
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

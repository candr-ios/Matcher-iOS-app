//
//  CompetitionTypeTableViewCell.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/26/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "CompetitionTypeTableViewCell.h"

@implementation CompetitionTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.competitionImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.00];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }

    
}

@end

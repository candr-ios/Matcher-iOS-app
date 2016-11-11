//
//  ClubCollectionViewCell.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "ClubCollectionViewCell.h"

@implementation ClubCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.layer.cornerRadius = 7;
    [self setClipsToBounds:true];
}

- (void) setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.22 green:0.21 blue:0.21 alpha:1.00];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end

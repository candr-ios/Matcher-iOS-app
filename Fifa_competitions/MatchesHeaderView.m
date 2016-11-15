//
//  MatchesHeaderView.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/15/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "MatchesHeaderView.h"

@implementation MatchesHeaderView



- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [UILabel new];
        self.title.textColor = [UIColor whiteColor];
        
        [self addSubview:self.title];
        
        [self.title setTranslatesAutoresizingMaskIntoConstraints:false];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-|" options:0 metrics:nil views:@{@"title": self.title}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[title]-5-|" options:0 metrics:nil views:@{@"title": self.title}]];
        
        self.contentView.backgroundColor =  [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}




@end

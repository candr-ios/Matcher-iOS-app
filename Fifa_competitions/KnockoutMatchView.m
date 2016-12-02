//
//  KnockoutMatchView.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 12/1/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "KnockoutMatchView.h"
#import "Match.h"
#import "Player.h"
#import "Club.h"

@interface KnockoutMatchView ()

@property (nonatomic, strong) UILabel * homeLabel;
@property (nonatomic, strong) UILabel * awayLabel;
@property (nonatomic, strong) UIImageView * homeImageView;
@property (nonatomic, strong) UIImageView * awayImageView;
@property (nonatomic, strong) UILabel * homeScoreLabel;
@property (nonatomic, strong) UILabel * awayScoreLabel;

@end



@implementation KnockoutMatchView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void) setMatch:(Match *)match {
    _match = match;
    
    self.homeLabel.text = match.home.name;
    self.awayLabel.text = match.away.name;
    self.homeImageView.image = [UIImage imageNamed:match.home.club.logoImageName];
    self.awayImageView.image = [UIImage imageNamed:match.away.club.logoImageName];
    
    if (self.match.played) {
        self.homeScoreLabel.text = [NSString stringWithFormat:@"%d", match.homeGoals];
        self.awayScoreLabel.text = [NSString stringWithFormat:@"%d", match.awayGoals];
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
    } else {
        self.homeScoreLabel.text = @"-";
        self.awayScoreLabel.text = @"-";
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    
}

- (void) createViews {
    
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    
    self.homeLabel = [UILabel new];
    self.homeLabel.textColor = [UIColor whiteColor];
    self.homeLabel.font = [UIFont systemFontOfSize:14];
    
    self.awayLabel = [UILabel new];
    self.awayLabel.textColor = [UIColor whiteColor];
    self.awayLabel.font = [UIFont systemFontOfSize:14];
    
    self.homeImageView = [[UIImageView alloc] init];
    self.homeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.awayImageView = [[UIImageView alloc] init];
    self.awayImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.homeScoreLabel = [UILabel new];
    self.homeScoreLabel.textColor = [UIColor whiteColor];
    self.homeScoreLabel.font = [UIFont systemFontOfSize:14];
    
    self.awayScoreLabel = [UILabel new];
    self.awayScoreLabel.textColor = [UIColor whiteColor];
    self.awayScoreLabel.font = [UIFont systemFontOfSize:14];
    
    _homeLabel.translatesAutoresizingMaskIntoConstraints = false;
    _awayLabel.translatesAutoresizingMaskIntoConstraints = false;
    _awayImageView.translatesAutoresizingMaskIntoConstraints = false;
    _homeImageView.translatesAutoresizingMaskIntoConstraints = false;
    _homeScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
    _awayScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
    //self.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addSubview:_homeLabel];
    [self addSubview:_awayLabel];
    [self addSubview:_awayImageView];
    [self addSubview:_homeImageView];
    [self addSubview:_homeScoreLabel];
    [self addSubview:_awayScoreLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[image(15)]-2-[name]-2-[score(20)]-0-|" options:0 metrics:nil views:@{@"image": _homeImageView, @"name": _homeLabel, @"score": _homeScoreLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[image(15)]-2-[name]-2-[score(20)]-0-|" options:0 metrics:nil views:@{@"image": _awayImageView, @"name": _awayLabel, @"score": _awayScoreLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[homeImage(15)]-4-[awayImage]-2-|" options:0 metrics:nil views:@{@"homeImage": _homeImageView, @"awayImage": _awayImageView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[homeLabel(17)]-2-[awayLabel]-1-|" options:0 metrics:nil views:@{@"homeLabel": _homeLabel, @"awayLabel": _awayLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[homeScoreLabel(17)]-2-[awayScoreLabel]-1-|" options:0 metrics:nil views:@{@"homeScoreLabel": _homeScoreLabel, @"awayScoreLabel": _awayScoreLabel}]];
    
    
    
}

@end

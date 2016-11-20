//
//  CreateCompetitionBaseViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "CreateCompetitionBaseViewController.h"

@interface CreateCompetitionBaseViewController ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * backButton;


@end

@implementation CreateCompetitionBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureViews];
    
    self.titleLabel.text = self.title;
    self.subTitleLabel.text = @"two stages";
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    
    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/// Accepts array of players and returns array of balanced tournament matches
- (void) configureViews {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:19];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.font = [UIFont systemFontOfSize:15];
    _subTitleLabel.textColor = [UIColor lightGrayColor];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _backButton = [UIButton new];
    
    [_backButton setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    
    _nextButton = [UIButton new];
    [_nextButton setImage: [UIImage imageNamed:@"next-arrow"] forState:UIControlStateNormal];
    [_nextButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)];
    [_nextButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 140.0, 0.0, 0.0)];
    [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    
    
    _subTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    _backButton.translatesAutoresizingMaskIntoConstraints = false;
    _nextButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [_backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:_nextButton];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_subTitleLabel];
    [self.view addSubview:_backButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[next(25)]-30-|" options:0 metrics:NULL views:@{@"next":self.nextButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[next]-50-|" options:0 metrics:NULL views:@{@"next":self.nextButton}]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[title(25)]-0-[subtitle(18)]" options:0 metrics:NULL views:@{@"title":self.titleLabel, @"subtitle": self.subTitleLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[title]-20-|" options:0 metrics:NULL views:@{@"title":self.titleLabel}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[subtitle]-20-|" options:0 metrics:NULL views:@{@"subtitle":self.subTitleLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[back(25)]" options:0 metrics:NULL views:@{@"back":self.backButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[back(30)]" options:0 metrics:NULL views:@{@"back":self.backButton}]];
    
    
    
    /// add tap gesture
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willResignFirstResponder {
    
}

- (void) willPopViewController {
    
}

- (void) didTapBackButton: (UIButton *) sender {
    [self willPopViewController];
    [self.navigationController popViewControllerAnimated:true];
}

- (void) didTapView:(UITapGestureRecognizer *) tap {
    for (UIView * view in self.view.subviews) {
        if (view.isFirstResponder) {
            [self willResignFirstResponder];
            [view resignFirstResponder];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MatchesViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/14/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchTableViewCell.h"

@interface MatchesViewController ()

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MatchesViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
     [[self navigationController] setNavigationBarHidden:NO animated:false];
}

- (void) loadView {
    self.tableView = [[UITableView alloc] init];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.homeLogoImageView.image = [UIImage imageNamed:@"barca"];
    cell.awayLogoImageView.image = [UIImage imageNamed:@"barca"];
    
    cell.homeNameLabel.text = @"Martin";
    cell.awayNameLabel.text = @"Steven";
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchTableViewCell * matchCell = [tableView cellForRowAtIndexPath:indexPath];
    matchCell.homeScoreTextField.userInteractionEnabled = true;
    [matchCell.homeScoreTextField becomeFirstResponder];
    
    [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchTableViewCell * matchCell = [tableView cellForRowAtIndexPath:indexPath];
    matchCell.homeScoreTextField.userInteractionEnabled = false;
    matchCell.awayScoreTextField.userInteractionEnabled = false;
}




@end

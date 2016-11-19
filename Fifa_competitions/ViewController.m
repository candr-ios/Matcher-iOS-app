//
//  ViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "ViewController.h"
#import "SetupCompetitionViewController.h"
#import "MatchesViewController.h"
#import "Club.h"
#import "Player.h"
#import "League.h"
#import "Utils.h"
#import "Statistics.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel * messageLabel;


@end

@implementation ViewController


- (void) loadView {
    self.tableView = [[UITableView alloc] init];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Competitions";
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self configureTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(didTapAddButton:)];
    
    self.competitions = @[];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXNotification:) name:@"X" object:nil];
    
    
    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    
    RLMRealm * realm = [RLMRealm defaultRealm];
    
    
    League * l = [League new];
    l.id = [Utils uniqueId];
    
    l.statistics = [Statistics new];
    
    [l.players addObjects:@[[[Player alloc] initWithValue: @{@"name": @"Andy", @"id": [Utils uniqueId]}],
                            [[Player alloc] initWithValue: @{@"name": @"Steven", @"id": [Utils uniqueId]}],
                            [[Player alloc] initWithValue: @{@"name": @"Clark", @"id": [Utils uniqueId]}]
//                            [[Player alloc] initWithValue: @{@"name": @"Michael", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Andy 2", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Steven 2", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Clark 2", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Michael 2", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Andy 3", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Steven 3", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Clark 3", @"id": [Utils uniqueId]}],
//                            [[Player alloc] initWithValue: @{@"name": @"Michael 3", @"id": [Utils uniqueId]}]
                            ]];
    
    for (Player * player in l.players) {
        StatisticsItem * item = [[StatisticsItem alloc] init];
        item.player = player;
        item.id = [Utils uniqueId];
        
        [l.statistics.items addObject:item];
    }
    
    [l generateMatches];
    
    NSLog(@"%@",l);
    
    [realm beginWriteTransaction];
    
    [realm addOrUpdateObject:l];
    
    [realm commitWriteTransaction];
    
    
    for (Match * match in l.weeks[l.currentWeek - 1].matches) {
        [realm beginWriteTransaction];
        match.played = true;
        int lowerBound = 0;
        int upperBound = 10;
        match.homeGoals = lowerBound + arc4random() % (upperBound - lowerBound);
        match.awayGoals = lowerBound + arc4random() % (upperBound - lowerBound);
        
        [realm commitWriteTransaction];
    }
    
    [l updateStatistics];
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    if (self.competitions.count == 0) {
        [self showMessage];
    }
}

- (void) showMessage {
    
    if (!self.messageLabel) {
        self.messageLabel = [UILabel new];
    }
    
    if (self.messageLabel.superview) {
        return;
    }
    
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = @"There is no competitions yet";
    self.messageLabel.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, 50);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.alpha = 0;
    
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [self.tableView addSubview:self.messageLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.messageLabel.alpha = 1;
        self.messageLabel.frame = CGRectMake(20, 40, self.view.frame.size.width - 40, 50);
    }];
}

- (void) hideMessage {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.messageLabel.alpha = 0;
        self.messageLabel.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, 50);
    } completion:^(BOOL finished) {
        self.messageLabel.alpha = 1;
        [self.messageLabel removeFromSuperview];
    }];
}

- (void) didTapAddButton: (UIBarButtonItem *) sender {
    //    if (self.messageLabel.superview) {
    //        [self hideMessage];
    //    } else {
    //        [self showMessage];
    //    }
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    SetupCompetitionViewController * vc = [[SetupCompetitionViewController alloc] init];
    vc.title = @"League";
    
    [[self navigationController] pushViewController:vc animated:true];
    
}

- (void) configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) receiveXNotification: (NSNotification *) note {
    
    [self.navigationController popToRootViewControllerAnimated:false];
    
    [self.navigationController pushViewController:[[MatchesViewController alloc] init] animated:false];
    
    
}

//MARK: UITableViewDelegte && UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", self.competitions[indexPath.row] , (long)indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.competitions.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

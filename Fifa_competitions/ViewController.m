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
#import "Competition.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) RLMResults<Competition *> * competitions;

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
    
    // Fetch all competitions
    self.competitions = [[Competition allObjects] sortedResultsUsingProperty:@"dateCreated" ascending:true];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePresentCompetitionNotification:) name:@"PresentCompetition" object:nil];
    
    {
        
        
        
        NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
        //
        //    RLMRealm * realm = [RLMRealm defaultRealm];
        //
        //
        //    League * l = [League new];
        //    l.id = [Utils uniqueId];
        //    l.twoStages = true;
        //
        //    l.statistics = [Statistics new];
        //
        //    [l.players addObjects:@[[[Player alloc] initWithValue: @{@"name": @"Andy", @"id": [Utils uniqueId]}],
        //                            [[Player alloc] initWithValue: @{@"name": @"Stephan", @"id": [Utils uniqueId]}],
        //                            [[Player alloc] initWithValue: @{@"name": @"Clark", @"id": [Utils uniqueId]}],
        //                            [[Player alloc] initWithValue: @{@"name": @"Michael", @"id": [Utils uniqueId]}]
        ////                            [[Player alloc] initWithValue: @{@"name": @"Poul", @"id": [Utils uniqueId]}],
        ////                            [[Player alloc] initWithValue: @{@"name": @"Mark", @"id": [Utils uniqueId]}],
        ////                            [[Player alloc] initWithValue: @{@"name": @"John", @"id": [Utils uniqueId]}]
        ////                            [[Player alloc] initWithValue: @{@"name": @"Michael 2", @"id": [Utils uniqueId]}],
        ////                            [[Player alloc] initWithValue: @{@"name": @"Andy 3", @"id": [Utils uniqueId]}],
        ////                            [[Player alloc] initWithValue: @{@"name": @"Steven 3", @"id": [Utils uniqueId]}],
        ////                            [[Player alloc] initWithValue: @{@"name": @"Clark 3", @"id": [Utils uniqueId]}],
        ////                            [[Player alloc] initWithValue: @{@"name": @"Michael 3", @"id": [Utils uniqueId]}]
        //                            ]];
        //
        //    for (Player * player in l.players) {
        //        StatisticsItem * item = [[StatisticsItem alloc] init];
        //        item.player = player;
        //        item.id = [Utils uniqueId];
        //
        //        [l.statistics.items addObject:item];
        //    }
        //
        //    [l generateMatches];
        //
        //    NSLog(@"%@",l);
        //
        //    [realm beginWriteTransaction];
        //
        //    [realm addOrUpdateObject:l];
        //
        //    [realm commitWriteTransaction];
        //
        //    for (int i = 0; i < l.weeks.count ; i++) {
        //        for (Match * match in l.weeks[l.currentWeek - 1].matches) {
        //            [realm beginWriteTransaction];
        //            match.played = true;
        //            int lowerBound = 0;
        //            int upperBound = 5;
        //            match.homeGoals = lowerBound + arc4random() % (upperBound - lowerBound);
        //            match.awayGoals = lowerBound + arc4random() % (upperBound - lowerBound);
        //
        //            [realm commitWriteTransaction];
        //        }
        //
        //        [l updateStatistics];
        //    }
    }
    
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
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    SetupCompetitionViewController * vc = [[SetupCompetitionViewController alloc] init];
    vc.title = @"League";
    Competition * competition = [Competition new];
    competition.id = [Utils uniqueId];
    competition.dateCreated = [NSDate date];
    competition.type = CompetitionTypeLeague;
    
    League * league = [League new];
    league.id = [Utils uniqueId];
    league.twoStages = true;
    competition.league = league;
    
    vc.competition = competition;
    
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

- (void) receivePresentCompetitionNotification: (NSNotification *) note {
    
    
    
    Competition * competition = (Competition *)note.userInfo[@"competition"];
    
    
    League *  l = competition.league;
    
    l.statistics = [Statistics new];
    for (Player * player in l.players) {
        StatisticsItem * item = [[StatisticsItem alloc] init];
        item.player = player;
        item.id = [Utils uniqueId];
        
        [l.statistics.items addObject:item];
    }
    
    [l generateMatches];
    
    NSLog(@"%@",l);
    
    RLMRealm * realm = [RLMRealm defaultRealm];

    
    [realm beginWriteTransaction];
    
    [realm addOrUpdateObject:competition];
    
    [realm commitWriteTransaction];
    
    MatchesViewController * matchesVC = [[MatchesViewController alloc] init];
    matchesVC.competition = competition;
    
    [self.navigationController popToRootViewControllerAnimated:false];
    [self.navigationController pushViewController:matchesVC animated:false];
    
    
}

//MARK: UITableViewDelegte && UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.competitions[indexPath.row].title];
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
    MatchesViewController * matchesVC = [[MatchesViewController alloc] init];
    matchesVC.competition = self.competitions[indexPath.row];
    
    [self.navigationController pushViewController:matchesVC animated:true];

}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

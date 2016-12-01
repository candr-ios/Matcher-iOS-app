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
#import "Tournament.h"
#import "TournamentMatchesViewController.h"
#import "CompetitionTypeViewController.h"
#import "CompetitionTableViewCell.h"

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

    [self configureView];
    [self configureTableView];
    [self fetchCompetitions];
    [self addObservers];
    
    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);

}

- (void) addObservers {
    // We subscribe to notification about finishing of setting competiotion (title, all players).
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePresentCompetitionNotification:) name:@"PresentCompetition" object:nil];
}

- (void) fetchCompetitions {
    // Fetch all competitions
    self.competitions = [[Competition allObjects] sortedResultsUsingProperty:@"dateCreated" ascending:false];
    
}

- (void) configureView {
    self.title = @"Competitions";
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(didTapAddButton:)];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Reload data every time controller appears
    [self.tableView reloadData];
    
    // if there is no competitions show messages about it
    if (self.competitions.count == 0) {
        [self showMessage];
    } else {
        [self hideMessage];
    }
}

- (void) didTapAddButton: (UIBarButtonItem *) sender {
    CompetitionTypeViewController * vc = [CompetitionTypeViewController new];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:true];
}

- (void) configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CompetitionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}



- (void) receivePresentCompetitionNotification: (NSNotification *) note {
    
    Competition * competition = (Competition *)note.userInfo[@"competition"];
    
    // kill app if setup faield for now
    //FIXIT:
    assert([competition completeSetup]);
    
    
    if (competition.type == CompetitionTypeTournament) {
      
        TournamentMatchesViewController * matchesVC = [[TournamentMatchesViewController alloc] init];
        matchesVC.competition = competition;
        
        [self.navigationController popToRootViewControllerAnimated:false];
        [self.navigationController pushViewController:matchesVC animated:false];
        return;
    }
 
    MatchesViewController * matchesVC = [[MatchesViewController alloc] init];
    matchesVC.competition = competition;
    
    [self.navigationController popToRootViewControllerAnimated:false];
    [self.navigationController pushViewController:matchesVC animated:false];
    
}

#pragma mark - UITableViewDelegte && UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompetitionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.competition = self.competitions[indexPath.row];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.competitions.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Competition * selectedCompetition = self.competitions[indexPath.row];
    
    if (selectedCompetition.type == CompetitionTypeTournament) {
        TournamentMatchesViewController * matchesVC = [[TournamentMatchesViewController alloc] init];
        matchesVC.competition = selectedCompetition;
        [self.navigationController pushViewController:matchesVC animated:true];
        return;
    }
    
    MatchesViewController * matchesVC = [[MatchesViewController alloc] init];
    matchesVC.competition = selectedCompetition;
    
    [self.navigationController pushViewController:matchesVC animated:true];
}

#pragma mark - Feature Actions

- (void) showCongratulationForPlayer:(Player*)winner {
    // Are you sure this method should be here?
}

#pragma mark - Messages

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

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

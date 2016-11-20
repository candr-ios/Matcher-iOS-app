//
//  MatchesViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/14/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchTableViewCell.h"
#import "MatchesHeaderView.h"
#import "StatisticsTableViewController.h"
#import "League.h"
#import "Match.h"
#import "Competition.h"
#import "Club.h"

@interface MatchesViewController ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

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
    
    [self.tableView registerClass:[MatchesHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(willShowKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(didHideKeyboard) name:UIKeyboardDidHideNotification object:nil];
    [center addObserver:self selector:@selector(updateStats) name:@"update_stats" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stats" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchStatsButton)];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didTouchStatsButton {
    StatisticsTableViewController * statsVC = [[StatisticsTableViewController alloc] init];
    statsVC.competition = self.competition;
    
    [self.navigationController pushViewController:statsVC animated:true];
}

- (void) updateStats {
    [self.competition.league updateStatistics];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
   
    Match * match = self.competition.league.weeks[indexPath.section].matches[indexPath.row];
    
    cell.homeLogoImageView.image = [UIImage imageNamed:match.home.club.logoImageName];
    cell.awayLogoImageView.image = [UIImage imageNamed:match.away.club.logoImageName];
    
    cell.match = match;
    cell.homeNameLabel.text = match.home.name;
    cell.awayNameLabel.text = match.away.name;
    
    if (match.played) {
        cell.homeScoreTextField.text = [NSString stringWithFormat:@"%d", match.homeGoals];
        cell.awayScoreTextField.text = [NSString stringWithFormat:@"%d", match.awayGoals];
    } else {
        cell.homeScoreTextField.text = @"";
        cell.awayScoreTextField.text = @"";

    }
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.competition.league.weeks[0].matches.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.competition.league.weeks.count;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    MatchTableViewCell * matchCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    matchCell.homeScoreTextField.userInteractionEnabled = false;
    matchCell.awayScoreTextField.userInteractionEnabled = false;
    
    if (!matchCell.match.played) {
        matchCell.homeScoreTextField.text = @"";
        matchCell.awayScoreTextField.text = @"";
    }
    
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    Match * m = self.competition.league.weeks[indexPath.section].matches[indexPath.row];
    
    return !m.played && self.competition.league.currentWeek == indexPath.section + 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    
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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MatchesHeaderView * header =  [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    header.title.text = [NSString stringWithFormat:@"Week %ld",section + 1];
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (void) willShowKeyboard {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.view.frame.size.width, 0);
}

- (void) didHideKeyboard {
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsZero;
                     }
     ];
    
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:false];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

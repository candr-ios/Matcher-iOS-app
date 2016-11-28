//
//  TournamentMatchesViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/25/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//


#import "TournamentMatchesViewController.h"
#import "MatchesViewController.h"
#import "MatchTableViewCell.h"
#import "MatchesHeaderView.h"
#import "StatisticsTableViewController.h"
#import "Match.h"
#import "Competition.h"
#import "Club.h"
#import "Tournament.h"
#import "Group.h"
#import "PenaltySeries.h"
#import "KnockoutStage.h"

@interface TournamentMatchesViewController ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@property (nonatomic, strong) Tournament * tournament;

@end

@implementation TournamentMatchesViewController

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
    
    // crash if competition type isn't tournament
    assert(self.competition.type == CompetitionTypeTournament);
    
    self.tournament = self.competition.tournament;
    
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
    
    if (self.tournament.hasGroupStage && !self.tournament.isGroupStageCompleted) {
        [self.tournament updateStatistics];
        if (self.tournament.isGroupStageCompleted) {
            [self updateStats];
        }
        return;
    } else if (self.tournament.isGroupStageCompleted && self.tournament.currentStage == nil) {
        // init knockout stage
        [self.tournament generateKnockoutStagesFromGroups];
    } else {
        // next
        [self.tournament generateNextKnockoutStage];
    }
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Match * match;
    if (indexPath.section < self.tournament.knockoutStages.count) {
        match = self.tournament.knockoutStages[indexPath.section].matches[indexPath.row];
    } else {
        long group = indexPath.section - self.tournament.knockoutStages.count;
        long week = indexPath.row / 2;
        int matchIndex = indexPath.row % 2;
        
        match = self.tournament.groups[group].weeks[week].matches[matchIndex];
    }
    
    MatchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
    
    // if there is group stage and all matches in it isn't played yet
    if (self.tournament.hasGroupStage && !self.tournament.isGroupStageCompleted) {
        return self.tournament.groups[0].weeks[0].matches.count * self.tournament.groups[0].weeks.count;
    }
    // if there is group stage and all matches in it is played
    else if (self.tournament.hasGroupStage && self.tournament.isGroupStageCompleted) {
        
        if (section < self.tournament.knockoutStages.count) {
            return self.tournament.knockoutStages[section].matches.count;
        } else {
            return self.tournament.groups[0].weeks[0].matches.count * self.tournament.groups[0].weeks.count;
        }
    // if there is no group stage
    } else {
        return self.tournament.knockoutStages[section].matches.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.competition.tournament.groups.count + self.competition.tournament.knockoutStages.count;
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
    
    Match * match;
    if (indexPath.section < self.tournament.knockoutStages.count) {
        match = self.tournament.knockoutStages[indexPath.section].matches[indexPath.row];
        
        return !match.played && (self.tournament.currentStage.type == self.tournament.knockoutStages[indexPath.section].type);
    }
    
    long group = indexPath.section - self.tournament.knockoutStages.count;
    long week = indexPath.row / 2;
    int matchIndex = indexPath.row % 2;
    
    match = self.tournament.groups[group].weeks[week].matches[matchIndex];

    NSLog(@"%d == %ld", self.tournament.groups[group].currentWeek, week + 1);
    
    return !match.played && self.tournament.groups[group].currentWeek == week + 1;
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
    
    if (section < self.tournament.knockoutStages.count) {
        header.title.text =  [self.tournament.knockoutStages[section] typeString];
    } else {
        long group = section - self.tournament.knockoutStages.count;
        
        header.title.text =  [NSString stringWithFormat:@"Group %@",self.tournament.groups[group].name];
    }
    
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

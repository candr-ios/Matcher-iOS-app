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
    
    
    NSLog(@"%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
    if (self.competitions.count == 0) {
        [self showMessage];
    } else {
        [self hideMessage];
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
    //[self presentTournament];
    
    CompetitionTypeViewController * vc = [CompetitionTypeViewController new];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:true];
    
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    
//    SetupCompetitionViewController * vc = [[SetupCompetitionViewController alloc] init];
//    vc.title = @"League";
//    Competition * competition = [Competition new];
//    competition.id = [Utils uniqueId];
//    competition.dateCreated = [NSDate date];
//    competition.type = CompetitionTypeLeague;
//    
//    League * league = [League new];
//    league.id = [Utils uniqueId];
//    league.twoStages = true;
//    competition.league = league;
//    
//    vc.competition = competition;
//    
//    [[self navigationController] pushViewController:vc animated:true];
//    
}

- (void) presentTournament {
    Player *player1 = [[Player alloc] initWithName:@"Adam"];
    Player *player2 = [[Player alloc] initWithName:@"Andy"];
    Player *player3 = [[Player alloc] initWithName:@"Tom"];
    Player *player4 = [[Player alloc] initWithName:@"Sara"];
    Player *player5 = [[Player alloc] initWithName:@"Steve"];
    Player *player6 = [[Player alloc] initWithName:@"Jane"];
    Player *player7 = [[Player alloc] initWithName:@"Lily"];
    Player *player8 = [[Player alloc] initWithName:@"Donald"];
    Player *player9 = [[Player alloc] initWithName:@"Boris"];
    Player *player10 = [[Player alloc] initWithName:@"Alex"];
    Player *player11 = [[Player alloc] initWithName:@"Sandy"];
    Player *player12 = [[Player alloc] initWithName:@"Bob"];
    Player *player13 = [[Player alloc] initWithName:@"Jack"];
    Player *player14 = [[Player alloc] initWithName:@"Ace"];
    Player *player15 = [[Player alloc] initWithName:@"Billy"];
    Player *player16 = [[Player alloc] initWithName:@"Clare"];
    
    
    Tournament *tournament = [[Tournament alloc] initWithPlayers:@[player1,player2,player3,player4,player5,player6,player7,player8,player9,player10,player11,player12,player13,player14,player15,player16]];
    
    
    NSLog(@"%@", tournament);
    
    [tournament generateGroups];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    
    
    TournamentMatchesViewController * vc = [TournamentMatchesViewController new];
    
    Competition * com = [Competition new];
    com.tournament = tournament;
    com.id = [Utils uniqueId];
    com.type = CompetitionTypeTournament;
    com.title = @"Tour 122";
    com.dateCreated = [NSDate date];
    
    
    [realm beginWriteTransaction];
    [realm addObject:com];
    // suppose all matched played
    //tournament.isGroupStageCompleted = YES;
    [realm commitWriteTransaction];
    
    vc.competition = com;
    
    [self.navigationController pushViewController:vc animated:true];
    
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
    RLMRealm * realm = [RLMRealm defaultRealm];
    Competition * competition = (Competition *)note.userInfo[@"competition"];
    
    if (competition.type == CompetitionTypeTournament) {
        Tournament * t = competition.tournament;
        
        if (t.shouldHaveGroups) {
            [t generateGroups];
            
            for (Group * group in t.groups) {
                group.statistics = [Statistics new];
                for (Player * player in group.players) {
                    StatisticsItem * item = [[StatisticsItem alloc] init];
                    item.player = player;
                    item.id = [Utils uniqueId];

                    [group.statistics.items addObject:item];
                }
            }
            
            
        } else {
            [t generateInitialKnockoutStage];
        }
        
        
        [realm beginWriteTransaction];
        
        [realm addOrUpdateObject:competition];
        
        [realm commitWriteTransaction];
        
        TournamentMatchesViewController * matchesVC = [[TournamentMatchesViewController alloc] init];
        matchesVC.competition = competition;
        
        [self.navigationController popToRootViewControllerAnimated:false];
        [self.navigationController pushViewController:matchesVC animated:false];
        return;
    }
    
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


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

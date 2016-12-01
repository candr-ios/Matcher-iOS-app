//
//  CompetitionTypeViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/26/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "CompetitionTypeViewController.h"
#import "Competition.h"
#import "Tournament.h"
#import "League.h"
#import "CompetitionTypeTableViewCell.h"
#import "SetupCompetitionViewController.h"

// Item



@interface CompletitionTypeObject : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * image;
@property int index;

@end

@implementation CompletitionTypeObject

@end

// Controller

@interface CompetitionTypeViewController ()

@property (nonatomic, strong) NSArray<CompletitionTypeObject *> * items;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * backButton;

@end

@implementation CompetitionTypeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupItems];

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:19];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _backButton = [UIButton new];
    
    [_backButton setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    
    
    self.titleLabel.text = @"Select competition type";
    
    _backButton.translatesAutoresizingMaskIntoConstraints = false;
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[table]-0-|" options:0 metrics:nil views:@{@"table": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[title]-20-|" options:0 metrics:NULL views:@{@"title":self.titleLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[title(25)]-10-[table]-0-|" options:0 metrics:NULL views:@{@"title":self.titleLabel, @"table": self.tableView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[back(25)]" options:0 metrics:NULL views:@{@"back":self.backButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[back(30)]" options:0 metrics:NULL views:@{@"back":self.backButton}]];
    
    [_backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CompetitionTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void) didTapBackButton: (UIButton *) sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) setupItems {
    
    CompletitionTypeObject * league1stage = [CompletitionTypeObject new];
    league1stage.title = @"League";
    league1stage.image = @"league";
    league1stage.index = 0;
    
    CompletitionTypeObject * league2stages = [CompletitionTypeObject new];
    league2stages.title = @"League 2 stages";
    league2stages.image = @"league2";
    league2stages.index = 1;
    
    CompletitionTypeObject * tournament = [CompletitionTypeObject new];
    tournament.title = @"Tournament Knockout";
    tournament.image = @"tournament";
    tournament.index = 2;
    
    CompletitionTypeObject * tournamentGroup = [CompletitionTypeObject new];
    tournamentGroup.title = @"Tournament Groups";
    tournamentGroup.image = @"tournamentg";
    tournamentGroup.index = 3;
    
    CompletitionTypeObject * tournamentGroup2 = [CompletitionTypeObject new];
    tournamentGroup2.title = @"Tournament Groups 2 stages";
    tournamentGroup2.image = @"tournamentg2";
    tournamentGroup2.index = 4;
    
    self.items = @[league1stage, league2stages, tournament, tournamentGroup, tournamentGroup2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate / UITableViewDataSource


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompetitionTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CompletitionTypeObject * item = self.items[indexPath.row];
    
    cell.titleLabel.text = item.title;
    cell.competitionImageView.image = [UIImage imageNamed: item.image];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SetupCompetitionViewController * vc = [SetupCompetitionViewController new];
    
    Competition * comp = [Competition new];
    comp.id = [Utils uniqueId];
    comp.dateCreated = [NSDate date];
    
    switch (indexPath.row) {
        case 0:
            comp.type = CompetitionTypeLeague;
            comp.league = [League new];
            comp.league.id = [Utils uniqueId];
            comp.league.twoStages = false;
            break;
        case 1:
            comp.type = CompetitionTypeLeague;
            comp.league = [League new];
            comp.league.id = [Utils uniqueId];
            comp.league.twoStages = true;
            break;
        case 2:
            comp.type = CompetitionTypeTournament;
            comp.tournament = [Tournament new];
            comp.tournament.id = [Utils uniqueId];
            comp.tournament.shouldHaveGroups = false;
            comp.tournament.has2stages = false;
            break;
        case 3:
            comp.type = CompetitionTypeTournament;
            comp.tournament = [Tournament new];
            comp.tournament.id = [Utils uniqueId];
            comp.tournament.shouldHaveGroups = true;
            comp.tournament.has2stages = false;
            break;
        case 4:
            comp.type = CompetitionTypeTournament;
            comp.tournament = [Tournament new];
            comp.tournament.id = [Utils uniqueId];
            comp.tournament.shouldHaveGroups = true;
            comp.tournament.has2stages = true;
            break;
        default:
            break;
    }
    
    vc.competition = comp;
    
    [self.navigationController pushViewController:vc animated:true];
    
}


@end

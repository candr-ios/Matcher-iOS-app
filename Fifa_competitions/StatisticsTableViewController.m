//
//  StatisticsTableViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/15/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "StatisticsTableViewController.h"
#import "StatsHeaderView.h"
#import "StatsTableViewCell.h"
#import "Statistics.h"
#import "StatisticsItem.h"
#import "League.h"
#import "Tournament.h"
#import "Group.h"
#import "TournamentTreeViewController.h"

@interface StatisticsTableViewController ()

@property (nonatomic, strong) NSMutableArray<RLMResults<StatisticsItem *> *> * tables;

@end

@implementation StatisticsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = false;
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"empty_cell"];
    
    self.tables = [[NSMutableArray alloc] init];
    
    
    if (self.competition.type == CompetitionTypeTournament && self.competition.tournament.hasGroupStage) {
        [self generateTablesForGroups];
    } else if (self.competition.type == CompetitionTypeLeague) {
        [self generateTableForLeague];
    }
    if (self.competition.type == CompetitionTypeTournament && self.competition.tournament.knockoutStages.count
         > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tree" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchTreeButton)];
    }
    
    
    
    [self.tableView reloadData];
}

- (void) didTouchTreeButton {
    TournamentTreeViewController * treeVC = [[TournamentTreeViewController alloc] init];
    treeVC.tournament = self.competition.tournament;
    
    [self.navigationController pushViewController:treeVC animated:true];
}

- (void) generateTablesForGroups {
    int i = 0;
    for (Group * group in self.competition.tournament.groups) {
        [self.tables addObject:[group.statistics.items sortedResultsUsingDescriptors:@[
                                                                                                         [RLMSortDescriptor  sortDescriptorWithProperty:@"score" ascending:false],
                                                                                                         [RLMSortDescriptor  sortDescriptorWithProperty:@"goalsFor" ascending:false],
                                                                                                         [RLMSortDescriptor sortDescriptorWithProperty:@"goalsDiff" ascending:false]]
                                
                                ]];
        i++;
    }
}

- (void) generateTableForLeague {
    [self.tables addObject:[self.competition.league.statistics.items sortedResultsUsingDescriptors:@[
                                                                              [RLMSortDescriptor  sortDescriptorWithProperty:@"score" ascending:false],
                                                                              [RLMSortDescriptor  sortDescriptorWithProperty:@"goalsFor" ascending:false],
                                                                              [RLMSortDescriptor sortDescriptorWithProperty:@"goalsDiff" ascending:false]]
     
     ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tables.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tables[section].count + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 > self.tables[indexPath.section].count) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"empty_cell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    StatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.statisticsItem = [self.tables[indexPath.section] objectAtIndex:indexPath.row];
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    return cell;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatsHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    if (self.tables.count == 0) {
        return nil;
    }
    
    if (self.competition.type == CompetitionTypeTournament && self.competition.tournament.hasGroupStage) {
        header.firstLabel.text = self.competition.tournament.groups[section].name;
        header.secondLabel.text = @"Group";
    }
    
    return header;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

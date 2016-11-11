//
//  ViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "ViewController.h"
#import "CreateCompetitionBaseViewController.h"

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
    
    CreateCompetitionBaseViewController * vc = [[CreateCompetitionBaseViewController alloc] init];
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


@end

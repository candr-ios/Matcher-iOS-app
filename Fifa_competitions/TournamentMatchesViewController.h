//
//  TournamentMatchesViewController.h
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/25/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Competition;

@interface TournamentMatchesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Competition * competition;
@end

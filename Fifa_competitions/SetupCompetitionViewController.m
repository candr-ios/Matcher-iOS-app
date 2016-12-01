//
//  SetupCompetitionViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "SetupCompetitionViewController.h"
#import "UnderlineTextField.h"
#import "PlayerSetupViewController.h"
#import "League.h"
#import "Tournament.h"

@interface SetupCompetitionViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UnderlineTextField * competitionTitle;
@property (nonatomic, strong) UnderlineTextField * numberOfPlayers;
@property (nonatomic, strong) UILabel * numberOfPlayersLabel;

@end

@implementation SetupCompetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    if (self.competition.type == CompetitionTypeTournament){
        self.subTitleLabel.text = @"";
        if (self.competition.tournament.shouldHaveGroups) {
            self.subTitleLabel.text = (self.competition.tournament.has2stages) ? @"2 Stages Groups" : @"Groups";
        }
        self.title= @"Tournament";
    } else {
        self.title = @"League";
        self.subTitleLabel.text = (self.competition.league.twoStages) ?  @"2 Stages" : @"";
    }

    [self setupViews];
    
    
    self.nextButton.hidden = true;
    
    [self.nextButton addTarget:self action:@selector(didTapNext:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setupViews {
    _competitionTitle = [UnderlineTextField new];
    _numberOfPlayers = [UnderlineTextField new];
    _numberOfPlayersLabel = [UILabel new];
    
    _competitionTitle.translatesAutoresizingMaskIntoConstraints = false;
    _numberOfPlayers.translatesAutoresizingMaskIntoConstraints = false;
    _numberOfPlayersLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview: _competitionTitle];
    [self.view addSubview:_numberOfPlayers];
    [self.view addSubview:_numberOfPlayersLabel];
    
    _numberOfPlayersLabel.textColor = [UIColor whiteColor];
    _numberOfPlayersLabel.text = @"Number of players";
    _numberOfPlayersLabel.textAlignment = NSTextAlignmentCenter;
    
    _numberOfPlayers.keyboardType = UIKeyboardTypeNumberPad;
    _numberOfPlayers.font = [UIFont systemFontOfSize:50 weight:UIFontWeightThin];
    
    _competitionTitle.font = [UIFont systemFontOfSize:19 weight: UIFontWeightRegular];
    
    _competitionTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Title" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    if (self.competition.type == CompetitionTypeTournament) {
        _numberOfPlayers.text = @"8";
    } else {
        _numberOfPlayers.text = @"4";
    }
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    _numberOfPlayers.inputAccessoryView = keyboardDoneButtonView;
    
    _numberOfPlayers.delegate = self;
    _numberOfPlayers.returnKeyType = UIReturnKeyDone;
    _competitionTitle.delegate = self;
    _competitionTitle.returnKeyType = UIReturnKeyDone;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-125-[titleField]-50-[numberLabel(25)]-10-[numberField]" options:0 metrics:nil views:@{@"titleField":self.competitionTitle, @"numberLabel": self.numberOfPlayersLabel, @"numberField": self.numberOfPlayers}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[titleField]-20-|" options:0 metrics:nil views:@{@"titleField":self.competitionTitle}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[numberLabel]-20-|" options:0 metrics:nil views:@{@"numberLabel":self.numberOfPlayersLabel}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[numberField]-60-|" options:0 metrics:nil views:@{@"numberField":self.numberOfPlayers}]];
    
    
}

- (void) willResignFirstResponder {
    if (self.competitionTitle.isFirstResponder) {
        self.competition.title = self.competitionTitle.text;
    }
    self.nextButton.hidden = true;

    int count = self.numberOfPlayers.text.intValue;
    
    if (self.competition.type == CompetitionTypeTournament && self.competition.tournament.shouldHaveGroups) {
        
        // is power of 2 and >= 8
        if ((count != 0) && ((count & (count - 1)) == 0) && count >= 8 && count <= 32) {
            self.nextButton.hidden = false;
        }
    } else if (self.competition.type == CompetitionTypeTournament) {
        if ((count != 0) && ((count & (count - 1)) == 0) && count >= 2 && count <= 32) {
            self.nextButton.hidden = false;
        }
    } else {
        
        self.nextButton.hidden = (count >= 2 && count <= 32) ? false : true;
    }
    
    if (self.competition.title.length < 1) {
        self.nextButton.hidden = true;
    }
}

- (void) doneClicked: (UIBarButtonItem *) sender {
    [self willResignFirstResponder];
    [_numberOfPlayers resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self willResignFirstResponder];
    [textField resignFirstResponder];
    return  true;
}

- (void) didTapNext: (UIButton *) sender {
#ifdef TESTING
    NSLog(@"TESTING");
    
    int numberOfPlayers = self.numberOfPlayers.text.intValue;
    if (self.competition.type == CompetitionTypeTournament) {
        for (int i = 0; i < numberOfPlayers; i++) {
            Player * player = [[Player alloc] initWithName:[NSString stringWithFormat:@"Player %d", i + 1]];
            [self.competition.tournament.players addObject:player];
        }
    } else {
        for (int i = 0; i < numberOfPlayers; i++) {
            Player * player = [[Player alloc] initWithName:[NSString stringWithFormat:@"Player %d", i + 1]];
            [self.competition.league.players addObject:player];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentCompetition" object:nil userInfo:@{@"competition": self.competition}];
#else
    
    PlayerSetupViewController * vc = [PlayerSetupViewController new];
    vc.count = 1;
    vc.numberOfPlayers = self.numberOfPlayers.text.intValue;
    vc.competition = self.competition;
    [self.navigationController pushViewController:vc animated:true];
    
#endif
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

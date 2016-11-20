//
//  MatchTableViewCell.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/14/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "MatchTableViewCell.h"

@interface MatchTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;



@property (weak, nonatomic) IBOutlet UILabel *scoreSeparatorLabel;

@end

@implementation MatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.backgroundColor = [UIColor clearColor];
    _homeScoreTextField.userInteractionEnabled = false;
    _awayScoreTextField.userInteractionEnabled = false;
    
    _homeScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _awayScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
//    _homeScoreTextField.clearsOnBeginEditing = true;
//    _awayScoreTextField.clearsOnBeginEditing = true;
//    
    _homeScoreTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"_" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:35]}];
    _awayScoreTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"_" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:35]}];
    
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(cancelClicked:)];
    UIBarButtonItem * space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, space1, cancelButton, nil]];
    
    _awayScoreTextField.inputAccessoryView = keyboardDoneButtonView;
    
    UIToolbar *keyboardNextButtonView = [[UIToolbar alloc] init];
    [keyboardNextButtonView sizeToFit];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(nextClicked:)];
    
    UIBarButtonItem *cancelButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(cancelClicked:)];
    UIBarButtonItem * space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardNextButtonView setItems:[NSArray arrayWithObjects:nextButton,space2, cancelButton2, nil]];
    
    _homeScoreTextField.inputAccessoryView = keyboardNextButtonView;
    
}

- (void) cancelClicked: (UIBarButtonItem *) sender {
    
    _homeScoreTextField.text = @"";
    _awayScoreTextField.text = @"";
    
    if (_homeScoreTextField.isFirstResponder) {
    [_homeScoreTextField resignFirstResponder];
    _homeScoreTextField.userInteractionEnabled = false;
    } else {
        [_awayScoreTextField resignFirstResponder];
        _awayScoreTextField.userInteractionEnabled = false;
    }
}

- (void) doneClicked: (UIBarButtonItem *) sender {
    //TODO
    
    [_awayScoreTextField resignFirstResponder];
    _awayScoreTextField.userInteractionEnabled = false;
    _homeScoreTextField.userInteractionEnabled = false;
    
    if (self.homeScoreTextField.text.length == 0 || self.awayScoreTextField.text.length == 0) {
        _homeScoreTextField.text = @"";
        _awayScoreTextField.text = @"";
        return;
    }
    
     [self.match.realm beginWriteTransaction];
    
    self.match.homeGoals = _homeScoreTextField.text.intValue;
    self.match.awayGoals = _awayScoreTextField.text.intValue;
    self.match.played = true;
    
   // [self.match.realm addOrUpdateObject:self.match];
    
    [self.match.realm commitWriteTransaction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_stats" object:nil];
    //TODO: notify object to update statistics
    
    
    
    
}

- (void) nextClicked: (UIBarButtonItem *) sender {
    //TODO:
    _awayScoreTextField.userInteractionEnabled = true;
    [_awayScoreTextField becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.cellBackgroundView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.cellBackgroundView.layer.borderWidth = 2;
    } else {
        self.cellBackgroundView.layer.borderWidth = 0;
    }
    
    // Configure the view for the selected state
}

@end

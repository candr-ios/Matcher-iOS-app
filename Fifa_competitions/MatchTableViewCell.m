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
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    _awayScoreTextField.inputAccessoryView = keyboardDoneButtonView;
    
    UIToolbar *keyboardNextButtonView = [[UIToolbar alloc] init];
    [keyboardNextButtonView sizeToFit];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(nextClicked:)];
    [keyboardNextButtonView setItems:[NSArray arrayWithObjects:nextButton, nil]];
    
    _homeScoreTextField.inputAccessoryView = keyboardNextButtonView;
    
}

- (void) doneClicked: (UIBarButtonItem *) sender {
    //TODO
    [_awayScoreTextField resignFirstResponder];
    _awayScoreTextField.userInteractionEnabled = false;
    
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

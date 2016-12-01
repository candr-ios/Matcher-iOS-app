//
//  CompetitionTableViewCell.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 12/1/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "CompetitionTableViewCell.h"
#import "Competition.h"
#import "League.h"
#import "Tournament.h"
#import "Club.h"

@implementation CompetitionTableViewCell

- (void) setCompetition:(Competition *)competition {
    _competition = competition;
    self.competitionTitleLabel.text = competition.title;
    
    if (competition.type == CompetitionTypeLeague) {
        if (competition.league.twoStages) {
            self.typeImageView.image = [UIImage imageNamed:@"league2"];
        } else {
            self.typeImageView.image = [UIImage imageNamed:@"league"];
        }
    } else {
        if (competition.tournament.hasGroupStage && competition.tournament.has2stages) {
            self.typeImageView.image = [UIImage imageNamed:@"tournamentg2"];
        } else if (competition.tournament.hasGroupStage ) {
            self.typeImageView.image = [UIImage imageNamed:@"tournamentg"];
        } else {
             self.typeImageView.image = [UIImage imageNamed:@"tournament"];
        }
    }
    
    self.statusLabel.text = (self.competition.winner) ? @"Finished" : @"In progress";
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:self.competition.dateCreated
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    
    if (self.competition.winner) {
        self.winnerLabel.hidden = false;
        self.winnerNameLabel.hidden = false;
        self.winnerNameLabel.text = self.competition.winner.name;
        self.winnerClubImageView.hidden = false;
        self.winnerClubImageView.image = [UIImage imageNamed:self.competition.winner.club.logoImageName];
    } else {
        self.winnerLabel.hidden = true;
        self.winnerNameLabel.hidden = true;
        self.winnerClubImageView.hidden = true;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.containerView.layer.borderWidth = 2;
        self.containerView.layer.borderColor = [[UIColor whiteColor] CGColor];
    } else {
        self.containerView.layer.borderWidth = 0;
    }
    // Configure the view for the selected state
}

@end

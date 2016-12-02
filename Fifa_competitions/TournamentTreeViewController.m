//
//  TournamentTreeViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 12/1/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "TournamentTreeViewController.h"
#import "Tournament.h"
#import "KnockoutMatchView.h"

@interface TournamentTreeViewController ()

@property (nonatomic, strong) UIScrollView * treeView;

@end

@implementation TournamentTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    
    
    
    _treeView = [[UIScrollView alloc] init];
    
    [self.view addSubview:_treeView];
    [self setData];
    
    
   
    
}

-(void) setData {
    [self.treeView layoutIfNeeded];
    for (UIView * subview in self.treeView.subviews) {
        [subview removeFromSuperview];
    }
    
    if ( self.tournament.knockoutStages.count == 1) {
        KnockoutMatchView * matchView = [[KnockoutMatchView alloc] initWithFrame:CGRectMake(20,60 , 160, 44)];
        matchView.match = [self.tournament.knockoutStages[0].matches firstObject];
        [self.treeView addSubview:matchView];
        self.treeView.contentSize = CGSizeMake(300, 150);
        return;
    }
    
    int i = 0;

    int topY = 0;
    int bottomY = 0;
    int prevHeight = 0;
    int prevNumberOfMatches = 0;
    int initalHeight = 0;
    int initialNumberOfMatches = 0;
    int prevF = 0;
    int f = 0;
    int finalY = 0;
    int finalX = 0;
    for (KnockoutStage * stage in self.tournament.knockoutStages) {
        
        int k = 0;
        int prevY = 0;
        for (Match * match in stage.matches) {
            
            int x = 0;
            int y = 0;
            
            if (i == 0) {
                x = 90;
                y = (k + 1) * 50;
            } else {
                f = prevF * 2;
                
                if (k == 0) {
                    // Tyt yob*nuy pizd*c
                    y = f / 2 - 25 + (f/ (i + 1)) - ((i -1) * 25) ;
                    prevY = y;
                } else {
                    y = prevY + f ;
                    prevY = y;
                }
                
                
                
                x = i * 200 + 80;
            }
            
            if (k == 0) {
                topY = y;
            }else {
                bottomY = y;
            }
            
            KnockoutMatchView * matchView = [[KnockoutMatchView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
            matchView.match = match;
            
            if (stage.type == ThirdPlace) {
                finalY = y;
                finalX = x;
                y += 200;
                matchView.layer.borderColor = [[[UIColor redColor] colorWithAlphaComponent:0.6] CGColor];
            }
            
           
            if (stage.type == Final) {
                y = finalY;
                x = finalX;
                matchView.layer.borderWidth = 2;
                matchView.layer.borderColor = [[UIColor redColor] CGColor];
            }
            
            
            matchView.center = CGPointMake(x , y);
            
            
            [self.treeView addSubview:matchView];
            
            k++;
        }
        prevHeight = bottomY - topY;
        prevNumberOfMatches = (int)stage.matches.count;
        
        prevF = f;
        
        if ( i == 0) {
            initalHeight = prevHeight + 50;
            initialNumberOfMatches = prevNumberOfMatches;
            prevF = initalHeight / initialNumberOfMatches;
        }
        
        
        i++;
    }
    
    
    float w = 0;
    float h = 0;
    
    for (UIView *v in [self.treeView subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    
    self.treeView.contentSize = CGSizeMake(w, h);
    
}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _treeView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

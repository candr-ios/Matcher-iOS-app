//
//  PlayerSetupViewController.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "PlayerSetupViewController.h"
#import "UnderlineTextField.h"
#import "PlayerSetupViewController.h"
#import "ClubCollectionViewCell.h"


@interface PlayerSetupViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel * playerNameLabel;
@property (nonatomic, strong) UnderlineTextField * playerNameTextField;
@property (nonatomic, strong) UICollectionView * clubsCollectionView;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

@end

@implementation PlayerSetupViewController

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    
    if (self.count == 0) {
        _count = 1;
    }
    
    self.title = [NSString stringWithFormat:@"Player #%ld", self.count];
    
    [super viewDidLoad];
    [self setupViews];
    
    [self.nextButton addTarget:self action:@selector(didTapNext:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self selectItemAtCenter];
}

- (void) setupViews {
    
    self.subTitleLabel.text = @"select player and club";
    
    _playerNameLabel = [UILabel new];
    _playerNameLabel.textColor = [UIColor lightGrayColor];
    _playerNameLabel.text = @"player name";
    _playerNameLabel.textAlignment = NSTextAlignmentCenter;
    _playerNameLabel.font = [UIFont systemFontOfSize:15];
    
    
    _playerNameTextField = [UnderlineTextField new];
    _playerNameTextField.delegate = self;
    _playerNameTextField.returnKeyType = UIReturnKeyDone;
    _playerNameTextField.textColor = [UIColor whiteColor];
    _playerNameTextField.font = [UIFont systemFontOfSize:19];
    _playerNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Noob" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    _clubsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    _clubsCollectionView.delegate = self;
    _clubsCollectionView.dataSource = self;
    _clubsCollectionView.showsHorizontalScrollIndicator = false;
    
    [_clubsCollectionView registerNib:[UINib nibWithNibName:@"ClubCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"club_cell"];
    
    
    _playerNameTextField.translatesAutoresizingMaskIntoConstraints = false;
    _playerNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    _clubsCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    
    _clubsCollectionView.backgroundColor = [UIColor clearColor];
    
    
    
    UICollectionViewFlowLayout * layout = _clubsCollectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(0, 70, 0, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.view addSubview:_playerNameLabel];
    [self.view addSubview:_playerNameTextField];
    [self.view addSubview:_clubsCollectionView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[field]-8-[text]-40-[scroll(250)]" options:0 metrics:nil views:@{@"field": _playerNameTextField, @"text": _playerNameLabel, @"scroll": _clubsCollectionView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[field]-30-|" options:0 metrics:nil views:@{@"field": _playerNameTextField}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[text]-30-|" options:0 metrics:nil views:@{ @"text": _playerNameLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scroll]-0-|" options:0 metrics:nil views:@{ @"scroll": _clubsCollectionView }]];
    
    
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f", self.clubsCollectionView.contentOffset.x);
    [self selectItemAtCenter];
}


- (void) selectItemAtCenter {
    
    //NSLog(@"%f/%f", self.clubsCollectionView.contentOffset.x, self.clubsCollectionView.contentOffset.y);
    CGPoint center = CGPointMake(self.clubsCollectionView.center.x + self.clubsCollectionView.contentOffset.x + 1,
    200);

    NSLog(@"%f;%f", center.x, center.y);
    NSIndexPath * path = [_clubsCollectionView indexPathForItemAtPoint:center];
    NSLog(@"%@",path);
    if (path) {
        self.selectedIndexPath = path;
        [_clubsCollectionView selectItemAtIndexPath:path animated:true scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        return;
    }
    
    [self.clubsCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.clubsCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didTapNext: (UIButton *) sender {
    
    if (_count == 1) {
        
        UIView * rect = [[UIView alloc] init];
        rect.backgroundColor = [UIColor whiteColor];
        rect.layer.cornerRadius = 4;
        
        [self.view setUserInteractionEnabled:false];
        
        UIActivityIndicatorView * vc = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:rect];
        [self.view addSubview:vc];
        
        
        rect.frame = CGRectMake(0, 0, 100, 100);
        
        rect.center = self.view.center;
        
        vc.center = self.view.center;
        
        [vc startAnimating];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"X" object:nil userInfo:nil];
        });
        
        
        return;
    }
    
    PlayerSetupViewController * vc = [PlayerSetupViewController new];
    vc.count = _count + 1;
    
    
    [self.navigationController pushViewController:vc animated:true];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

//MARK: Collection delegate and data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClubCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"club_cell" forIndexPath:indexPath];
    
    cell.logoImageView.image = [UIImage imageNamed:@"barca"];
    cell.clubTitleLabel.text = @"Barcelona";
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(180, 240);
}


@end

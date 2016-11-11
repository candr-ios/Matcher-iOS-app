//
//  UnderlineTextField.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "UnderlineTextField.h"

@interface UnderlineTextField ()

@property (nonatomic, strong) UIView * line;

@end

@implementation UnderlineTextField


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.line = [UIView new];
        self.line.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.line];
        self.borderStyle = UITextBorderStyleNone;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    
    _line.frame = CGRectMake(0, self.frame.size.height + 4, self.frame.size.width, 1);
}

@end

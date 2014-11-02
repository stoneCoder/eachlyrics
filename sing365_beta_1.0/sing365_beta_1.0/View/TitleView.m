//
//  HomeTitleView.m
//  SmartXHSD
//
//  Created by 左德彪 on 14-3-23.
//  Copyright (c) 2014年 com.fezo. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, NAVIGATION_BAR_LENGTH)];
    if (self) {
        // left view
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        [self.leftButton setImage:[UIImage imageNamed:@"back_press@2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        // title view
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NAVIGATION_BAR_LENGTH)];
        //self.titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:self.titleLabel];
        // right button
//        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.rightButton.frame = CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
//        [self.rightButton setImage:[UIImage imageNamed:@"home_membercard.png"] forState:UIControlStateNormal];
//        [self addSubview:self.rightButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  CommonTableView.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-17.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "CommonTableView.h"

@implementation CommonTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.labelNoResult = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/5, self.frame.size.height/3, 200,50)];
        self.labelNoResult.text = @"暂无相关数据!";
        self.labelNoResult.textAlignment = NSTextAlignmentCenter;
        self.labelNoResult.font = [UIFont systemFontOfSize:12.0f];
        self.labelNoResult.textColor = [UIColor grayColor];
        [self addSubview:self.labelNoResult];
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

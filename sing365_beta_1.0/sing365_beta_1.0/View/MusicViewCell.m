//
//  MusicViewCell.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-17.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "MusicViewCell.h"

@implementation MusicViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.musicImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.musicImage.layer.cornerRadius =  self.musicImage.frame.size.width/2;
        self.musicImage.layer.masksToBounds=YES;
        [self addSubview:self.musicImage];
        
//        self.musicSpecialLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 60, 50)];
//        self.musicSpecialLabel.text = @"专辑：";
//        self.musicSpecialLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.musicSpecialLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.musicSpecialLabel];
        
//        self.musicNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 60, 50)];
//        self.musicNameLabel.text = @"歌曲：";
//        self.musicNameLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.musicNameLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.musicNameLabel];
        
        self.musicNameDetailLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 50)];
        self.musicNameDetailLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        self.musicNameDetailLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.musicNameDetailLable];
        
//        self.musicPlayerLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 60, 50)];
//        self.musicPlayerLabel.text = @"歌手：";
//        self.musicPlayerLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.musicPlayerLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.musicPlayerLabel];
        
        self.musicPlayerDetailLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 50)];
        self.musicPlayerDetailLable.font = [UIFont systemFontOfSize:12.0f];
        self.musicPlayerDetailLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.musicPlayerDetailLable];
        
        self.musicSpecialDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 50)];
        self.musicSpecialDetailLabel.font = [UIFont systemFontOfSize:12.0f];
        self.musicSpecialDetailLabel.textColor = [UIColor grayColor];
        self.musicSpecialDetailLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.musicSpecialDetailLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

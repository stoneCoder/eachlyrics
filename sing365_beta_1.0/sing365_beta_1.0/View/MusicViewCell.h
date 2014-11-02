//
//  MusicViewCell.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-17.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicViewCell : UITableViewCell

@property (strong,nonatomic) UIImageView *musicImage;
//专辑名称
@property (strong,nonatomic) UILabel *musicSpecialLabel;
@property (strong,nonatomic) UILabel *musicSpecialDetailLabel;
//歌手
@property (strong,nonatomic) UILabel *musicPlayerLabel;
@property (strong,nonatomic) UILabel *musicPlayerDetailLable;
//歌曲
@property (strong,nonatomic) UILabel *musicNameLabel;
@property (strong,nonatomic) UILabel *musicNameDetailLable;
@end

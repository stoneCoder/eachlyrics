//
//  MusicPlayView.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-20.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayView : UIView
@property(strong, nonatomic) UIButton* playButton;
@property(strong, nonatomic) UIButton* pauseButton;
@property(strong, nonatomic) UIButton* nextButton;
@property(strong, nonatomic) UIButton* previousButton;
@property(strong, nonatomic) UISlider* slider;

@end

//
//  MusicPlayView.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-20.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "MusicPlayView.h"

@implementation MusicPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置底部背景色
        UIImageView *buttonBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 96)];
        buttonBackground.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerBarBackground" ofType:@"png"]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [self addSubview:buttonBackground];
        buttonBackground  = nil;
        //播放按钮
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(144, 20, 40, 40)];
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPlay" ofType:@"png"]] forState:UIControlStateNormal];
        self.playButton.showsTouchWhenHighlighted = YES;
        [self addSubview:self.playButton];//100, 420, 60, 25
        
        self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 20, 40, 40)];
        [self.pauseButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPause" ofType:@"png"]] forState:UIControlStateNormal];
        self.pauseButton.showsTouchWhenHighlighted = YES;
        
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 20, 40, 40)];
        [self.nextButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNextTrack" ofType:@"png"]]
                     forState:UIControlStateNormal];
        //[self.nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        self.nextButton.showsTouchWhenHighlighted = YES;
        [self addSubview:self.nextButton];
        
        self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, 40, 40)];
        [self.previousButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPrevTrack" ofType:@"png"]]
                         forState:UIControlStateNormal];
        self.previousButton.showsTouchWhenHighlighted = YES;
        [self addSubview:self.previousButton];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(25, 75, 270, 9)];
        [self.slider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerVolumeKnob" ofType:@"png"]]
                      forState:UIControlStateNormal];
        [self.slider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                             forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                             forState:UIControlStateNormal];
        self.slider.minimumValue = 0.0;
//        [self.slider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
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

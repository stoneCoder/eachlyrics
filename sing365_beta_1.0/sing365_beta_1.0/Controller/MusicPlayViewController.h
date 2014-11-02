//
//  MusicPlayViewController.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-20.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "TitleView.h"
#import "MusicPlayView.h"
#import "SliderUtils.h"
#import "Workspace.h"
#import "MusicLrcModel.h"
#import "MusicDownLoadManager.h"

/**
 ** 用于播放iPod Libary音乐
 **
 **/
@interface MusicPlayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSString *tempLrcPath;
}

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) TitleView *titleView;
@property(strong, nonatomic) UIButton* playButton;
@property(strong, nonatomic) UIButton* pauseButton;
@property(strong, nonatomic) UIButton* nextButton;
@property(strong, nonatomic) UIButton* previousButton;
@property(strong, nonatomic) UISlider* slider;


@property (strong,nonatomic) MPMediaItem *item;
@property (strong,nonatomic) MPMediaItemCollection *collection;
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) NSMutableArray *musicArray;
@property (nonatomic, strong) NSMutableArray *lrcArray;
@property (nonatomic) int index;
@property (strong,nonatomic) id mTimeObserver;



-(id)initWithArray:(NSMutableArray *)array inRow:(NSInteger)row;

@end

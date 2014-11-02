//
//  MainViewController.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 13-11-6.
//  Copyright (c) 2013年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListView.h"
#import "MediaPlayer/MediaPlayer.h"
#import "MusicPlayViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MusicListView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

- (id)initWithMusicCollection:(MPMediaItemCollection *)conllection;

@end

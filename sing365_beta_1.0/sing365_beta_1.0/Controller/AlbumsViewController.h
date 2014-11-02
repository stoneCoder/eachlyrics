//
//  PerformerViewController.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-17.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
#import <UIKit/UIKit.h>
#import "MusicListView.h"
#import "MusicViewCell.h"
#import "MediaPlayer/MediaPlayer.h"

@interface AlbumsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MusicListView *tableView;
@property (nonatomic, strong) NSMutableArray *items;

@end

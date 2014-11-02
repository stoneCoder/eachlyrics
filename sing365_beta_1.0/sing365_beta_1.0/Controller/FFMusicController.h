//
//  FFMusicController.h
//  sing365_beta_1.0
//
//  Created by Brian on 14-8-13.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListView.h"

@interface FFMusicController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MusicListView *tableView;
@end

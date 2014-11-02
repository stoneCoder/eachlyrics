//
//  AppDelegate.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 13-11-6.
//  Copyright (c) 2013年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

#import "MainViewController.h"
#import "AlbumsViewController.h"
#import "SettingViewController.h"
#import "FFMusicController.h"
@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) AlbumsViewController *albumsViewController;
@property (strong, nonatomic) FFMusicController *ffMusicController;
@property (strong, nonatomic) SettingViewController *settingViewController;

@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) UINavigationController *albumsNavigationController;
@property (strong, nonatomic) UINavigationController *ffmusicNavigationController;
@property (strong, nonatomic) UINavigationController *settingNavigationController;


@end

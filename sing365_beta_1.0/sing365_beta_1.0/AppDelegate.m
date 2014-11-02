//
//  AppDelegate.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 13-11-6.
//  Copyright (c) 2013年 Stone_Zl. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "LeftMenuController.h"
#import "MainViewController.h"

@implementation AppDelegate
@synthesize menuController = _menuController;
-(void)initTabBarController
{
    self.mainViewController = [[MainViewController alloc] initWithMusicCollection:nil];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    //self.mainNavigationController.title = NSLocalizedString(@"mainMenu", @"");
    //[self.mainNavigationController setNavigationBarHidden:YES];
    
    self.albumsViewController = [[AlbumsViewController alloc] initWithNibName:nil bundle:nil];
    self.albumsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.albumsViewController];
    //self.albumsNavigationController.title = NSLocalizedString(@"secondMenu", @"");
    //[self.albumsNavigationController setNavigationBarHidden:YES];
    
    self.ffMusicController = [[FFMusicController alloc] initWithNibName:nil bundle:nil];
    self.ffmusicNavigationController = [[UINavigationController alloc] initWithRootViewController:self.ffMusicController];
    //self.ffmusicNavigationController.title = NSLocalizedString(@"thirdMenu", @"");;
    //[self.ffmusicNavigationController setNavigationBarHidden:YES];
    
    self.settingViewController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    self.settingNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingViewController];
    //self.settingNavigationController.title = NSLocalizedString(@"forthMenu", @"");
    //[self.settingNavigationController setNavigationBarHidden:YES];
    // add into tarbar
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[self.mainNavigationController,self.albumsNavigationController,self.ffmusicNavigationController,self.settingNavigationController];
    [self customizeTabBarForController:self.tabBarController];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    /*左右菜单*/
    //MainViewController *mainController = [[MainViewController alloc] initWithMusicCollection:nil];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    //DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    //LeftMenuController *leftController = [[LeftMenuController alloc] init];
    //rootController.leftViewController = leftController;
    //_menuController = rootController;
    [self initTabBarController];

    self.window.rootViewController = self.tabBarController;
    //[self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark custonTabBar
- (void)customizeTabBarForController:(UITabBarController *)tabBarController {
    NSArray *tabBarItemImages = @[@"home", @"activity", @"promote",@"profile"];
    
    NSInteger index = 0;
    for (UITabBarItem *item in [[tabBarController tabBar] items]) {
//        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
//        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press",
//                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setImage:unselectedimage];
        //[item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
}

@end

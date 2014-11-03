//
//  FFMusicController.m
//  sing365_beta_1.0
//
//  Created by Brian on 14-8-13.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "FFMusicController.h"
#import "LocalPlayController.h"
#import "Music.h"


@interface FFMusicController ()
@property (strong,nonatomic) NSMutableArray *localMusicArray;
@end

@implementation FFMusicController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"thirdMenu", @"");
        
        self.tableView = [[MusicListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocalMusicInfo];
    // Do any additional setup after loading the view.
}

-(void)getLocalMusicInfo
{
    _localMusicArray = [[NSMutableArray alloc] init];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = paths[0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        Music *music = [[Music alloc] init];
        NSString *musicName = [array objectAtIndex:i];
        music.musicName = musicName;
        NSString *fullPath = [filePath stringByAppendingPathComponent:musicName];
        music.musicPath = fullPath;
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            [_localMusicArray addObject:music];
        }else
        {
            NSLog(@"****file error~~~");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.localMusicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MusicCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Music *music = (Music *)self.localMusicArray[indexPath.row];
    cell.textLabel.text = music.musicName;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalPlayController *localPlatVC = [[LocalPlayController alloc] initWithArray:self.localMusicArray inRow:indexPath.row];
    [localPlatVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:localPlatVC animated:YES];
}


@end

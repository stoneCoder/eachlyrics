//
//  MainViewController.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 13-11-6.
//  Copyright (c) 2013年 Stone_Zl. All rights reserved.
//

#import "MainViewController.h"
#import "MusicListView.h"
#import "MusicViewCell.h"

@interface MainViewController ()

@end

@implementation MainViewController
- (id)initWithMusicCollection:(MPMediaItemCollection *)conllection
{
    self = [super initWithNibName:nil  bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"mainMenu", @"");
        //加载内容
        self.tableView = [[MusicListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        if (conllection) {
            self.array = [[NSMutableArray alloc] init];
            for (MPMediaItem *item in conllection.items) {
                [self.array addObject:item];
            }
        }else
        {
            [self initMusicItems];
        }
        if (self.array.count == 0) {
            self.tableView.labelNoResult.hidden = YES;
        }else
        {
            self.tableView.labelNoResult.hidden = NO;
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    //[self initMusicItems];
    [super viewDidLoad];
    
}

-(void)initMusicItems{
    self.array = [[NSMutableArray alloc] init];
    //获得query，用于请求本地歌曲集合
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    //循环获取得到query获得的集合
    for (MPMediaItemCollection *conllection in query.collections) {
        //MPMediaItem为歌曲项，包含歌曲信息
        for (MPMediaItem *item in conllection.items) {
            [self.array addObject:item];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction
{
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MusicCellIdentifier";
    MusicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MusicViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem *item = self.array[indexPath.row];
    //获得专辑对象
    MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
    //专辑封面
    UIImage *img = [artwork imageWithSize:CGSizeMake(60, 60)];
    if (!img) {
        img = [UIImage imageNamed:@"default_pic.png"];
    }
    cell.musicImage.image = img;
    cell.musicSpecialDetailLabel.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    cell.musicNameDetailLable.text = [item valueForProperty:MPMediaItemPropertyTitle];
    cell.musicPlayerDetailLable.text = [item valueForProperty:MPMediaItemPropertyArtist];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayViewController *mpc = [[MusicPlayViewController alloc] initWithArray:self.array inRow:indexPath.row];
    [mpc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:mpc animated:YES];
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

@end

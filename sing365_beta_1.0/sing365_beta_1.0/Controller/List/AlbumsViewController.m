//
//  PerformerViewController.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-17.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "AlbumsViewController.h"
#import "MainViewController.h"


@interface AlbumsViewController ()

@end

@implementation AlbumsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"secondMenu", @"");
        //加载内容
        self.tableView = [[MusicListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        if (self.items.count == 0) {
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
    [self initMusicItems];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initMusicItems{
    self.items = [[NSMutableArray alloc] init];
    //获得query，用于请求本地歌曲集合
    MPMediaQuery *query = [MPMediaQuery artistsQuery];
    //循环获取得到query获得的集合
    for (MPMediaItemCollection *conllection in query.collections) {
        //MPMediaItem为歌曲项，包含歌曲信息
        //for (MPMediaItem *item in conllection.items) {
            [self.items addObject:conllection];
       // }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MusicCellIdentifier";
    MusicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MusicViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItemCollection *collection = self.items[indexPath.row];
    if (collection) {
        int playMin = 0;
        NSArray *mpItems = collection.items;
        MPMediaItem *mpItem = mpItems[0];
        //获得专辑对象
        MPMediaItemArtwork *artwork = [mpItem valueForProperty:MPMediaItemPropertyArtwork];
        //专辑封面
        UIImage *img = [artwork imageWithSize:CGSizeMake(60, 60)];
        if (!img) {
            img = [UIImage imageNamed:@"default_pic.png"];
        }
        cell.musicImage.image = img;
        //获取总播放时间
        for (int i = 0 ; i<mpItems.count ; i++) {
            playMin+= [[mpItem valueForKeyPath:MPMediaItemPropertyPlaybackDuration] floatValue];
        }
        cell.musicPlayerDetailLable.text = [mpItem valueForProperty:MPMediaItemPropertyArtist];
        cell.musicPlayerDetailLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        cell.musicPlayerDetailLable.frame = CGRectMake(80, 0, 200, 50);
        cell.musicSpecialDetailLabel.text = [NSString stringWithFormat:@"%d songs，%d min",mpItems.count,playMin/60];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainViewController *mainViewController = [[MainViewController alloc] initWithMusicCollection:self.items[indexPath.row]];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

@end

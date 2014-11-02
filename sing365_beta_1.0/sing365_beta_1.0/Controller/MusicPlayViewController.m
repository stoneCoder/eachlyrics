//
//  MusicPlayViewController.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-20.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "ParseLrcUtil.h"

@interface MusicPlayViewController ()

@end

@implementation MusicPlayViewController
- (id)initWithArray:(NSMutableArray *)array inRow:(NSInteger)row
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.item = array[row];
        self.musicArray = array;
        self.index = row;
        CGFloat topOffset = 0;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            topOffset = STATUS_BAR_HEIGHT;
        }
        //        self.titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, topOffset, self.view.frame.size.width, NAVIGATION_BAR_LENGTH)];
        //        [self.view addSubview:self.titleView];
        //        [self.titleView.leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
        
        self.title = [self.item valueForKey:MPMediaItemPropertyTitle];
        if (!self.tableView)
        {
            topOffset = SCREEN_HEIGHT-96 -STATUS_BAR_HEIGHT - NAVIGATION_BAR_LENGTH;
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_LENGTH, self.view.bounds.size.width, topOffset)];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.view addSubview:self.tableView];
        }
        
        
        MPMediaItemArtwork *artwork = [self.item valueForProperty:MPMediaItemPropertyArtwork];
        //专辑封面
        UIImage *img = [artwork imageWithSize:CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height)];
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:img];
       
        //设置底部背景色
        topOffset = STATUS_BAR_HEIGHT+NAVIGATION_BAR_LENGTH+self.tableView.frame.size.height;
        UIImageView *buttonBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,topOffset, self.view.frame.size.width, 96)];
        buttonBackground.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerBarBackground" ofType:@"png"]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [self.view addSubview:buttonBackground];
        buttonBackground  = nil;
        //播放按钮
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(144, topOffset+20, 40, 40)];
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPlay" ofType:@"png"]] forState:UIControlStateNormal];
        self.playButton.showsTouchWhenHighlighted = YES;
        [self.view addSubview:self.playButton];//100, 420, 60, 25
        
        self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(140, topOffset+20, 40, 40)];
        [self.pauseButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPause" ofType:@"png"]] forState:UIControlStateNormal];
        self.pauseButton.showsTouchWhenHighlighted = YES;
        
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(220, topOffset+20, 40, 40)];
        [self.nextButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNextTrack" ofType:@"png"]]
                         forState:UIControlStateNormal];
        self.nextButton.showsTouchWhenHighlighted = YES;
        [self.view addSubview:self.nextButton];
        
        self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(60, topOffset+20, 40, 40)];
        [self.previousButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPrevTrack" ofType:@"png"]]
                             forState:UIControlStateNormal];
        self.previousButton.showsTouchWhenHighlighted = YES;
        [self.view addSubview:self.previousButton];
        
        /*滚动条*/
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(25, topOffset+75, 270, 9)];
        [self.slider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerVolumeKnob" ofType:@"png"]]
                          forState:UIControlStateNormal];
        [self.slider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                                 forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                                 forState:UIControlStateNormal];
        self.slider.minimumValue = 0.0;
        [self.view addSubview:self.slider];
        
        [self.playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.pauseButton addTarget:self action:@selector(pauseAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
        [self.nextButton addTarget:self action:@selector(playNext:) forControlEvents:UIControlEventTouchUpInside];
        [self.previousButton addTarget:self action:@selector(playBcak:) forControlEvents:UIControlEventTouchUpInside];
        
        /*进入开始播放音乐*/
        [self initPlayMusic];
        [self initParseLrc];
    }
    return self;
}

#pragma mark 修改按钮状态及滚动条状态
-(void)changeButtonTypeToPlay
{
    [self.playButton removeFromSuperview];
    [self.view addSubview:self.pauseButton];
}

-(void)changeButtonTypeToPause
{
    [self.pauseButton removeFromSuperview];
    [self.view addSubview:self.playButton];
}

-(void)changeSliderProgress
{
    double duration = [[self.item valueForKeyPath:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.slider.maximumValue = duration;
    CGFloat width = CGRectGetWidth([self.slider bounds]);
    double tolerance = 0.5f * duration / width;
    
    __weak MusicPlayViewController *weakSelf = self;
    
    self.mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC)
                                                                   queue:NULL /* If you pass NULL, the main queue is used. */
                                                              usingBlock:^(CMTime time)
                          {
                              [weakSelf playProgress];
                          }];
}

#pragma mark 按钮操作
-(void) playAudio:(id)sender
{
    [self.player play];
    
    [self changeButtonTypeToPlay];
    
    [self changeSliderProgress];
}

-(void) pauseAudio:(id) sender
{
    [self.player pause];
    
    [self changeButtonTypeToPause];
}

- (void)volumeSliderMoved:(UISlider *)sender
{
    [self.player seekToTime:CMTimeMakeWithSeconds([sender value], 1)];
}

-(void)playNext:(id)sender
{
    [self playNextMusic];
}

-(void)playBcak:(id)sender
{
    [self playBackMusic];
}

-(void)initParseLrc
{
     NSDictionary *dic = @{@"musicName": @"Rocketeer"};
    [[ParseLrcUtil shareInstance] getNetWorkStatus:^(NetworkStatus status){
        __weak NSDictionary *weakDic = dic;
        if (status == NotReachable) {
            NSLog(@"没有网络连接");
    }else if (status == ReachableViaWWAN){
    NSLog(@"使用3G网络");
    [[ParseLrcUtil shareInstance]  getLrcUrlPathRequest:weakDic andUrl:@"AutoInfoServlet" success:^(id json){
        NSLog(@"%@-------->",json);
        NSDictionary *dic = (NSDictionary *)json;
        if (dic) {
            
        }
    }failure:^(NSError *err){

    }];
    }else if (status == ReachableViaWiFi){
        //使用WiFi网络
        NSLog(@"使用WiFi网络");
        [[ParseLrcUtil shareInstance] getLrcUrlPathRequest:weakDic andUrl:@"AutoInfoServlet" success:^(id json){
            NSLog(@"%@-------->",json);
            NSDictionary *dic = (NSDictionary *)json;
            if (dic) {
                tempLrcPath = [dic objectForKey:@"lrcPath"];
                MusicLrcModel *lrcModel = [[MusicLrcModel alloc] initWithMp3FileServerPath:nil withLrcServerPath:tempLrcPath];
                [[MusicDownLoadManager shared] loadMusic:lrcModel];
                
                NSError *error = nil;
                NSString *textContent = [NSString stringWithContentsOfFile:lrcModel.lrcFileLocalPath encoding:NSUTF8StringEncoding error:&error];
                
                NSLog(@"error=%@",[error description]);
                NSArray * tempArray=[textContent componentsSeparatedByString:@"\n"];
                self.lrcArray = [[ParseLrcUtil shareInstance] parseLrcArray:tempArray];
                if([self.lrcArray count] > 0){
                    [self.tableView reloadData];
                }
            }
        }failure:^(NSError *err){
            
        }];
        
    }
}];
}

-(void)initPlayMusic
{
    NSMutableDictionary *musicDic = [[Workspace defaultWorkspace] getNowPlayMusic];
    AVPlayer *historyPlayer = [musicDic objectForKey:@"historyPlayer"];
    NSMutableArray *playMusic = [musicDic objectForKey:@"playMusic"];
    
    NSURL *url = [self.item valueForProperty:MPMediaItemPropertyAssetURL];
    if ([playMusic count] > 0) {
        NSString *historyUrl = [[playMusic[0] valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
        if ([historyUrl isEqualToString:[url absoluteString]]) {
            self.player = historyPlayer;
            [self changeButtonTypeToPlay];
            [self changeSliderProgress];
        }else
        {
            [historyPlayer replaceCurrentItemWithPlayerItem:nil];
            self.player = [self createAVPlayerWithItem:url];
            [self playAudio:nil];
            [[Workspace defaultWorkspace] saveNowPlayMusic:self.item andPlayer:self.player];
        }
    }else
    {
        self.player = [self createAVPlayerWithItem:url];
        [self playAudio:nil];
        [[Workspace defaultWorkspace] saveNowPlayMusic:self.item andPlayer:self.player];
    }
}

-(AVPlayer *)createAVPlayerWithItem:(NSURL *)url
{
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *avPlayer = [AVPlayer playerWithPlayerItem:anItem];
    return avPlayer;
}


-(int) currentPlayIndex:(NSString*) currentPlaySecond
{
    if (!currentPlaySecond || currentPlaySecond.length <= 0)
        return 0;
    int index;
    for (index = 0; index < self.lrcArray.count; index++)
    {
        NSDictionary *dic = [self.lrcArray objectAtIndex:index];
        if (dic)
        {
            NSString * strSecondValue = [dic.allKeys objectAtIndex:0];
            float fValue = strSecondValue.floatValue;
            if (fValue > currentPlaySecond.floatValue)
                break;
        }
    }
    return index - 1;
}

-(void)changeView
{
    MPMediaItem *item = self.musicArray[self.index];
    self.title = [item valueForKey:MPMediaItemPropertyTitle];
    MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
    //专辑封面
    UIImage *img = [artwork imageWithSize:CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height)];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:img];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//
//    if (object == self.player && [keyPath isEqualToString:@"status"]) {
////        if (self.player.status == AVPlayerStatusFailed) {
////            NSLog(@"AVPlayer Failed");
////        } else if (_player.status == AVPlayerStatusReadyToPlay) {
////            NSLog(@"AVPlayer Ready to Play");
////        } else if (_player.status == AVPlayerItemStatusUnknown) {
////            NSLog(@"AVPlayer Unknown");
////        }
//    }
//}

-(void)playNextMusic
{
    int musicIndex = 0;
    musicIndex = self.index + 1;
    if (musicIndex >= self.musicArray.count) {
        musicIndex = 0;
    }
    self.index = musicIndex;
    self.item = self.musicArray[musicIndex];
    [self stopPlay];
    [self initPlayMusic];
    [self changeView];

}

-(void)playBackMusic
{
    int musicIndex = 0;
    musicIndex = self.index - 1;
    if (musicIndex < 0) {
        musicIndex = (int)self.musicArray.count - 1;
    }
    self.index = musicIndex;
    self.item = self.musicArray[musicIndex];
    [self stopPlay];
    [self initPlayMusic];
    [self changeView];
}

- (float)playProgress
{
    if (self.player)
    {
        
        float fCurrentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
        float fDuration  = CMTimeGetSeconds(self.player.currentItem.duration);
        SliderUtils *su = [[SliderUtils alloc] init];
        su.arrayItemList = self.lrcArray;
        int currentIndex = [su currentPlayIndex:[NSString stringWithFormat:@"%f",fCurrentTime]];
        if (fCurrentTime!= 0) {
            //NSLog(@"the fCurrentTime is %f",fCurrentTime);
            [_slider setValue:fCurrentTime animated:YES];
        }
        //音频播放完毕
        if(fCurrentTime >= fDuration){
            [self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
            currentIndex = 0;
            [self.slider setValue:0.0f animated:YES];
            [self playNextMusic];
        }
        if (currentIndex && currentIndex >= 0) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(NSUInteger )currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
        return fCurrentTime;
    }
    return -1.0f;
}

-(void)stopPlay
{
    [self.player pause];
    self.player = nil;
    self.mTimeObserver = nil;
    [self.slider setValue:0.0f animated:YES];
}

#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)backView
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
    return self.lrcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"lrcCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (cell)
    {
        NSDictionary *dic = [self.lrcArray objectAtIndex:indexPath.row];
        NSString *key = @"key is nil";
        NSString *value = @"value is nil";
        if (dic)
        {
            key = [dic.allKeys objectAtIndex:0];
            value = [dic objectForKey:key];
            cell.textLabel.text = value;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont fontWithName: @"Arial" size: 15.0];
        }
    }
    //UIColor* color=[[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0];//通过RGB来定义颜色
    cell.selectedBackgroundView= [[UIView alloc]initWithFrame:cell.frame];
    //cell.selectedBackgroundView.backgroundColor= color;
    //设置选中字体的颜色为紫色
    cell.textLabel.highlightedTextColor = [UIColor purpleColor];
    return cell;
}

@end

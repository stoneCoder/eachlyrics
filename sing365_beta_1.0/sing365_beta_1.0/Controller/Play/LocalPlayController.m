//
//  LocalPlayController.m
//  sing365_beta_1.0
//
//  Created by Brian on 14-8-13.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "LocalPlayController.h"
#import "Workspace.h"

void audioQueueOutputCallback(void *inClientData, AudioQueueRef inAQ,
                              AudioQueueBufferRef inBuffer);
void audioQueueIsRunningCallback(void *inClientData, AudioQueueRef inAQ,
                                 AudioQueuePropertyID inID);

void audioQueueOutputCallback(void *inClientData, AudioQueueRef inAQ,
                              AudioQueueBufferRef inBuffer) {
    
    LocalPlayController *viewController = (__bridge LocalPlayController*)inClientData;
    [viewController audioQueueOutputCallback:inAQ inBuffer:inBuffer];
}

void audioQueueIsRunningCallback(void *inClientData, AudioQueueRef inAQ,
                                 AudioQueuePropertyID inID) {
    
    LocalPlayController *viewController = (__bridge LocalPlayController*)inClientData;
    [viewController audioQueueIsRunningCallback];
}

@interface LocalPlayController ()

@end

@implementation LocalPlayController

-(id)initWithArray:(NSMutableArray *)array inRow:(NSInteger)row
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.musicArray = array;
        self.index = row;
        music_ = array[row];
        /*获取文件名称和后缀名*/
        [self changeTitleView];
        // Custom initialization
        CGFloat topOffset = 0;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            topOffset = STATUS_BAR_HEIGHT;
        }
        if (!self.tableView)
        {
            topOffset = SCREEN_HEIGHT-96 -STATUS_BAR_HEIGHT - NAVIGATION_BAR_LENGTH;
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_LENGTH, self.view.bounds.size.width, topOffset)];
            self.tableView.delegate = self;
            [self.view addSubview:self.tableView];
        }
        
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
        
        [self playAudio:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self stopAudio_];
    [self removeAudioQueue];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self paseAudio_];
    [self removeAudioQueue];
    [super viewDidDisappear:YES];
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

#pragma mark 修改按钮状态及滚动条状态
-(void)changeTitleView
{
    if (music_) {
        NSArray *fileNameArray = [music_.musicName componentsSeparatedByString:@"."];
        self.title = fileNameArray[0];
        self.layoutName = fileNameArray[1];
    }
}
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

-(void) playAudio:(id)sender
{
    NSMutableDictionary *musicDic = [[Workspace defaultWorkspace] getNowPlayMusic];
    AVPlayer *historyPlayer = [musicDic objectForKey:@"historyPlayer"];
   
    if (historyPlayer) {
        [historyPlayer replaceCurrentItemWithPlayerItem:nil];
    }
    [self startAudio_];
    [self changeButtonTypeToPlay];
}

-(void) pauseAudio:(id) sender
{
    [self paseAudio_];
}

- (void)volumeSliderMoved:(UISlider *)sender
{
    if (started_) {
        state_ = AUDIO_STATE_SEEKING;
        
        AudioQueueStop(audioQueue_, YES);
        [ffmpegDecoder_ seekTime:self.slider.value];
        startedTime_ = self.slider.value;
        
        [self startAudio_];
    }
}

-(void)playNext:(id)sender
{
    [self playNextMusic];
}

-(void)playBcak:(id)sender
{
    [self playBackMusic];
}


- (void)updatePlaybackTime:(NSTimer*)timer {
    AudioTimeStamp timeStamp;
    OSStatus status = AudioQueueGetCurrentTime(audioQueue_, NULL, &timeStamp, NULL);
    
    if (status == noErr) {
        //SInt64 time = floor(durationTime_);
        NSTimeInterval currentTimeInterval = timeStamp.mSampleTime / audioStreamBasicDesc_.mSampleRate;
        //SInt64 currentTime = floor(startedTime_ + currentTimeInterval);
//        seekLabel_.text = [NSString stringWithFormat:@"%02llu:%02llu:%02llu / %02llu:%02llu:%02llu",
//                           ((currentTime / 60) / 60), (currentTime / 60), (currentTime % 60),
//                           ((time / 60) / 60), (time / 60), (time % 60)];
        
        self.slider.value = startedTime_ + currentTimeInterval;
    }
}

#pragma mark 播放相关
- (void)startAudio_ {
    if (started_) {
        AudioQueueStart(audioQueue_, NULL);
    }
    else {
        playingFilePath_ = music_.musicPath;
        
        if (![self createAudioQueue]) {
            abort();
        }
        [self startQueue];
      
        seekTimer_ = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self selector:@selector(updatePlaybackTime:) userInfo:nil repeats:YES];
    }
    
    for (NSInteger i = 0; i < kNumAQBufs; ++i) {
        [self enqueueBuffer:audioQueueBuffer_[i]];
    }
    
    state_ = AUDIO_STATE_PLAYING;
}

-(void)paseAudio_
{
    if (started_) {
        state_ = AUDIO_STATE_PAUSE;
        
        AudioQueuePause(audioQueue_);
        AudioQueueReset(audioQueue_);
    }
    
    [self changeButtonTypeToPause];
}

- (void)stopAudio_ {
    if (started_) {
        AudioQueueStop(audioQueue_, YES);
        self.slider.value = 0.0;
        startedTime_ = 0.0;
        
        //SInt64 time = floor(durationTime_);
//        seekLabel_.text = [NSString stringWithFormat:@"0 / %02llu:%02llu:%02llu",
//                           ((time / 60) / 60), (time / 60), (time % 60)];
        
        [ffmpegDecoder_ seekTime:0.0];
        
        state_ = AUDIO_STATE_STOP;
        finished_ = NO;
    }
}

- (BOOL)createAudioQueue {
    state_ = AUDIO_STATE_READY;
    finished_ = NO;
    
    decodeLock_ = [[NSLock alloc] init];
    ffmpegDecoder_ = [[FFmpegDecoder alloc] init];
    //ffmpegDecoder_ = [[FFmpegDecoder_1 alloc] init];
    NSInteger retLoaded = [ffmpegDecoder_ loadFile:playingFilePath_];
    if (retLoaded) return NO;
    
    
    // 16bit PCM LE.
    audioStreamBasicDesc_.mFormatID = kAudioFormatLinearPCM;
    audioStreamBasicDesc_.mSampleRate = ffmpegDecoder_.audioCodecContext_->sample_rate;
    audioStreamBasicDesc_.mBitsPerChannel = 16;
    audioStreamBasicDesc_.mChannelsPerFrame = ffmpegDecoder_.audioCodecContext_->channels;
    audioStreamBasicDesc_.mFramesPerPacket = 1;
    audioStreamBasicDesc_.mBytesPerFrame = audioStreamBasicDesc_.mBitsPerChannel / 8 * audioStreamBasicDesc_.mChannelsPerFrame;
    audioStreamBasicDesc_.mBytesPerPacket = audioStreamBasicDesc_.mBytesPerFrame * audioStreamBasicDesc_.mFramesPerPacket;
    audioStreamBasicDesc_.mReserved = 0;
    audioStreamBasicDesc_.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    
    durationTime_ = [ffmpegDecoder_ duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        //SInt64 time = floor(durationTime_);
//        seekLabel_.text = [NSString stringWithFormat:@"0 / %02llu:%02llu:%02llu",
//                           ((time / 60) / 60), (time / 60), (time % 60)];
        
        self.slider.maximumValue = durationTime_;
    });
    
    
    OSStatus status = AudioQueueNewOutput(&audioStreamBasicDesc_, audioQueueOutputCallback, (__bridge void*)self,
                                          NULL, NULL, 0, &audioQueue_);
    if (status != noErr) {
        NSLog(@"Could not create new output.");
        return NO;
    }
    
    status = AudioQueueAddPropertyListener(audioQueue_, kAudioQueueProperty_IsRunning,
                                           audioQueueIsRunningCallback, (__bridge void*)self);
    if (status != noErr) {
        NSLog(@"Could not add propery listener. (kAudioQueueProperty_IsRunning)");
        return NO;
    }
    
    
    //    [ffmpegDecoder_ seekTime:10.0];
    
    for (NSInteger i = 0; i < kNumAQBufs; ++i) {
//        status = AudioQueueAllocateBufferWithPacketDescriptions(audioQueue_,
//                                                                ffmpegDecoder_.audioCodecContext_->bit_rate * kAudioBufferSeconds / 8,
//                                                                ffmpegDecoder_.audioCodecContext_->sample_rate * kAudioBufferSeconds /
//                                                                ffmpegDecoder_.audioCodecContext_->frame_size + 1,
//                                                                audioQueueBuffer_ + i);
        status = AudioQueueAllocateBufferWithPacketDescriptions(audioQueue_,
                                                                audioStreamBasicDesc_.mSampleRate * kAudioBufferSeconds / 8,
                                                                audioStreamBasicDesc_.mSampleRate * kAudioBufferSeconds / audioStreamBasicDesc_.mFramesPerPacket + 1,
                                                                audioQueueBuffer_ + i);
        if (status != noErr) {
            NSLog(@"Could not allocate buffer.");
            return NO;
        }
    }
    
    return YES;
}

- (void)removeAudioQueue {
    [self stopAudio_];
    started_ = NO;
    
    for (NSInteger i = 0; i < kNumAQBufs; ++i) {
        AudioQueueFreeBuffer(audioQueue_, audioQueueBuffer_[i]);
    }
    AudioQueueDispose(audioQueue_, YES);
}


- (void)audioQueueOutputCallback:(AudioQueueRef)inAQ inBuffer:(AudioQueueBufferRef)inBuffer {
    if (state_ == AUDIO_STATE_PLAYING) {
        [self enqueueBuffer:inBuffer];
    }
}

- (void)audioQueueIsRunningCallback {
    UInt32 isRunning;
    UInt32 size = sizeof(isRunning);
    OSStatus status = AudioQueueGetProperty(audioQueue_, kAudioQueueProperty_IsRunning, &isRunning, &size);
    
    if (status == noErr && !isRunning && state_ == AUDIO_STATE_PLAYING) {
        state_ = AUDIO_STATE_STOP;
        [self playNextMusic];
        if (finished_) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //SInt64 time = floor(durationTime_);
//                seekLabel_.text = [NSString stringWithFormat:@"%02llu:%02llu:%02llu / %02llu:%02llu:%02llu",
//                                   ((time / 60) / 60), (time / 60), (time % 60),
//                                   ((time / 60) / 60), (time / 60), (time % 60)];
            });
        }
    }
}


- (OSStatus)enqueueBuffer:(AudioQueueBufferRef)buffer {
    OSStatus status = noErr;
    NSInteger decodedDataSize = 0;
    buffer->mAudioDataByteSize = 0;
    buffer->mPacketDescriptionCount = 0;
    
    [decodeLock_ lock];
    
    while (buffer->mPacketDescriptionCount < buffer->mPacketDescriptionCapacity) {
        decodedDataSize = [ffmpegDecoder_ decode];
        
        if (decodedDataSize && buffer->mAudioDataBytesCapacity - buffer->mAudioDataByteSize >= decodedDataSize) {
            
            memcpy(buffer->mAudioData + buffer->mAudioDataByteSize,ffmpegDecoder_.audioBuffer_, decodedDataSize);
        
            buffer->mPacketDescriptions[buffer->mPacketDescriptionCount].mStartOffset = buffer->mAudioDataByteSize;
            buffer->mPacketDescriptions[buffer->mPacketDescriptionCount].mDataByteSize = decodedDataSize;
            buffer->mPacketDescriptions[buffer->mPacketDescriptionCount].mVariableFramesInPacket = audioStreamBasicDesc_.mFramesPerPacket;

            buffer->mAudioDataByteSize += decodedDataSize;
            buffer->mPacketDescriptionCount++;
            [ffmpegDecoder_ nextPacket];
        }
        else {
            break;
        }
    }
    
    
    if (buffer->mPacketDescriptionCount > 0) {
        status = AudioQueueEnqueueBuffer(audioQueue_, buffer, 0, NULL);
        if (status != noErr) {
            NSLog(@"Could not enqueue buffer.");
        }
    }
    else {
        AudioQueueStop(audioQueue_, NO);
        finished_ = YES;

        [self.slider setValue:0.0f animated:YES];
    }
    
    [decodeLock_ unlock];
    
    return status;
}

- (OSStatus)startQueue {
    OSStatus status = noErr;
    
    if (!started_) {
        status = AudioQueueStart(audioQueue_, NULL);
        if (status == noErr) {
            started_ = YES;
        }
        else {
            NSLog(@"Could not start audio queue.");
        }
    }
    
    return status;
}

-(void)playNextMusic
{
    playingFilePath_ = nil;
    int musicIndex = 0;
    musicIndex = self.index + 1;
    if (musicIndex >= self.musicArray.count) {
        musicIndex = 0;
    }
    self.index = musicIndex;
    music_ = self.musicArray[musicIndex];

    [self paseAudio_];
    started_ = NO;
    AudioQueueDispose(audioQueue_,YES);
    [self startAudio_];
    startedTime_ = 0.0;
    [self changeButtonTypeToPlay];
    [self changeTitleView];
}

-(void)playBackMusic
{
    int musicIndex = 0;
    musicIndex = self.index - 1;
    if (musicIndex < 0) {
        musicIndex = (int)self.musicArray.count - 1;
    }
    self.index = musicIndex;
    music_ = self.musicArray[musicIndex];

    [self paseAudio_];
    started_ = NO;
    AudioQueueDispose(audioQueue_,YES);
    [self startAudio_];
    startedTime_ = 0.0;
    [self changeButtonTypeToPlay];
    [self changeTitleView];
}

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
    
    return cell;
}
@end

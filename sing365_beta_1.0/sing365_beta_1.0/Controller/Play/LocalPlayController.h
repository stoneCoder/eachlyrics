//
//  LocalPlayController.h
//  sing365_beta_1.0
//
//  Created by Brian on 14-8-13.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
//#import "FFmpegDecoder_1.h"
#import "FFmpegDecoder.h"
#import "Music.h"

#define kNumAQBufs 3
#define kAudioBufferSeconds 3

typedef enum _AUDIO_STATE {
    AUDIO_STATE_READY           = 0,
    AUDIO_STATE_STOP            = 1,
    AUDIO_STATE_PLAYING         = 2,
    AUDIO_STATE_PAUSE           = 3,
    AUDIO_STATE_SEEKING         = 4
} AUDIO_STATE;

@interface LocalPlayController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSString *playingFilePath_;
    AudioStreamBasicDescription audioStreamBasicDesc_;
    AudioQueueRef audioQueue_;
    AudioQueueBufferRef audioQueueBuffer_[kNumAQBufs];
    BOOL started_, finished_;
    NSTimeInterval durationTime_, startedTime_;
    NSInteger state_;
    NSTimer *seekTimer_;
    NSLock *decodeLock_;
    Music *music_;
    FFmpegDecoder *ffmpegDecoder_;
    //FFmpegDecoder_1 *ffmpegDecoder_;
}
@property (strong,nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIButton* playButton;
@property(strong, nonatomic) UIButton* pauseButton;
@property(strong, nonatomic) UIButton* nextButton;
@property(strong, nonatomic) UIButton* previousButton;
@property(strong, nonatomic) UISlider* slider;

@property (nonatomic, strong) NSMutableArray *lrcArray;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic) int index;
@property (nonatomic, strong) NSString *layoutName;

- (void)updatePlaybackTime:(NSTimer*)timer;

- (void)startAudio_;
- (void)stopAudio_;
- (BOOL)createAudioQueue;
- (void)removeAudioQueue;
- (void)audioQueueOutputCallback:(AudioQueueRef)inAQ inBuffer:(AudioQueueBufferRef)inBuffer;
- (void)audioQueueIsRunningCallback;
- (OSStatus)enqueueBuffer:(AudioQueueBufferRef)buffer;
- (OSStatus)startQueue;

-(id)initWithArray:(NSMutableArray *)array inRow:(NSInteger)row;
@end

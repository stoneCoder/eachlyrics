//
//  Workspace.m
//  SmartXHSD
//
//  Created by 左德彪 on 14-3-26.
//  Copyright (c) 2014年 com.fezo. All rights reserved.
//

#import "Workspace.h"

static Workspace *ws = nil;

@interface Workspace ()

@property (strong, nonatomic) NSMutableArray *playMusic;
@property (strong, nonatomic) AVPlayer *historyPlayer;
@property (strong, nonatomic) NSMutableDictionary *musicDic;

@end

@implementation Workspace

+ (Workspace*)defaultWorkspace
{
    @synchronized(self) {
        if (!ws) {
            ws = [[Workspace alloc] init];
        }
    }
    return ws;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.playMusic = [NSMutableArray array];
        self.historyPlayer = [[AVPlayer alloc] init];
        self.musicDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSMutableDictionary *)getNowPlayMusic
{
    [_musicDic setObject:_playMusic forKey:@"playMusic"];
    [_musicDic setObject:_historyPlayer forKey:@"historyPlayer"];
    return _musicDic;
}

-(void)saveNowPlayMusic:(MPMediaItem *)musicItem andPlayer:(AVPlayer *)player
{
    [self removeNowPlayMusic];
    [_playMusic addObject:musicItem];
    _historyPlayer = player;
}

-(void)removeNowPlayMusic
{
    [_playMusic removeAllObjects];
    [_historyPlayer replaceCurrentItemWithPlayerItem:nil];
}

@end

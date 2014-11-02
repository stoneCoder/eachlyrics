//
//  Workspace.h
//  SmartXHSD
//
//  Created by 左德彪 on 14-3-26.
//  Copyright (c) 2014年 com.fezo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaPlayer/MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface Workspace : NSObject

+ (Workspace*)defaultWorkspace;
- (id)init;

-(NSMutableDictionary *)getNowPlayMusic;
-(void)saveNowPlayMusic:(MPMediaItem *)musicItem andPlayer:(AVPlayer *)player;
-(void)removeNowPlayMusic;
@end

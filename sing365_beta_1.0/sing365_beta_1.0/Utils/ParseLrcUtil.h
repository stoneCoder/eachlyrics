//
//  ParseLrcUtil.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-11-2.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ParseLrcUtil : NSObject
{
    NSMutableArray  *_tempArrayList;
    NSMutableArray  *_arrayItemList;
}
+ (ParseLrcUtil*)shareInstance;

-(void)getNetWorkStatus:(void(^)(NetworkStatus status))finish;
-(void)getLrcUrlPathRequest:(NSDictionary *)request
                andUrl:(NSString *)urlPath
                success:(void (^)(id json))success
                failure:(void (^)( NSError *err))failure;
/*Parse Lrc Arr*/
-(NSMutableArray *)parseLrcArray:(NSArray *)tempArray;
-(NSString *) parseLrcLine:(NSString *)sourceLineText;
-(void) parseTempArray:(NSMutableArray *) tempArray;
-(NSMutableArray *)sortAllItem:(NSMutableArray *)array;
-(NSString *)timeToSecond:(NSString *)formatTime;
@end

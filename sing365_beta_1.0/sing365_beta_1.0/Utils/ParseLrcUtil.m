//
//  ParseLrcUtil.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-11-2.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "ParseLrcUtil.h"
#import "Service.h"
static ParseLrcUtil *plu = nil;
@implementation ParseLrcUtil

+ (ParseLrcUtil*)shareInstance
{
    @synchronized(self) {
        if (!plu) {
            plu = [[ParseLrcUtil alloc] init];
        }
    }
    return plu;
}

-(void)getNetWorkStatus:(void(^)(NetworkStatus status))finish
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus networkStatus = [r currentReachabilityStatus];
    finish(networkStatus);
}

-(void)getLrcUrlPathRequest:(NSDictionary *)request andUrl:(NSString *)urlPath success:(void (^)(id json))success failure:(void (^)( NSError *err))failure{
    [[Service sharedService] post:urlPath Parameters:request success:^(AFHTTPRequestOperation * o, id json) {
        success(json);
    } failure:^(AFHTTPRequestOperation * o, NSError * err) {
        failure(err);
    }];
}

-(NSMutableArray *)parseLrcArray:(NSArray *)tempArray
{
    _tempArrayList = [NSMutableArray array];
    _arrayItemList = [NSMutableArray array];
    for (NSString * str in tempArray)
    {
        if (!str || str.length <= 0)
            continue;
        [self parseLrcLine:str];
        [self parseTempArray:_tempArrayList];
    }
    [self sortAllItem:_arrayItemList];
    return _arrayItemList;
}

-(NSString*) parseLrcLine:(NSString *)sourceLineText
{
    if (!sourceLineText || sourceLineText.length <= 0)
        return nil;
    NSRange range = [sourceLineText rangeOfString:@"]"];
    if (range.length > 0)
    {
        NSString * time = [sourceLineText substringToIndex:range.location + 1];
        NSString * other = [sourceLineText substringFromIndex:range.location + 1];
        if (time && time.length > 0)
            [_tempArrayList addObject:time];
        if (other)
            [self parseLrcLine:other];
    }else
    {
        [_tempArrayList addObject:sourceLineText];
    }
    return nil;
}

-(void) parseTempArray:(NSMutableArray *) tempArray
{
    if (!tempArray || tempArray.count <= 0)
        return;
    NSString *value = [tempArray lastObject];
    if (!value || ([value rangeOfString:@"["].length > 0 && [value rangeOfString:@"]"].length > 0))
    {
        [_tempArrayList removeAllObjects];
        return;
    }
    
    for (int i = 0; i < tempArray.count - 1; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString * key = [tempArray objectAtIndex:(NSUInteger)i];
        NSString *secondKey = [self timeToSecond:key]; // 转换成以秒为单位的时间计数器
        [dic setObject:value forKey:secondKey];
        [_arrayItemList addObject:dic];
    }
    [_tempArrayList removeAllObjects];
}


-(NSMutableArray *)sortAllItem:(NSMutableArray *)array {
    if (!array || array.count <= 0)
        return nil;
    for (int i = 0; i < array.count - 1; i++)
    {
        for (int j = i + 1; j < array.count; j++)
        {
            id firstDic = [array objectAtIndex:(NSUInteger )i];
            id secondDic = [array objectAtIndex:(NSUInteger)j];
            if (firstDic && [firstDic isKindOfClass:[NSDictionary class]] && secondDic && [secondDic isKindOfClass:[NSDictionary class]])
            {
                NSString *firstTime = [[firstDic allKeys] objectAtIndex:0];
                NSString *secondTime = [[secondDic allKeys] objectAtIndex:0];
                BOOL b = firstTime.floatValue > secondTime.floatValue;
                if (b) // 第一句时间大于第二句，就要进行交换
                {
                    [array replaceObjectAtIndex:(NSUInteger )i withObject:secondDic];
                    [array replaceObjectAtIndex:(NSUInteger )j withObject:firstDic];
                }
            }
        }
    }
    return array;
}

-(NSString *)timeToSecond:(NSString *)formatTime {
    if (!formatTime || formatTime.length <= 0)
        return nil;
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0)
        return nil;
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    NSString * second = [formatTime substringWithRange:NSMakeRange(4, 5)];
    float finishSecond = minutes.floatValue * 60 + second.floatValue;
    return [NSString stringWithFormat:@"%f",finishSecond];
}
@end

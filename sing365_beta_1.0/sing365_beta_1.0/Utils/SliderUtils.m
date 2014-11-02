//
//  SliderUtils.m
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-20.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import "SliderUtils.h"

@implementation SliderUtils

-(int) currentPlayIndex:(NSString*) currentPlaySecond
{
    if (!currentPlaySecond || currentPlaySecond.length <= 0)
        return 0;
    int index;
    for (index = 0; index < self.arrayItemList.count; index++)
    {
        NSDictionary *dic = [self.arrayItemList objectAtIndex:index];
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

@end

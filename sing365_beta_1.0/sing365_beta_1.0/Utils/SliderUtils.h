//
//  SliderUtils.h
//  sing365_beta_1.0
//
//  Created by 张 磊 on 14-4-20.
//  Copyright (c) 2014年 Stone_Zl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SliderUtils : NSObject
@property(nonatomic, strong) NSMutableArray *arrayItemList;

-(int) currentPlayIndex:(NSString*) currentPlaySecond;
@end

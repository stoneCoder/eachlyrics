//
//  Service.m
//  AutoTour
//
//  Created by hanjin on 14-3-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "Service.h"

@implementation Service
DEFINE_SINGLETON_FOR_CLASS(Service)
-(void) post:(NSString*)uri Parameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation * o, id json))success failure:(void (^)(AFHTTPRequestOperation * o, NSError * e))failure{
    NSString* urlStr=[NSString stringWithFormat:@"%@%@",CONNECT_URL,uri];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager POST:urlStr parameters:parameters success:success failure:failure];
}
-(void) get:(NSString*)uri Parameters:(NSDictionary *)parameters  success:(void (^)(AFHTTPRequestOperation * o, id json))success failure:(void (^)(AFHTTPRequestOperation * o, NSError * e))failure{
    NSString* urlStr=[NSString stringWithFormat:@"%@%@",CONNECT_URL,uri];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}



@end

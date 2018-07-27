//
//  TrochilusNetWorking.m
//  Trochilus
//
//  Created by 王权伟 on 2018/7/27.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "TrochilusNetWorking.h"

@implementation TrochilusNetWorking

+ (void)getWithUrl:(NSString *)url success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure {
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:url];
    request.timeoutInterval = 20.5f;
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil) {
                
                NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                if (success) {
                    success(userInfo);
                }
                
            }
            else {
                
                if (failure) {
                    failure(error);
                }
            }
            
        });
        
    }];
    
    [task resume];
    
}

+ (void)postWithUrl:(NSString *)url success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    
}

@end

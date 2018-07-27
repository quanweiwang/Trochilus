//
//  TrochilusNetWorking.h
//  Trochilus
//
//  Created by 王权伟 on 2018/7/27.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrochilusNetWorking : NSObject

+ (void)getWithUrl:(NSString *)url success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+ (void)postWithUrl:(NSString *)url success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

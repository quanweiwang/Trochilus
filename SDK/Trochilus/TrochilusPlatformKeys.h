//
//  TrochilusPlatformKeys.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/24.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrochilusPlatformKeys : NSObject

@property (strong,nonatomic,readonly) NSString * qqAppId;   //QQ appId
@property (strong,nonatomic,readonly) NSString * qqAppKey;  //QQ appKey
@property (strong,nonatomic,readonly) NSString * qqAuthType;//QQ authType
@property (assign,nonatomic,readonly) BOOL useTIM;  //QQ useTIM

@property (strong,nonatomic,readonly) NSString * wechatAppId; //Wechat appId
@property (strong,nonatomic,readonly) NSString * wechatAppSecret; //Wechat appSecret

@property (strong,nonatomic,readonly) NSString * weiboAppKey; //Sina WeiBo appId
@property (strong,nonatomic,readonly) NSString * weiboAppSecret; //Sina WeiBo appSecret
@property (strong,nonatomic,readonly) NSString * weiboRedirectUri; //Sina WeiBo redirectUri
@property (strong,nonatomic,readonly) NSString * weiboAuthType; //Sina WeiBo authType

+ (instancetype)sharedInstance;

//设置QQ平台参数
- (void)setQQAppId:(NSString *)appId appKey:(NSString *)appKey authType:(NSString *)authType useTIM:(BOOL)useTIM;

//设置微信平台参数
- (void)setWechatAppId:(NSString *)appId appSecret:(NSString *)appSecret;

////设置微博平台参数
- (void)setSinaWeiBoAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectUri:(NSString *)redirectUri authType:(NSString *)authType;

@end


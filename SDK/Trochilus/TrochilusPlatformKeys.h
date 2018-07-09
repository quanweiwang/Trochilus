//
//  TrochilusPlatformKeys.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/24.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrochilusPlatformKeys : NSObject

@property (nonatomic, readonly, strong) NSString * qqAppId;   //QQ appId
@property (nonatomic, readonly, strong) NSString * qqAppKey;  //QQ appKey
@property (nonatomic, readonly, strong) NSString * qqAuthType;//QQ authType
@property (nonatomic, readonly, assign) BOOL useTIM;  //QQ useTIM

@property (nonatomic, readonly, strong) NSString * wechatAppId; //Wechat appId
@property (nonatomic, readonly, strong) NSString * wechatAppSecret; //Wechat appSecret

@property (nonatomic, readonly, strong) NSString * weiboAppKey; //Sina WeiBo appId
@property (nonatomic, readonly, strong) NSString * weiboAppSecret; //Sina WeiBo appSecret
@property (nonatomic, readonly, strong) NSString * weiboRedirectUri; //Sina WeiBo redirectUri
@property (nonatomic, readonly, strong) NSString * weiboAuthType; //Sina WeiBo authType

+ (instancetype)sharedInstance;

//设置QQ平台参数
- (void)setQQAppId:(NSString *)appId appKey:(NSString *)appKey authType:(NSString *)authType useTIM:(BOOL)useTIM;

//设置微信平台参数
- (void)setWechatAppId:(NSString *)appId appSecret:(NSString *)appSecret;

////设置微博平台参数
- (void)setSinaWeiBoAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectUri:(NSString *)redirectUri authType:(NSString *)authType;

@end


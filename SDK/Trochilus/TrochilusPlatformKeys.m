//
//  TrochilusPlatformKeys.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/24.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusPlatformKeys.h"
@interface TrochilusPlatformKeys() {
    
    //QQ
    NSString * _qqAppId;
    NSString * _qqAppKey;
    NSString * _qqAuthType;
    BOOL _useTIM;
    
    //Wechat
    NSString * _wechatAppId;
    NSString * _wechatAppSecret;
    
    //Sina WeiBo
    NSString * _weiboAppKey;
    NSString * _weiboAppSecret;
    NSString * _weiboRedirectUri;
    NSString * _weiboAuthType;
    
}
@end

@implementation TrochilusPlatformKeys

static TrochilusPlatformKeys* _instance = nil;

#pragma mark- 单例模式
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

- (void)setQQAppId:(NSString *)appId appKey:(NSString *)appKey authType:(NSString *)authType useTIM:(BOOL)useTIM {
    
    _qqAppId = appId;
    _qqAppKey = appKey;
    _qqAuthType = authType;
    _useTIM = useTIM;
}

- (void)setWechatAppId:(NSString *)appId appSecret:(NSString *)appSecret {
    _wechatAppId = appId;
    _wechatAppSecret = appSecret;
}

- (void)setSinaWeiBoAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectUri:(NSString *)redirectUri authType:(NSString *)authType {
    _weiboAppKey = appKey;
    _weiboAppSecret = appSecret;
    _weiboRedirectUri = redirectUri;
    _weiboAuthType = authType;
}

//QQ
- (NSString *)qqAppId {
    return _qqAppId;
}

- (NSString *)qqAppKey {
    return _qqAppKey;
}

- (NSString *)qqAuthType {
    return _qqAuthType;
}

- (BOOL)qqUseTIM {
    return _useTIM;
}

//Wechat
- (NSString *)wechatAppId {
    return _wechatAppId;
}

- (NSString *)wechatAppSecret {
    return _wechatAppSecret;
}

//Sina WeiBo
- (NSString *)weiboAppKey {
    return _weiboAppKey;
}

- (NSString *)weiboAppSecret {
    return _weiboAppSecret;
}

- (NSString *)weiboAuthType {
    return _weiboAuthType;
}

- (NSString *)weiboRedirectUri {
    return _weiboRedirectUri;
}

@end


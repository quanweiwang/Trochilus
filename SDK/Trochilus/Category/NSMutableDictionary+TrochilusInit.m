//
//  NSMutableDictionary+Init.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSMutableDictionary+TrochilusInit.h"
#import "TrochilusTypeDefine.h"
#import "TrochilusPlatformKeys.h"

@implementation NSMutableDictionary (TrochilusInit)

/**
 *  设置QQ分享平台（QQ空间，QQ好友分享）应用信息 4.0.0增加
 *
 *  @param appId          应用标识
 *  @param appKey         应用Key
 *  @param authType       授权方式。值可以是：TAuthTypeSSO、TAuthTypeWeb、TAuthTypeBoth，分别代表SSO、网页授权、SSO＋网页授权。
 *  @param useTIM         是否优先使用TIM进行授权及分享
 */
- (void)trochilus_SetupQQByAppId:(NSString *)appId
                          appKey:(NSString *)appKey
                        authType:(NSString *)authType
                          useTIM:(BOOL)useTIM {
    
    [[TrochilusPlatformKeys sharedInstance] setQQAppId:appId appKey:appKey authType:authType useTIM:useTIM];
    
}

/**
 *  设置微信(微信好友，微信朋友圈、微信收藏)应用信息
 *
 *  @param appId      应用标识
 *  @param appSecret  应用密钥
 */
- (void)trochilus_SetupWeChatByAppId:(NSString *)appId
                           appSecret:(NSString *)appSecret {
    
    [[TrochilusPlatformKeys sharedInstance] setWechatAppId:appId appSecret:appSecret];
}

/**
 *  设置新浪微博应用信息
 *
 *  @param appKey       应用标识
 *  @param appSecret    应用密钥
 *  @param redirectUri  回调地址
 *  @param authType     授权方式。值可以是：TAuthTypeSSO、TAuthTypeWeb、TAuthTypeBoth，分别代表SSO、网页授权、SSO＋网页授权。
 */
- (void)trochilus_SetupSinaWeiboByAppKey:(NSString *)appKey
                               appSecret:(NSString *)appSecret
                             redirectUri:(NSString *)redirectUri
                                authType:(NSString *)authType {
    
    [[TrochilusPlatformKeys sharedInstance] setSinaWeiBoAppKey:appKey appSecret:appSecret redirectUri:redirectUri authType:authType];
}

@end

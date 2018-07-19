//
//  NSMutableDictionary+Init.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TrochilusInit)

/**
 *  设置QQ分享平台（QQ空间，QQ好友分享）应用信息 4.0.0增加
 *
 *  @param appId          应用标识
 *  @param appKey         应用Key
 *  @param authType       授权方式。值可以是：TAuthTypeSSO、TAuthTypeWeb、TAuthTypeBoth，分别代表SSO、网页授权、SSO＋网页授权。
 *  @param useTIM         是否优先使用TIM进行授权及分享
 */
- (void)trochilusSetQQByAppId:(NSString *)appId
                          appKey:(NSString *)appKey
                        authType:(NSString *)authType
                          useTIM:(BOOL)useTIM;

/**
 *  设置微信(微信好友，微信朋友圈、微信收藏)应用信息
 *
 *  @param appId      应用标识
 *  @param appSecret  应用密钥
 */
- (void)trochilusSetWeChatByAppId:(NSString *)appId
                           appSecret:(NSString *)appSecret;

/**
 *  设置新浪微博应用信息
 *
 *  @param appKey       应用标识
 *  @param appSecret    应用密钥
 *  @param redirectUri  回调地址
 *  @param authType     授权方式。值可以是：TAuthTypeSSO、TAuthTypeWeb、TAuthTypeBoth，分别代表SSO、网页授权、SSO＋网页授权。
 */
- (void)trochilusSetSinaWeiboByAppKey:(NSString *)appKey
                               appSecret:(NSString *)appSecret
                             redirectUri:(NSString *)redirectUri
                                authType:(NSString *)authType;


@end

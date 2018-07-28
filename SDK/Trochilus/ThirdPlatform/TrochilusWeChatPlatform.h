//
//  TrochilusWeChatPlatform.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrochilusTypeDefine.h"
@class TrochilusMessage;

@interface TrochilusWeChatPlatform : NSObject

+ (instancetype)sharedInstance;

+ (void)registerWithParameters:(NSDictionary *)parameters;

/**
 判断是否安装了微信
 
 @return YES or NO
 */
+ (BOOL)isWeChatInstalled;

/**
 分享到微信平台

 @param platformType 分享类型 只能为 微信好友:TrochilusPlatformSubTypeWechatSession 朋友圈:TrochilusPlatformSubTypeWechatTimeline 微信收藏:TrochilusPlatformSubTypeWechatFav
 @param parameter 分享参数
 @param stateChangedHandler 分享状态变更回调处理
 @return 构造好用于提交给微信的字符串
 */
+ (NSString *)shareWithPlatformType:(TrochilusPlatformType)platformType
                          parameter:(NSMutableDictionary *)parameter
                     onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler;

/**
 *  微信授权
 *
 *  @param settings    授权设置,目前只接受@"snsapi_userinfo",@"snsapi_message",@"snsapi_friend",@"snsapi_contact"这些字段,多个使用请使用英文逗号隔开，默认@"snsapi_userinfo"。
 *  @param stateChangedHandler 授权状态变更回调处理
 */
+ (NSMutableString *)authorizeWithPlatformSettings:(NSString *)settings
                                          onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler;


/**
 微信支付
 
 @param parameters 支付参数 需要手动拼接
 @return 支付字符串
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (NSString *)payToWechatParameters:(id)parameters
                     onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler;

/**
 微信客户端回调
 
 @param url 回调Url
 @return YES or NO
 */
+ (BOOL)handleUrlWithWeChat:(NSURL *)url;

@end


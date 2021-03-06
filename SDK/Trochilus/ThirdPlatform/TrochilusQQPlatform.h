//
//  TrochilusQQPlatform.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrochilusTypeDefine.h"

@interface TrochilusQQPlatform : NSObject

+ (instancetype) sharedInstance;

+ (void)registerWithParameters:(NSString *)parameters;

/**
 判断是否安装了QQ
 
 @return YES or NO
 */
+ (BOOL)isQQInstalled;

/**
 判断是否安装了TIM
 @return YES or NO
 */
+ (BOOL)isTIMInstalled;

/**
 分享到QQ平台
 
 @param parameters QQ平台分享参数
 @param stateChangedHandler 分享状态变更回调处理
 @return 构造好用于提交给QQ的字符串
 */
+ (NSString *)shareWithPlatformType:(TrochilusPlatformType)platformType
                          parameter:(NSMutableDictionary *)parameters
                     onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler;

/**
 *  分享平台授权
 *
 *  @param settings    授权设置,默认为@"get_user_info"。
 *   Scopes:http://wiki.open.qq.com/wiki/%E3%80%90QQ%E7%99%BB%E5%BD%95%E3%80%91API%E6%96%87%E6%A1%A3
 *  @param stateChangedHandler 授权状态变更回调处理
 */
+ (NSMutableString *)authorizeWithPlatformSettings:(NSDictionary *)settings
                                      onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler;


/**
 QQ客户端回调
 @param url 回调Url
 @return YES or NO
 */
+ (BOOL)handleUrlWithQQ:(NSURL *)url;

@end


//
//  Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrochilusTypeDefine.h"
#import "NSMutableDictionary+TrochilusInit.h"
#import "NSMutableDictionary+TrochilusShare.h"
#import "NSMutableDictionary+TrochilusPay.h"
#import "TrochilusError.h"

@interface Trochilus : NSObject

/**
 *  初始化Trochilus应用
 *
 *  @param thirdPlatforms          使用的分享平台集合，如:@[@(TrochilusPlatformTypeSinaWeibo), @(TrochilusPlatformTypeTencentWeibo)];
 *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
 */
+ (void)registerPlatforms:(NSArray *)thirdPlatforms
          onConfiguration:(TrochilusConfigurationHandler)configurationHandler;

/**
 分享
 
 @param platformType 分享平台 例如QQ好友 QZone 微信好友 微信朋友圈 微博等
 @param parameters 分享平台参数
 @param stateChangedHandler 分享状态变更回调处理
 */
+ (void)shareWithPlatformType:(TrochilusPlatformType)platformType parameters:(NSMutableDictionary *)parameters onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler;

/**
 登录 授权
 
 @param platformType 登录授权平台 只能选TrochilusPlatformTypeQQ（QQ平台）、TrochilusPlatformTypeWechat(微信平台)、TrochilusPlatformTypeSinaWeibo（新浪微博）
 @param settings 授权设置,目前只接受TAuthSettingKeyScopes属性设置，如新浪微博关注官方微博：@{TAuthSettingKeyScopes : @[@"follow_app_official_microblog"]}，类似“follow_app_official_microblog”这些字段是各个社交平台提供的。
 @param stateChangedHandler 授权状态变更回调处理
 */
+ (void)authorizeWithPlatformType:(TrochilusPlatformType)platformType
                         settings:(NSDictionary *)settings
                   onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler;

/**
 微信支付
 
 @param parameters 支付参数 支持拼接好的字符串 和 未拼接的字典
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (void)wechatPayWithParameters:(id)parameters onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler;

/**
 支付宝支付
 
 @param urlScheme 应用注册scheme,在Info.plist定义URL types 必须一致 否则将无法返回app
 @param orderString 支付参数 服务器拼接好
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (void)aLiPayWithUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler;


/**
 支付宝打赏
 
 @param url 二维码解析出来的地址
 */
+ (void)aliTipWithQRCodeUrl:(NSString *)url;

/**
 第三方平台回调
 
 @param url NSURL
 @return YES or NO
 */
+ (BOOL)handleURL:(NSURL *)url;

/**
 客户端是否安装
 
 @param platformType 平台类型
 @return 已安装 YES 未安装 NO
 */
+ (BOOL)isInstalledPlatformType:(TrochilusPlatformType)platformType;


@end


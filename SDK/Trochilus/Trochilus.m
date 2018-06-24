//
//  Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "Trochilus.h"
#import <UIKit/UIKit.h>
#import "TrochilusQQPlatform.h"
#import "TrochilusWeChatPlatform.h"
#import "TrochilusSinaWeiBoPlatform.h"
#import "TrochilusAliPayPlatform.h"
#import "TrochilusPlatformKeys.h"
#import "TrochilusSysDefine.h"

@interface Trochilus ()

@end

@implementation Trochilus

static Trochilus * _instance = nil;

#pragma mark- 单例模式
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

/**
 *  初始化Trochilus应用
 *
 *  @param thirdPlatforms          使用的分享平台集合，如:@[@(TrochilusPlatformTypeSinaWeibo), @(TrochilusPlatformTypeTencentWeibo)];
 *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
 */
+ (void)registerPlatforms:(NSArray *)thirdPlatforms
          onConfiguration:(TrochilusConfigurationHandler)configurationHandler {
    
    NSMutableDictionary * keys = [NSMutableDictionary dictionary];
    
    if (configurationHandler) {
        
        for (NSNumber * platformType in thirdPlatforms) {
            configurationHandler([platformType integerValue],keys);
        }
        
    }
    
}

- (void)dealloc {
    
}

#pragma mark- 分享
/**
 分享
 
 @param platformType 分享平台 例如QQ好友 QZone 微信好友 微信朋友圈 微博等
 @param parameters 分享平台参数
 @param stateChangedHandler 分享状态变更回调处理
 */
+ (void)shareWithPlatformType:(TrochilusPlatformType)platformType parameters:(NSMutableDictionary *)parameters onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    NSString *platformTypeName = [NSString stringWithFormat:@"PlatformType_%zi",platformType];
    NSString *platformName = [[NSBundle bundleForClass:[self class]] localizedStringForKey:platformTypeName value:platformTypeName table:@"Trochilus_Localizable"];
    
    Class platformClass = NSClassFromString([NSString stringWithFormat:@"Trochilus%@Platform",platformName]);
    
    SEL selMethod = NSSelectorFromString([NSString stringWithFormat:@"shareWith%@Platform:onStateChanged:",platformName]);
    IMP imp = [platformClass methodForSelector:selMethod];
    NSString *(*func)(id,SEL,NSMutableDictionary*,TrochilusStateChangedHandler) = (void *)imp;
    
    NSString * shareUrl = @"";
    
    if ([platformClass respondsToSelector:selMethod]) {
        shareUrl = platformClass? func(platformClass,selMethod,parameters,stateChangedHandler): @"";
    }
    [Trochilus sendToURL:shareUrl];
}

#pragma mark- 登录、授权
/**
 登录 授权
 
 @param platformType 登录授权平台 只能选TrochilusPlatformTypeQQ（QQ平台）、TrochilusPlatformTypeWechat(微信平台)、TrochilusPlatformTypeSinaWeibo（新浪微博）
 @param settings 授权设置,目前只接受TAuthSettingKeyScopes属性设置，如新浪微博关注官方微博：@{TAuthSettingKeyScopes : @[@"follow_app_official_microblog"]}，类似“follow_app_official_microblog”这些字段是各个社交平台提供的。
 @param stateChangedHandler 授权状态变更回调处理
 */
+ (void)authorizeWithPlatformType:(TrochilusPlatformType)platformType
                         settings:(NSDictionary *)settings
                   onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler {
    
    NSString *platformTypeName = [NSString stringWithFormat:@"PlatformType_%zi",platformType];
    NSString *platformName = [[NSBundle bundleForClass:[self class]] localizedStringForKey:platformTypeName value:platformTypeName table:@"Trochilus_Localizable"];
    
    Class platformClass = NSClassFromString([NSString stringWithFormat:@"Trochilus%@Platform",platformName]);
    
    SEL selMethod = NSSelectorFromString([NSString stringWithFormat:@"authorizeWith%@PlatformSettings:onStateChanged:",platformName]);
    IMP imp = [platformClass methodForSelector:selMethod];
    NSString *(*func)(id,SEL,NSDictionary *,TrochilusAuthorizeStateChangedHandler) = (void *)imp;
    NSString * authorizeUrl = @"";
    if ([platformClass respondsToSelector:selMethod]) {
        authorizeUrl = platformClass? func(platformClass,selMethod,settings,stateChangedHandler): nil;
    }
    
    [Trochilus sendToURL:authorizeUrl];
}

#pragma mark- 支付
/**
 微信支付
 
 @param parameters 支付参数 支持拼接好的字符串 和 未拼接的字典
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (void)wechatPayWithParameters:(id)parameters onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    NSString * wechatPayInfo;
    
    //    if ([parameters isKindOfClass:[NSString class]]) {
    //        wechatPayInfo = [TWeChatPlatform payToWechatOrderString:parameters
    //                                                 onStateChanged:stateChangedHandler];
    //    }
    //    else if ([parameters isKindOfClass:[NSDictionary class]]) {
    wechatPayInfo = [TrochilusWeChatPlatform payToWechatParameters:parameters
                                            onStateChanged:stateChangedHandler];
    //    }
    
    [Trochilus sendToURL:wechatPayInfo];
}

/**
 支付宝支付
 
 @param urlScheme 应用注册scheme,在Info.plist定义URL types 必须一致 否则将无法返回app
 @param orderString 支付参数 服务器拼接好
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (void)aLiPayWithUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    NSString * aliPayInfo = [TrochilusAliPayPlatform payToAliPayUrlScheme:urlScheme
                                                      orderString:orderString
                                                   onStateChanged:stateChangedHandler];
    
    [Trochilus sendToURL:aliPayInfo];
}

#pragma 支付宝打赏
/**
 支付宝打赏
 
 @param url 二维码解析出来的地址
 */
+ (void)aliTipWithQRCodeUrl:(NSString *)url {
    
    NSString * awardInfo = [TrochilusAliPayPlatform awardToAliPayQRCodeUrl:url];
    
    [Trochilus sendToURL:awardInfo];
}

#pragma mark openURL
+ (void)sendToURL:(NSString *)url {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    
}

#pragma mark- 第三方平台回调
+ (BOOL)handleURL:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"QQ"] || [url.scheme hasPrefix:@"tencent"]) {
        //QQ 为分享 tencent为QQ登录
        return [TrochilusQQPlatform handleUrlWithQQ:url];
    }
    else if ([url.scheme hasPrefix:@"wx"]) {
        return [TrochilusWeChatPlatform handleUrlWithWeChat:url];
    }
    else if ([url.scheme hasPrefix:@"wb"]) {
        return [TrochilusSinaWeiBoPlatform handleUrlWithSinaWeiBo:url];
    }
    else if ([url.absoluteString rangeOfString:@"//safepay/"].location != NSNotFound) {
        return [TrochilusAliPayPlatform handleUrlWithAliPay:url];
    }
    return NO;
}

#pragma mark- 检测平台是否安装
+ (BOOL)isInstalledPlatformType:(TrochilusPlatformType)platformType {
    
    NSString *platformTypeName = [NSString stringWithFormat:@"PlatformType_%zi",platformType];
    NSString *platformName = [[NSBundle bundleForClass:[self class]] localizedStringForKey:platformTypeName value:platformTypeName table:@"Trochilus_Localizable"];
    
    Class platformClass = NSClassFromString([NSString stringWithFormat:@"Trochilus%@Platform",platformName]);
    
    SEL selMethod = NSSelectorFromString([NSString stringWithFormat:@"is%@Installed",platformName]);
    IMP imp = [platformClass methodForSelector:selMethod];
    BOOL (*func)(id,SEL) = (void *)imp;
    BOOL isInstalled = platformClass? func(platformClass,selMethod): NO;
    return isInstalled;
}

@end



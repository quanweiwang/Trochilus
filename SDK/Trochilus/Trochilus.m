//
//  Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "Trochilus.h"
#import "TrochilusSysDefine.h"

@interface Trochilus ()

@end

@implementation Trochilus

static NSMutableSet * platformSet;

/**
 *  初始化Trochilus应用
 *
 *  @param thirdPlatforms          使用的分享平台集合，如:@[@(TrochilusPlatformTypeSinaWeibo), @(TrochilusPlatformTypeTencentWeibo)];
 *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
 */
+ (void)registerPlatforms:(NSArray *)thirdPlatforms
          onConfiguration:(TrochilusConfigurationHandler)configurationHandler {
    
    if (configurationHandler) {
        
        NSMutableDictionary * keys = [NSMutableDictionary dictionary];
        
        if (!platformSet) {
            platformSet = [NSMutableSet set];
        }
        
        for (NSNumber * platformType in thirdPlatforms) {
            configurationHandler([platformType integerValue],keys);
        }
        
        for (NSString * key in keys.allKeys) {
            
            [platformSet addObject:key];
            
            NSDictionary * dic = keys[key];
            
            Class class = NSClassFromString(PLATFORMNAME(key));
            
            SEL selector = NSSelectorFromString(@"registerWithParameters:");
            
            [self safePerformSelector:selector
                                class:class
                         platformType:TrochilusPlatformTypeUnknown, dic, nil];
            
        }
    }
    
}

#pragma mark- 分享
/**
 分享
 
 @param platformType 分享平台 例如QQ好友 QZone 微信好友 微信朋友圈 微博等
 @param parameters 分享平台参数
 @param stateChangedHandler 分享状态变更回调处理
 */
+ (void)shareWithPlatformType:(TrochilusPlatformType)platformType
                   parameters:(NSMutableDictionary *)parameters
               onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    NSString *platformTypeName = [NSString stringWithFormat:@"PlatformType_%zi",platformType];
    NSString *platformName = [[NSBundle bundleForClass:[self class]] localizedStringForKey:platformTypeName value:platformTypeName table:@"Trochilus_Localizable"];
    
    Class platformClass = NSClassFromString(PLATFORMNAME(platformName));
    
    SEL selMethod = NSSelectorFromString(@"shareWithPlatformType:parameter:onStateChanged:");
    
    NSString * shareUrl = [self safePerformSelector:selMethod class:platformClass platformType:platformType,parameters,stateChangedHandler, nil];
    
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
    
    SEL selMethod = NSSelectorFromString(@"authorizeWithPlatformSettings:onStateChanged:");
    
    NSString * authorizeUrl = [self safePerformSelector:selMethod class:platformClass platformType:TrochilusPlatformTypeUnknown,settings == nil? @"" : settings,stateChangedHandler, nil];
    
    [Trochilus sendToURL:authorizeUrl];
}

#pragma mark- 支付
/**
 微信支付
 
 @param parameters 支付参数 支持拼接好的字符串 和 未拼接的字典
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (void)wechatPayWithParameters:(id)parameters onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    Class platformClass = NSClassFromString(@"TrochilusWeChatPlatform");
    SEL selMethod = NSSelectorFromString(@"payToWechatParameters:onStateChanged:");
    
    NSString * wechatPayInfo = [self safePerformSelector:selMethod class:platformClass platformType:TrochilusPlatformTypeUnknown,parameters,stateChangedHandler, nil];
    
    [Trochilus sendToURL:wechatPayInfo];
}

/**
 支付宝支付
 
 @param urlScheme 应用注册scheme,在Info.plist定义URL types 必须一致 否则将无法返回app
 @param orderString 支付参数 服务器拼接好
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (void)aliPayWithUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    Class platformClass = NSClassFromString(@"TrochilusAliPayPlatform");
    SEL selMethod = NSSelectorFromString(@"payWithUrlScheme:orderString:onStateChanged:");
    
    NSString * aliPayInfo = [self safePerformSelector:selMethod class:platformClass platformType:TrochilusPlatformTypeUnknown,urlScheme,orderString,stateChangedHandler, nil];
    
    [Trochilus sendToURL:aliPayInfo];
}

#pragma 支付宝打赏
/**
 支付宝打赏
 
 @param url 二维码解析出来的地址
 */
+ (void)aliTipWithUrl:(NSString *)url {
    
    Class platformClass = NSClassFromString(@"TrochilusAliPayPlatform");
    SEL selMethod = NSSelectorFromString(@"tipWithUrl:");
    
    NSString * awardInfo = [self safePerformSelector:selMethod class:platformClass platformType:TrochilusPlatformTypeUnknown,url, nil];;
    
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
    
    for (NSString * key in platformSet) {
        
        Class platformClass = NSClassFromString(PLATFORMNAME(key));
        SEL selMethod = NSSelectorFromString([NSString stringWithFormat:@"handleUrlWith%@:",key]);
        
        NSNumber * returnValue = [self safePerformSelector:selMethod class:platformClass platformType:TrochilusPlatformTypeUnknown,url, nil];
        
        if ([returnValue boolValue]) {
            return [returnValue boolValue];
        }

    }
    
    return NO;
}

#pragma mark- 检测平台是否安装
+ (BOOL)isInstalledPlatformType:(TrochilusPlatformType)platformType {
    
    NSString *platformTypeName = [NSString stringWithFormat:@"PlatformType_%zi",platformType];
    NSString *platformName = [[NSBundle bundleForClass:[self class]] localizedStringForKey:platformTypeName value:platformTypeName table:@"Trochilus_Localizable"];
    
    Class platformClass = NSClassFromString([NSString stringWithFormat:@"Trochilus%@Platform",platformName]);
    
    SEL selMethod = NSSelectorFromString([NSString stringWithFormat:@"is%@Installed",platformName]);
    
    NSNumber * isInstalled = [self safePerformSelector:selMethod class:platformClass platformType:TrochilusPlatformTypeUnknown, nil];
    
    return [isInstalled boolValue];
}

#pragma mark 万能跳转
+ (id)safePerformSelector:(SEL)action class:(Class)target platformType:(TrochilusPlatformType)platformType, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMethodSignature * methodSignature = [target methodSignatureForSelector:action];
    if(methodSignature == nil) {
        return nil;
    }
    
    const char* retType = [methodSignature methodReturnType];
    
    NSInteger i = 2;
    
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setSelector:action];
    [invocation setTarget:target];
    
    //- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx
    //参数顺序要与实际方法参数顺序一致
    
    if (platformType != TrochilusPlatformTypeUnknown) {
        [invocation setArgument:&platformType atIndex:i];
        i = i + 1;
    }
    
    // 定义一个指向个数可变的参数列表指针；
    va_list args;
    // 用于存放取出的参数
    id arg;
    // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
    //va_arg type绝对不能为以下类型：
    //——char、signed char、unsigned char
    //——short、unsigned short
    //——signed short、short int、signed short int、unsigned short int
    //——float
    va_start(args, platformType);
    // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
    while ((arg = va_arg(args, id))) {
        [invocation setArgument:&arg atIndex:i];
        i = i + 1;
    }
    
    //防止参数被释放
//    [invocation retainArguments];
    [invocation invoke];
    
    // 清空参数列表，并置参数指针args无效
    va_end(args);
    
    if (strcmp(retType, @encode(void)) == 0) {
        return nil;
    }
    else if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    else if (strcmp(retType, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    else if (strcmp(retType, @encode(CGFloat)) == 0) {
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    else if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    else {
        //防止被释放
        __autoreleasing id result;
        [invocation getReturnValue:&result];
        return result;
    }
}
@end



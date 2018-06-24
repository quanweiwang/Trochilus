//
//  TrochilusAliPayPlatform.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrochilusTypeDefine.h"

@interface TrochilusAliPayPlatform : NSObject

+ (instancetype)sharedInstance;

/**
 判断是否安装了支付宝
 
 @return YES or NO
 */
+ (BOOL)isAliPayInstalled;


/**
 支付宝支付
 @param urlScheme 应用注册scheme,在Info.plist定义URL types
 @param orderString 服务器返回构造好的订单格式
 @param stateChangedHandler 支付状态变更回调
 @return 支付字符串
 */
+ (NSString *)payToAliPayUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler;


/**
 打赏
 
 @param url 二维码解析出来的地址
 @return 拼装好的url
 */
+ (NSString *)awardToAliPayQRCodeUrl:(NSString *)url ;

/**
 支付宝客户端回调
 
 @param url 回调url
 @return YES or NO
 */
+ (BOOL)handleUrlWithAliPay:(NSURL *)url;

/**
 检查支付状态
 */
- (void)checkPayState;

@end


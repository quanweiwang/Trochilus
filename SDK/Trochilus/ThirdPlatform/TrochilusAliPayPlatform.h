//
//  TrochilusAliPayPlatform.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
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
 @param urlScheme 应用注册scheme,在Info.plist定义URL types (必填)
 @param orderString 服务器返回构造好的订单格式 (必填)
 @param stateChangedHandler 支付状态变更回调
 @return 发给支付宝的字符串
 */
+ (NSString *)payWithUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler;

/**
 打赏
 
 @param url 二维码解析出来的地址
 @return 拼装好的url
 */
+ (NSString *)tipWithUrl:(NSString *)url;

/**
 支付宝客户端回调
 
 @param url 回调url
 @return YES or NO
 */
+ (BOOL)handleUrlWithAliPay:(NSURL *)url;


@end


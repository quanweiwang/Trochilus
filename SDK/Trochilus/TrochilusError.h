//
//  TrochilusError.h
//  Trochilus
//
//  Created by 王权伟 on 2018/4/19.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrochilusTypeDefine.h"

typedef enum : NSUInteger {
    TrochilusErrorCodeSucceed = 0,                      //成功
    TrochilusErrorCodeFail = -1,                        //失败
    TrochilusErrorCodeUnknown = -999,                   //未知错误
    
    TrochilusErrorCodeQQAppIdNotFound = -10101,         //QQ app id 未填写
    TrochilusErrorCodeQQAppKeyNotFound = -10102,        //QQ app key 未填写
    TrochilusErrorCodeQQUninstalled = -10109,           //QQ 未安装
    
    TrochilusErrorCodeWechatAppIdNotFound = -10201,     //微信 app id 未填写
    TrochilusErrorCodeWechatAppSecretNotFound = -10202, //微信 app secret 未填写
    TrochilusErrorCodeWechatUninstalled = -10209,       //微信 未安装
    
    TrochilusErrorCodeWeiboAppKeyNotFound = -10301,     //微博 app key 未填写
    TrochilusErrorCodeWeiboAppSecretNotFound = -10302,  //微博 app secret 未填写
    TrochilusErrorCodeWeiboRedirectUri = -10303,        //微博 redirect uri 未填写
    TrochilusErrorCodeWeiboUninstalled = -10309,        //微博 未安装
    
    TrochilusErrorCodeAliPayUninstalled = -10409,       //支付宝未安装
    
    TrochilusErrorCodeQQShareFail = -20101,             //QQ分享失败
    TrochilusErrorCodeQQAuthorizeFail = -20102,         //QQ授权失败
    
    TrochilusErrorCodeWechatShareFail = -20201,         //微信分享失败
    TrochilusErrorCodeWechatAuthorizeFail = -20202,     //微信授权失败
    TrochilusErrorCodeWechatPayFail = -20203,           //微信支付失败
    
    TrochilusErrorCodeWeiboShareFail = -20301,          //微博分享失败
    TrochilusErrorCodeWeiboAuthorizeFail = -20302,      //微博授权失败
    
    TrochilusErrorCodeAliPayFail = -20403,              //支付宝支付失败
    
    
} TrochilusErrorCode;

@interface TrochilusError : NSObject

+ (NSError *)errorWithCode:(TrochilusErrorCode)errorCode;
+ (NSError *)errorWithCode:(TrochilusErrorCode)errorCode userInfo:(NSDictionary *)userInfo;
@end

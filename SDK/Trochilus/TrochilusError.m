//
//  TrochilusError.m
//  Trochilus
//
//  Created by 王权伟 on 2018/4/19.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "TrochilusError.h"

@implementation TrochilusError

+ (NSError *)errorWithCode:(TrochilusErrorCode)errorCode {
    
    NSDictionary * userInfo;
    if (errorCode == TrochilusErrorCodeQQAppIdNotFound) {
        
        userInfo = @{NSLocalizedDescriptionKey : @"找不到QQ平台的AppId",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写QQ平台的AppId"
                     };
        
        
    }
    else if (errorCode == TrochilusErrorCodeQQAppKeyNotFound) {
        
        userInfo = @{NSLocalizedDescriptionKey : @"找不到QQ平台的AppKey",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写QQ平台的AppKey"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWechatAppIdNotFound) {
        
        userInfo = @{NSLocalizedDescriptionKey : @"找不到微信平台的AppId",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写微信平台的AppId"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWechatAppSecretNotFound) {
        
        userInfo = @{NSLocalizedDescriptionKey : @"找不到微信平台的AppSecret",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写微信平台的AppSecret"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWeiboAppKeyNotFound) {
        
        userInfo = @{NSLocalizedDescriptionKey : @"找不到微博平台的AppKey",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写微博平台的AppKey"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWeiboAppSecretNotFound) {
        
        userInfo = @{NSLocalizedDescriptionKey : @"找不到微博平台的AppSecret",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写微博平台的AppSecret"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWeiboRedirectUri) {
        userInfo = @{NSLocalizedDescriptionKey : @"找不到微博平台的RedirectUri",
                     NSLocalizedRecoverySuggestionErrorKey : @"请在Trochilus初始化时填写微博平台的RedirectUri"
                     };
    }
    else if (errorCode == TrochilusErrorCodeQQUninstalled) {
        userInfo = @{NSLocalizedDescriptionKey : @"分享平台［QQ］尚未安装QQ或者QQ空间客户端!无法进行分享!",
                     NSLocalizedRecoverySuggestionErrorKey : @"请安装QQ或者QQ空间客户端"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWechatUninstalled) {
        userInfo = @{NSLocalizedDescriptionKey : @"分享平台［微信］尚未安装微信客户端!无法进行分享!",
                     NSLocalizedRecoverySuggestionErrorKey : @"请安装微信客户端"
                     };
    }
    else if (errorCode == TrochilusErrorCodeWeiboUninstalled) {
        userInfo = @{NSLocalizedDescriptionKey : @"分享平台［微博］尚未安装微博客户端!无法进行分享!",
                     NSLocalizedRecoverySuggestionErrorKey : @"请安装微博客户端"
                     };
    }
    else if (errorCode == TrochilusErrorCodeAliPayUninstalled) {
        userInfo = @{NSLocalizedDescriptionKey : @"支付平台［支付宝］尚未安装支付宝客户端!无法进行支付!",
                     NSLocalizedRecoverySuggestionErrorKey : @"请安装支付宝客户端"
                     };
    }
    else if (errorCode == TrochilusErrorCodeAliPayUrlSchemeNotFound) {
        userInfo = @{NSLocalizedDescriptionKey : @"支付平台［支付宝］UrlScheme未填写!无法进行支付!",
                     NSLocalizedRecoverySuggestionErrorKey : @"请填写UrlScheme"
                     };
    }
    else if (errorCode == TrochilusErrorCodeAliPayOrderStringNotFound) {
        userInfo = @{NSLocalizedDescriptionKey : @"支付平台［支付宝］OrderString未填写!无法进行支付!",
                     NSLocalizedRecoverySuggestionErrorKey : @"请填写OrderString"
                     };
    }
    else {
        userInfo = @{NSLocalizedDescriptionKey : @"未知错误",
                     NSLocalizedRecoverySuggestionErrorKey : @"未知错误"
                     };
    }
    
    NSError * error = [NSError errorWithDomain:@"TrochilusErrorDomain" code:errorCode userInfo:userInfo];
    
    return error;
}

+ (NSError *)errorWithCode:(TrochilusErrorCode)errorCode userInfo:(NSDictionary *)userInfo {
    
    NSError * error = [NSError errorWithDomain:@"TrochilusErrorDomain" code:errorCode userInfo:userInfo];
    
    return error;
}

@end

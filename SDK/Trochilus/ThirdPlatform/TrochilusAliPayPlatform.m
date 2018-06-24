//
//  TrochilusAliPayPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusAliPayPlatform.h"
#import <UIKit/UIKit.h>
#import "NSString+Trochilus.h"
#import "TrochilusError.h"

@interface TrochilusAliPayPlatform ()

@property (copy, nonatomic) TrochilusPayStateChangedHandler payStateChangedHandler;//支付

@end

@implementation TrochilusAliPayPlatform

#pragma mark- 单例模式
static TrochilusAliPayPlatform * _instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPayState) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark- 判断是否安装客户端
+ (BOOL)isAliPayInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
}

#pragma mark- 支付宝支付
+ (NSString *)payToAliPayUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TrochilusAliPayPlatform sharedInstance].payStateChangedHandler = stateChangedHandler;
    }
    
    //alipay://alipayclient/?{
    //    "fromAppUrlScheme" : "alipayMobike",
    //    "requestType" : "SafePay",
    //    "dataString" : "payment_type=\"1\"&out_trade_no=\"MBK059114993934678417524\"&partner=\"2088811798787949\"&subject=\"mobike\"&service=\"mobile.securitypay.pay\"&_input_charset=\"UTF-8\"&total_fee=\"5.0\"&body=\"mobike_money\"&notify_url=\"https:\/\/apiv2.mobike.com\/mobike-api\/pay\/receivepayinfo.do\"&seller_id=\"developer@mobike.com\"&sign=\"FY2n7sYTXMttZzVSOp%2B%2BMteI9YsTWo94ACpwCT8ErmKYghSuO5bMMaJ%2B5HhzW5FXJ9BPBSuiXdIdQ9C%2BmX3dn%2BZspbzfaiS8mOslv8%2BRbxtk4omEYTIyXJMmGf8yqN%2FHnsyYmdHGdq8HXpCqByUiGyZ8eMBiiXmEcDXwWlRnth0%3D\"&sign_type=\"RSA\"&bizcontext=\"{\"appkey\":\"2014052600006128\"}\""
    //}
    
    if ([TrochilusAliPayPlatform isAliPayInstalled]) {
        NSDictionary * aliPayDic = @{@"fromAppUrlScheme" : urlScheme,
                                     @"requestType" : @"SafePay",
                                     @"dataString" : orderString};
        NSError * error;
        NSData * aliPayJsonData = [NSJSONSerialization dataWithJSONObject:aliPayDic
                                                                  options:NSJSONWritingPrettyPrinted
                                                                    error:&error];
        NSString * aliPayJsonString = [[NSString alloc] initWithData:aliPayJsonData encoding:NSUTF8StringEncoding];
        NSString * aliPayInfo = [NSString stringWithFormat:@"alipay://alipayclient/?%@",aliPayJsonString];
        NSString * aliPayUrl = [aliPayInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return aliPayUrl;
        
    }
    else {
        if (stateChangedHandler) {
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeAliPayUninstalled];
            stateChangedHandler(TrochilusResponseStateFail,nil,err);
            
        }
    }
    return nil;
}

#pragma 支付宝打赏
+ (NSString *)awardToAliPayQRCodeUrl:(NSString *)url {
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString * qrcodeUrl = [[NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=%@?_s=web-other&_t=%f",url,timeInterval] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return qrcodeUrl;
    
}

#pragma mark- 回调
+ (BOOL)handleUrlWithAliPay:(NSURL *)url {
    
    if ([url.absoluteString rangeOfString:@"//safepay/"].location != NSNotFound) {
        NSError *err;
        NSDictionary *ret=[NSJSONSerialization JSONObjectWithData:[[NSString trochilus_urlDecode:url.query]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
        if (err||ret[@"memo"]==[NSNull null]||[ret[@"memo"][@"ResultStatus"] intValue]!=9000) {
            //支付失败
            NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeAliPayFail userInfo:ret];
            
            if ([TrochilusAliPayPlatform sharedInstance].payStateChangedHandler) {
                [TrochilusAliPayPlatform sharedInstance].payStateChangedHandler(TrochilusResponseStateFail,nil,error);
            }
        }
        else if (err||ret[@"memo"]==[NSNull null]||[ret[@"memo"][@"ResultStatus"] intValue] == 6001) {
            //用户取消
            if ([TrochilusAliPayPlatform sharedInstance].payStateChangedHandler) {
                [TrochilusAliPayPlatform sharedInstance].payStateChangedHandler(TrochilusResponseStateCancel,nil,nil);
            }
        }
        else{
            //支付成功
            if ([TrochilusAliPayPlatform sharedInstance].payStateChangedHandler) {
                [TrochilusAliPayPlatform sharedInstance].payStateChangedHandler(TrochilusResponseStateSuccess,nil,nil);
            }
        }
        
        [TrochilusAliPayPlatform sharedInstance].payStateChangedHandler = nil;
        
        return YES;
    }
    
    return NO;
}

#pragma mark- 支付结果查询通知(iOS9后出现左上角返回APP功能，这样无法收到支付平台的回调 需要去自己服务器查询)
- (void)checkPayState {
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //延迟0.5s执行
        if (self.payStateChangedHandler) {
            //调用自己的服务器去查询支付结果
            self.payStateChangedHandler(TrochilusResponseStatePayWait, nil, nil);
            self.payStateChangedHandler = nil;
        }
    });
}

@end


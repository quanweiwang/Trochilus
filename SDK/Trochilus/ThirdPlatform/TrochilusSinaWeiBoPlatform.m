//
//  TrochilusSinaWeiBoPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusSinaWeiBoPlatform.h"
#import <UIKit/UIKit.h>
//#import <AssetsLibrary/AssetsLibrary.h>

#import "UIImage+Trochilus.h"
#import "NSDate+Trochilus.h"
#import "NSMutableDictionary+TrochilusShare.h"

#import "TrochilusUser.h"
//#import "TWebViewVC.h"
#import "TrochilusError.h"
#import "TrochilusSysDefine.h"

@interface TrochilusSinaWeiBoPlatform()

@property (copy, nonatomic)TrochilusStateChangedHandler stateChangedHandler;
@property (copy, nonatomic)TrochilusAuthorizeStateChangedHandler authorizeStateChangedHandler;

@property (nonatomic, strong) NSString * appKey;
@property (nonatomic, strong) NSString * appSecret;
@property (nonatomic, strong) NSString * redirectUri;

@end

@implementation TrochilusSinaWeiBoPlatform

#pragma mark- 单例模式
static TrochilusSinaWeiBoPlatform * _instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

+ (void)registerWithParameters:(NSDictionary *)parameters {
    
    [TrochilusSinaWeiBoPlatform sharedInstance].appKey = parameters[@"appKey"];
    [TrochilusSinaWeiBoPlatform sharedInstance].appSecret = parameters[@"appSecret"];
    [TrochilusSinaWeiBoPlatform sharedInstance].redirectUri = parameters[@"redirectUri"];
}

#pragma mark- 判断是否安装了客户端
/**
 判断是否安装了微博
 
 @return YES or NO
 */
+ (BOOL)isSinaWeiBoInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibosdk://request"]];
}

#pragma mark- 分享
+ (NSString *)shareWithPlatformType:(TrochilusPlatformType)platformType
                      parameter:(NSMutableDictionary *)parameters
                 onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusSinaWeiBoPlatform sharedInstance].appKey length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAppKeyNotFound];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusSinaWeiBoPlatform sharedInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TrochilusSinaWeiBoPlatform isSinaWeiBoInstalled]) {
        
        NSString * uuid = [[NSUUID UUID] UUIDString];
        
        NSDictionary * message = nil;
        TrochilusContentType contentType = [parameters[@"contentType"] integerValue];
        
        if (contentType == TrochilusContentTypeText) {
            //文字分享
            message = @{@"__class" : @"WBMessageObject",
                        @"text" : parameters[@"text"]};
        }
        else if (contentType == TrochilusContentTypeImage) {
            //图片 分享 貌似只能分享一张图片
            
            NSData * imageData = parameters[@"image"][0];
            
            NSDictionary * imageDataDic = @{@"imageData" : imageData};
            message = @{@"__class" : @"WBMessageObject",
                        @"text" : parameters[@"text"],
                        @"imageObject" : imageDataDic};
        }
        else if (contentType == TrochilusContentTypeWebPage) {
            //链接分享
            
            //时间戳
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
            NSString * timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
            //缩略图
            
            NSData * thumbnailData = parameters[@"thumbImage"][0];
            
            NSDictionary * mediaObject = @{@"__class" : @"WBWebpageObject",
                                           @"description" : parameters[@"text"],
                                           @"objectID" : timeIntervalStr,
                                           @"thumbnailData" : thumbnailData,
                                           @"title" : parameters[@"title"],
                                           @"webpageUrl" : parameters[@"url"]
                                           };
            message = @{@"__class" : @"WBMessageObject",
                        @"text" : parameters[@"text"],
                        @"mediaObject" : mediaObject};
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        NSDictionary * transferObject = @{@"__class" : @"WBSendMessageToWeiboRequest",
                                          @"requestID" : uuid,
                                          @"message" : message
                                          };
        NSData * transferObjectData = [NSKeyedArchiver archivedDataWithRootObject:transferObject];
        NSDictionary * transferObjectDic = @{@"transferObject" : transferObjectData};
        
        //获取当前时间 精确到毫秒
        NSString * currentDate = @"";
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        currentDate = [formatter stringFromDate:[NSDate date]];
        
        NSDictionary * userInfo = @{@"startTime" : currentDate};
        NSData * userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        NSDictionary * userInfoDic = @{@"userInfo" : userInfoData};
        
        //这里还有个参数aid 不知道干嘛的
        //aid = "01AoDLw5e-GEgq4jjxUWmuYV2Cak7aCCqMZJzWVa5OCQ_MXPc."
        NSDictionary * app = @{@"appKey" : [TrochilusSinaWeiBoPlatform sharedInstance].appKey,
                               @"bundleID" : kCFBundleIdentifier,
                               @"aid" : @"01AoDLw5e-GEgq4jjxUWmuYV2Cak7aCCqMZJzWVa5OCQ_MXPc."};
        NSData * appData = [NSKeyedArchiver archivedDataWithRootObject:app];
        NSDictionary * appDic = @{@"app" : appData};
        
        NSData * sdkVersionData = [@"003203000" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * sdkVersion = @{@"sdkVersion" : sdkVersionData};
        
        NSArray * sinaWeiBoArray = @[transferObjectDic,userInfoDic,appDic,sdkVersion];
        
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setItems:sinaWeiBoArray];
        
        return [NSMutableString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003203000&luicode=10000360&lfid=%@",uuid,kCFBundleIdentifier];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboUninstalled];
            [TrochilusSinaWeiBoPlatform shareResponseWithState:TrochilusResponseStateFail error:err];
        }
        
    }
    return nil;
}

#pragma mark- 授权
//授权
+ (NSMutableString *)authorizeWithSinaWeiBoPlatformSettings:(NSDictionary *)settings
                                             onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusSinaWeiBoPlatform sharedInstance].appKey length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAppKeyNotFound];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    else if ([[TrochilusSinaWeiBoPlatform sharedInstance].redirectUri length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboRedirectUri];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler = stateChangedHandler;
    }
    
    NSString * uuid = [[NSUUID UUID] UUIDString];
    
    NSString * authorizeType = @"SSO";
    
//    if ([[TrochilusPlatformKeys sharedInstance].weiboAuthType isEqualToString:@"TAuthTypeBoth"]) {
//
//        if ([TrochilusSinaWeiBoPlatform isSinaWeiBoInstalled]) {
//            //安装了客户端
//            authorizeType = @"SSO";
//        }
//        else {
//            //没安装客户端
//            authorizeType = @"WEB";
//        }
//
//    }
//    else if ([[TrochilusPlatformKeys sharedInstance].weiboAuthType isEqualToString:@"TAuthTypeSSO"]) {
//        authorizeType = @"SSO";
//    }
//    else {
//        authorizeType = @"WEB";
//    }
    
    if ([authorizeType isEqualToString:@"SSO"]) {
        
        NSDictionary * transferObject = @{@"__class" : @"WBAuthorizeRequest",
                                          @"redirectURI" : [TrochilusSinaWeiBoPlatform sharedInstance].redirectUri,
                                          @"requestID" : uuid
                                          };
        NSData * transferObjectData = [NSKeyedArchiver archivedDataWithRootObject:transferObject];
        NSDictionary * transferObjectDic = @{@"transferObject" : transferObjectData};
        
        //获取当前时间 精确到毫秒
        NSString * currentDate = @"";
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        currentDate = [formatter stringFromDate:[NSDate date]];
        
        NSDictionary * userInfo = @{@"startTime" : currentDate};
        NSData * userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        NSDictionary * userInfoDic = @{@"userInfo" : userInfoData};
        
        NSDictionary * app = @{@"appKey" : [TrochilusSinaWeiBoPlatform sharedInstance].appKey,
                               @"bundleID" : kCFBundleIdentifier};
        NSData * appData = [NSKeyedArchiver archivedDataWithRootObject:app];
        NSDictionary * appDic = @{@"app" : appData};
        
        NSData * sdkVersionData = [@"003203000" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * sdkVersion = @{@"sdkVersion" : sdkVersionData};
        
        NSArray * sinaWeiBoArray = @[transferObjectDic,userInfoDic,appDic,sdkVersion];
        
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setItems:sinaWeiBoArray];
        
        //    weibosdk://request?id=524BBFB4-7DC5-4E2B-891C-73754D39868C&sdkversion=003203000&luicode=10000360&lfid=com.wangquanwei.ShareSDKDemo
        
        return [NSMutableString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003203000&luicode=10000360&lfid=%@",uuid,kCFBundleIdentifier];
    }
//    else if ([authorizeType isEqualToString:@"WEB"]){
//        //网页授权
////        TWebViewVC * webViewVC = [TWebViewVC sharedInstance];
////        //        https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=get_simple_userinfo,get_user_info,add_topic,upload_pic,add_share&status_version=10&sdkv=3.2.1&status_machine=iPhone8,2&status_os=10.3.2&switch=1&redirect_uri=auth://www.qq.com&client_id=100371282
////
////        //时间戳
////        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
////        NSString * timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
////
////        NSString * url = [NSString stringWithFormat:@"https://open.weibo.cn/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@&display=mobile&state=%@",[TrochilusPlatformKeys sharedInstance].weiboAppKey,[TrochilusPlatformKeys sharedInstance].weiboRedirectUri,timeIntervalStr];
////        webViewVC.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////        webViewVC.title = @"Sina Web Login";
////        webViewVC.redirectUri = [TrochilusPlatformKeys sharedInstance].weiboRedirectUri;
////        webViewVC.delegate = [TrochilusSinaWeiBoPlatform sharedInstance];
////
////        UIViewController * vc = [[UIApplication sharedApplication] currentViewController];
////        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webViewVC];
////        [vc presentViewController:nav animated:YES completion:nil];
//    }
    
    return nil;
    
}

//取消授权
+ (void)unAurhAct {
    //    NSData * data = [[TrochilusSinaWeiBoPlatform sharedInstance].user.access_token dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    //    request.URL = [NSURL URLWithString:@"https://api.weibo.com/oauth2/revokeoauth2"];
    //    request.HTTPMethod = @"Post";
    //    request.timeoutInterval = 20.5f;
    //    request.HTTPBody = data;
    //
    //    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //
    //        if (error == nil) {
    //            if (json[@"result"]) {
    //
    //                if ([json[@"result"] boolValue] == YES) {
    //                    //取消授权成功
    //                    if ([TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler) {
    //                        [TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler(TrochilusResponseStateCancel, nil, nil);
    //                    }
    //
    //                }
    //                else {
    //                    if ([TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler) {
    //                        //取消授权失败
    //                        NSError *err=[NSError errorWithDomain:@"weibo_authorize_response" code:-3 userInfo:@{@"description" : @"取消授权失败"}];
    //                        [TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler(TrochilusResponseStateFail, nil, err);
    //                    }
    //
    //                }
    //
    //            }
    //        }
    //        else {
    //            if ([TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler) {
    //                //取消授权失败
    //                [TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler(TrochilusResponseStateFail, nil, error);
    //            }
    //
    //        }
    //
    //    }];
    //    [task resume];
    
}

//获取用户信息
+ (void)geTrochilusUserInfoToSinaWeiBo:(NSString *)userID accessToken:(NSString *)accessToken completion:(void (^ __nullable)(NSDictionary * userInfoDic ))completion {
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",userID,accessToken];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            //授权失败
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:error.userInfo];
            [TrochilusSinaWeiBoPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
            
        }
        else {
            
            //授权成功
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (completion) {
                completion(userInfo);
            }
            
        }
        
    }];
    [task resume];
}

////获取 token 网页授权时用到
//- (void)getAccessTokenWithCode:(NSString *)code {
//
//    //时间戳
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
//    NSString * timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
//
//    //参数实际上都是放在URL里以get形式传的 post内容为空即可。反正传什么服务器都不会去取
//    NSDictionary * dic = @{@"client_id" : self.appKey,
//                           @"code" : code,
//                           @"state" : timeIntervalStr,
//                           @"redirect_uri" : [self.redirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                           @"client_secret" : self.appSecret ,
//                           @"grant_type" : @"authorization_code"};
//    NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//
//    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=authorization_code&code=%@&redirect_uri=%@",self.appKey,self.appSecret,code,[self.redirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
//    request.HTTPMethod = @"Post";
//    request.timeoutInterval = 20.5f;
//    request.URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    request.HTTPBody = data;
//
//    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        if (error) {
//
//            //授权失败
//            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:error.userInfo];
//            [TrochilusSinaWeiBoPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
//
//        }
//        else {
//
//            //授权成功
//            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//
//
//            [TrochilusSinaWeiBoPlatform geTrochilusUserInfoToSinaWeiBo:userInfo[@"uid"]
//                                           accessToken:userInfo[@"access_token"]
//                                            completion:^(NSDictionary *userInfoDic) {
//
//
//
//            }];
//
//        }
//
//    }];
//    [task resume];
//}

#pragma mark- 回调
+ (BOOL)handleUrlWithSinaWeiBo:(NSURL *)url {
    
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    NSArray * sinaweiboArray = pasteboard.items;
    
    //这里的transferObjectDic是授权后微博返回的，数据跟我们发送的已经不一样了
    NSDictionary * transferObjectDic = sinaweiboArray[0];
    NSData * transferObjectData = transferObjectDic[@"transferObject"];
    NSDictionary * transferObject = [NSKeyedUnarchiver unarchiveObjectWithData:transferObjectData];
    
    if ([transferObject[@"__class"] isEqualToString:@"WBAuthorizeResponse"]) {
        //授权
        if ([transferObject[@"statusCode"] integerValue] == 0) {
            //授权成功
            //本地保存授权过期时间 如果取不到授权过期时间那么启动授权 新浪给的时间与本地时间差8小时 需要转换
            NSDate * localDate = [NSDate trochilusLocalDateWithGMTDate:transferObject[@"expirationDate"]];
            [[NSUserDefaults standardUserDefaults] setObject:localDate forKey:@"SinaWeiBo_expirationDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TrochilusUser * user = [[TrochilusUser alloc] init];
            user.accessToken = transferObject[@"accessToken"];
            user.refreshToken = transferObject[@"refreshToken"];
            user.uid = transferObject[@"userID"];
            user.unionId = transferObject[@"userID"];
            
            [self geTrochilusUserInfoToSinaWeiBo:user.uid
                             accessToken:user.accessToken
                              completion:^(NSDictionary *userInfoDic) {
                                  
                                  user.iconurl = userInfoDic[@"avatar_large"];
                                  user.name = userInfoDic[@"name"];
                                  user.unionGender = [userInfoDic[@"gender"] isEqualToString:@"m"] ? @"男" : @"女";
                                  user.gender = userInfoDic[@"gender"];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [TrochilusSinaWeiBoPlatform authorizeResponseWithState:TrochilusResponseStateSuccess userInfo:user error:nil];
                                  });
                                  
                              }];
        }
        else if ([transferObject[@"statusCode"] integerValue] == -1) {
            //用户取消授权
            [TrochilusSinaWeiBoPlatform authorizeResponseWithState:TrochilusResponseStateCancel userInfo:nil error:nil];
        }
        else {
            
            NSError *err= [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:transferObject];
            [TrochilusSinaWeiBoPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
        }
        
        return YES;
    }
    else if ([transferObject[@"__class"] isEqualToString:@"WBSendMessageToWeiboResponse"]) {
        //分享
        if ([transferObject[@"statusCode"] integerValue] == 0) {
            //分享成功
            [TrochilusSinaWeiBoPlatform shareResponseWithState:TrochilusResponseStateSuccess error:nil];
            
        }
        else if ([transferObject[@"statusCode"] integerValue] == -1) {
            //用户取消发送
            [TrochilusSinaWeiBoPlatform shareResponseWithState:TrochilusResponseStateCancel error:nil];
        }
        else if ([transferObject[@"statusCode"] integerValue] == -2 || [transferObject[@"statusCode"] integerValue] == -8) {
            //发送失败
            //还有种状态-8 分享失败 详情见response UserInfo 等遇到在补充
            NSError *err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboShareFail userInfo:transferObject];
            [TrochilusSinaWeiBoPlatform shareResponseWithState:TrochilusResponseStateFail error:err];
            
        }
        
        return YES;
    }
    
    return NO;
}

//#pragma mark- TWebViewDelegate
//- (void)authorizeToSinaWeiBoInfo:(NSDictionary *)info {
//
//    [self getAccessTokenWithCode:info[@"code"]];
//}
//
//- (void)authorizeCancel {
//
//    if (self.authorizeStateChangedHandler) {
//        self.authorizeStateChangedHandler(TrochilusResponseStateCancel, nil, nil);
//        self.authorizeStateChangedHandler = nil;
//    }
//
//}

#pragma mark- 状态回调
//分享
+ (void)shareResponseWithState:(TrochilusResponseState)responseState error:(NSError *)error {
    
    if ([TrochilusSinaWeiBoPlatform sharedInstance].stateChangedHandler) {
        [TrochilusSinaWeiBoPlatform sharedInstance].stateChangedHandler(responseState, nil, error);
    }
    
    [TrochilusSinaWeiBoPlatform sharedInstance].stateChangedHandler = nil;
}

//授权
+ (void)authorizeResponseWithState:(TrochilusResponseState)responseState userInfo:(TrochilusUser *)user error:(NSError *)error {
    
    if ([TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler) {
        [TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler(responseState, user, error);
    }
    
    [TrochilusSinaWeiBoPlatform sharedInstance].authorizeStateChangedHandler = nil;
}

@end


//
//  TrochilusQQPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusQQPlatform.h"
#import <UIKit/UIKit.h>

#import "NSMutableDictionary+TrochilusShare.h"
#import "NSMutableDictionary+Trochilus.h"
#import "NSString+Trochilus.h"
#import "UIPasteboard+Trochilus.h"
#import "UIImage+Trochilus.h"
//#import "TWebViewVC.h"

#import "TrochilusUser.h"
#import "TrochilusError.h"
#import "TrochilusSysDefine.h"

@interface TrochilusQQPlatform ()

@property(copy, nonatomic)TrochilusStateChangedHandler stateChangedHandler;
@property(copy, nonatomic)TrochilusAuthorizeStateChangedHandler authorizeStateChangedHandler;

@property (nonatomic, strong) NSString * appkey;
@property (nonatomic, strong) NSString * appId;
@property (nonatomic, assign) BOOL useTIM;


@end

@implementation TrochilusQQPlatform

static TrochilusQQPlatform * _instance = nil;

#pragma mark- 单例模式
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

+ (void)registerWithParameters:(NSDictionary *)parameters {
    
    [TrochilusQQPlatform sharedInstance].appkey = parameters[@"appKey"];
    [TrochilusQQPlatform sharedInstance].appId = parameters[@"appId"];
    [TrochilusQQPlatform sharedInstance].useTIM = [parameters[@"useTIM"] boolValue];
    
    NSLog(@"%@",[TrochilusQQPlatform sharedInstance].appId = parameters[@"appId"]);
}

#pragma mark- 判断是否安装了客户端
/**
 判断是否安装了QQ
 
 @return YES or NO
 */
+ (BOOL)isQQInstalled {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]]) {
        return YES;
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://sdk"]]) {
        return YES;
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        return YES;
    }
    return NO;
}

/**
 判断是否安装了TIM

 @return YES or NO
 */
+ (BOOL)isTIMInstalled {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"timapi://"]]) {
        return YES;
    }
    
    return NO;
}

#pragma mark- 分享
+ (NSString *)shareWithPlatformType:(TrochilusPlatformType)platformType
                          parameter:(NSMutableDictionary *)parameters
                     onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusQQPlatform sharedInstance].appId length] == 0) {

        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeQQAppIdNotFound];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        return nil;
    }

    if (stateChangedHandler) {
        [TrochilusQQPlatform sharedInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TrochilusQQPlatform isQQInstalled] || [TrochilusQQPlatform isTIMInstalled]) {
        
        TrochilusContentType contentType = [parameters[@"contentType"] integerValue];
        
        NSString * file_type = [TrochilusQQPlatform fileTypeWithPlatformType:platformType
                                                                 contentType:contentType];
        
        NSString * cflag = [TrochilusQQPlatform cflagWithPlatformType:platformType
                                                          contentType:contentType];
        
        //公共参数
        NSMutableString *qqInfo;
        //是否优先TIM分享 && 安装了TIM
        if ([TrochilusQQPlatform sharedInstance].useTIM && [TrochilusQQPlatform isTIMInstalled]) {
            qqInfo = [[NSMutableString alloc] initWithString:@"timapi://share/to_fri?thirdAppDisplayName="];
        }
        else {
            qqInfo = [[NSMutableString alloc] initWithString:@"mqqapi://share/to_fri?thirdAppDisplayName="];
        }
        [qqInfo appendString:[NSString trochilus_base64Encode:kCFBundleDisplayName]];
        [qqInfo appendString:@"&shareType=0"];
        [qqInfo appendFormat:@"&file_type=%@",file_type];
        [qqInfo appendFormat:@"&callback_name=%@",[NSString stringWithFormat:@"QQ%08llx",[[TrochilusQQPlatform sharedInstance].appId longLongValue]]];
        [qqInfo appendString:@"&src_type=app"];
        [qqInfo appendString:@"&version=1"];
        [qqInfo appendFormat:@"&cflag=%@",cflag];
        [qqInfo appendString:@"&callback_type=scheme"];
        [qqInfo appendFormat:@"&sdkv=%@",kQQSDKVer];
        [qqInfo appendString:@"&generalpastboard=1"];
        
        if (contentType == TrochilusContentTypeText) {
            //文本分享
            [qqInfo appendString:[TrochilusQQPlatform shareTextWithPlatformType:platformType parameters:parameters]];
        }
        else if (contentType == TrochilusContentTypeImage) {
            //图片分享
            [qqInfo appendString:[TrochilusQQPlatform shareImageWithPlatformType:platformType parameters:parameters]];
        }
        else if (contentType == TrochilusContentTypeWebPage) {
            //网页分享
            [qqInfo appendString:[TrochilusQQPlatform shareNewsWithPlatformType:platformType parameters:parameters]];
        }
        else if (contentType == TrochilusContentTypeVideo) {
            
            //视频分享 仅QZone支持
            [qqInfo appendString:[TrochilusQQPlatform shareVideoWithPlatformType:platformType parameters:parameters]];
        }
        
        return qqInfo;
    }
    else {
        
        if (stateChangedHandler) {
            
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeQQUninstalled];
            stateChangedHandler(TrochilusResponseStateFail,nil,err);
            
        }
    }
    
    return  nil;
    
}

#pragma mark- 授权登录
+ (NSMutableString *)authorizeWithQQPlatformSettings:(NSDictionary *)settings
                                      onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusQQPlatform sharedInstance].appId length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeQQAppIdNotFound];
        [TrochilusQQPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:error];
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusQQPlatform sharedInstance].authorizeStateChangedHandler = stateChangedHandler;
    }
    
    NSString * authorizeType = @"SSO";
    
//    if ([[TrochilusPlatformKeys sharedInstance].qqAuthType isEqualToString:@"TAuthTypeBoth"]) {
//
//        if ([TrochilusQQPlatform isQQInstalled] || [TrochilusQQPlatform isTIMInstalled]) {
//            //安装了客户端
//            authorizeType = @"SSO";
//        }
//        else {
//            //没安装客户端
//            authorizeType = @"WEB";
//        }
//
//    }
//    else if ([[TrochilusPlatformKeys sharedInstance].qqAuthType isEqualToString:@"TAuthTypeSSO"]) {
//        authorizeType = @"SSO";
//    }
//    else {
//        authorizeType = @"WEB";
//    }
    
    //获取setting参数 用户有配置就用用户的，没配置就默认
    NSString * scopes = @"get_user_info";
    if (settings && settings[@"TAuthSettingKeyScopes"] != nil) {
        if ([settings[@"TAuthSettingKeyScopes"] isKindOfClass:[NSArray class]]) {
            //如果格式不对也不处理，使用默认
            scopes = [(NSArray *)settings[@"TAuthSettingKeyScopes"] componentsJoinedByString:@","];
        }
    }
    
    //授权类型 客户端 or 网页
    if ([authorizeType isEqualToString:@"SSO"]) {
    
        //    mqqOpensdkSSoLogin://SSoLogin/tencent100371282/com.tencent.tencent100371282?generalpastboard=1&sdkv=3.2.1
        NSMutableString * qqAuthorize;
        
        if ([TrochilusQQPlatform sharedInstance].useTIM && [TrochilusQQPlatform isTIMInstalled]) {
            qqAuthorize = [[NSMutableString alloc] initWithString:@"timOpensdkSSoLogin://SSoLogin/"];
        }
        else {
            qqAuthorize = [[NSMutableString alloc] initWithString:@"mqqOpensdkSSoLogin://SSoLogin/"];
        }
        
        [qqAuthorize appendFormat:@"tencent%@/",[TrochilusQQPlatform sharedInstance].appId];
        [qqAuthorize appendFormat:@"com.tencent.tencent%@?",[TrochilusQQPlatform sharedInstance].appId];
        [qqAuthorize appendString:@"generalpastboard=1"];
        [qqAuthorize appendString:[NSString stringWithFormat:@"&sdkv=%@",kQQSDKVer]];
        
        //剪切板key
        NSString * pasteboardKey = [NSString stringWithFormat:@"com.tencent.tencent%@",[TrochilusQQPlatform sharedInstance].appId];
        //系统版本 需要切割status_version 使用 取大版本号
        NSArray * systemVersionArray = [kSystemVersion componentsSeparatedByString:@"."];
        
        NSDictionary * qqAuthorizeDic = @{@"app_id" : [TrochilusQQPlatform sharedInstance].appId,
                                          @"app_name" : kCFBundleDisplayName,
                                          @"bundleid" : kCFBundleIdentifier,
                                          @"client_id" : [TrochilusQQPlatform sharedInstance].appId,
                                          @"response_type" : @"token",
                                          @"scope" : scopes,
                                          @"sdkp" : @"i",
                                          @"sdkv" : @"3.2.1",
                                          @"status_machine" : kModel,
                                          @"status_os" : kSystemVersion,
                                          @"status_version" : systemVersionArray[0]
                                          };
        
        [UIPasteboard trochilus_setPasteboard:pasteboardKey value:qqAuthorizeDic encoding:TrochilusPboardEncodingKeyedArchiver];
        
        return qqAuthorize;
    }
//    else if ([authorizeType isEqualToString:@"WEB"]) {
//        //网页授权
////        TWebViewVC * webViewVC = [TWebViewVC sharedInstance];
////        //        https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=get_simple_userinfo,get_user_info,add_topic,upload_pic,add_share&status_version=10&sdkv=3.2.1&status_machine=iPhone8,2&status_os=10.3.2&switch=1&redirect_uri=auth://www.qq.com&client_id=100371282
////        NSString * url = [NSString stringWithFormat:@"https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=%@&status_version=10&sdkv=3.2.1&status_machine=%@&status_os=%@&switch=1&redirect_uri=auth://www.qq.com&client_id=%@",scopes,kModel,kSystemVersion,[TrochilusPlatformKeys sharedInstance].qqAppId];
////        webViewVC.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////        webViewVC.title = @"QQ Web Login";
////        webViewVC.delegate = [TrochilusQQPlatform sharedInstance];
////
////        UIViewController * vc = [[UIApplication sharedApplication] currentViewController];
////        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webViewVC];
////        [vc presentViewController:nav animated:YES completion:nil];
//    }
    return nil;
}

//获取QQ用户信息
+ (void)geTrochilusUserInfoToQQAccessToken:(NSString *)accessToken oauthConsumerKey:(NSString *)oauthConsumerKey openid:(NSString *)openid completion:(void (^ __nullable)(NSDictionary *))completion {
    
    //用户信息
    //https://graph.qq.com/user/get_user_info?access_token=CFFAB99218D0B19A89CCFE0D8B547267&oauth_consumer_key=100371282&openid=5E8B2C0C051A6B48F8665CF811756930
    
    NSString * url = [NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=%@&openid=%@",accessToken,oauthConsumerKey,openid];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:url];
    request.timeoutInterval = 20.5f;
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (completion) {
                completion(userInfo);
            }
            
        }
        else {
            
            NSError *err = [TrochilusError errorWithCode:TrochilusErrorCodeQQAuthorizeFail userInfo:error.userInfo];
            
            [TrochilusQQPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
        }
        
    }];
    
    [task resume];
}

#pragma mark- 回调
//回调
+ (BOOL)handleUrlWithQQ:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"QQ"]) {
        //分享
        NSDictionary *dic=[NSMutableDictionary trochilus_dictionaryWithUrl:url];
        if (dic[@"error_description"]) {
            [dic setValue:[NSString trochilus_base64Decode:dic[@"error_description"]] forKey:@"error_description"];
        }
        
        if ([dic[@"error"] intValue] == -4) {
            //用户取消
            [TrochilusQQPlatform shareResponseWithState:TrochilusResponseStateCancel error:nil];
        }
        else if ([dic[@"error"] intValue] == 0) {
            //分享成功
            [TrochilusQQPlatform shareResponseWithState:TrochilusResponseStateSuccess error:nil];
        }
        else{
            //分享失败 失败是什么状态 我也不知道 等测试到再说
            NSError *err= [TrochilusError errorWithCode:TrochilusErrorCodeQQShareFail userInfo:dic];
            [TrochilusQQPlatform shareResponseWithState:TrochilusResponseStateFail error:err];
            
        }
        
        return YES;
    }
    else if ([url.scheme hasPrefix:@"tencent"]) {
        //QQ登录
        NSString * authorizeKey = [NSString stringWithFormat:@"com.tencent.tencent%@",[TrochilusQQPlatform sharedInstance].appId];
        NSDictionary * ret = [UIPasteboard trochilus_getPasteboard:authorizeKey encoding:TrochilusPboardEncodingKeyedArchiver];
        
        if (ret[@"user_cancelled"] && [ret[@"user_cancelled"] boolValue] == YES) {
            //取消授权
            [TrochilusQQPlatform authorizeResponseWithState:TrochilusResponseStateCancel userInfo:nil error:nil];
        }
        else if (ret[@"ret"]&&[ret[@"ret"] intValue]==0) {
            //授权成功
            __block TrochilusUser * userInfo = [[TrochilusUser alloc] init];
            userInfo.accessToken = ret[@"access_token"];
            userInfo.openid = ret[@"openid"];
            
            //获取用户信息
            [TrochilusQQPlatform geTrochilusUserInfoToQQAccessToken:userInfo.accessToken oauthConsumerKey:[TrochilusQQPlatform sharedInstance].appId openid:userInfo.openid completion:^(NSDictionary * user) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    userInfo.originalResponse = user;
                    userInfo.name = user[@"nickname"];
                    userInfo.iconurl = user[@"figureurl_qq_2"];
                    userInfo.unionGender = user[@"gender"];
                    userInfo.gender = [user[@"gender"] isEqualToString:@"男"] ? @"M" : @"F";
                    
                    [TrochilusQQPlatform authorizeResponseWithState:TrochilusResponseStateSuccess userInfo:userInfo error:nil];
                    
                });
                
            }];
            
        }
        else {
            //授权失败
            NSError *err= [TrochilusError errorWithCode:TrochilusErrorCodeQQAuthorizeFail userInfo:ret];
            
            [TrochilusQQPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
        }
        
        return YES;
    }
    return NO;
}

#pragma mark- 状态回调
//分享
+ (void)shareResponseWithState:(TrochilusResponseState)responseState error:(NSError *)error {
    
    if ([TrochilusQQPlatform sharedInstance].stateChangedHandler) {
        [TrochilusQQPlatform sharedInstance].stateChangedHandler(responseState, nil, error);
    }
    
    [TrochilusQQPlatform sharedInstance].stateChangedHandler = nil;
}

//授权
+ (void)authorizeResponseWithState:(TrochilusResponseState)responseState userInfo:(TrochilusUser *)user error:(NSError *)error {
    
    if ([TrochilusQQPlatform sharedInstance].authorizeStateChangedHandler) {
        [TrochilusQQPlatform sharedInstance].authorizeStateChangedHandler(responseState, user, error);
    }
    
    [TrochilusQQPlatform sharedInstance].authorizeStateChangedHandler = nil;
}

//#pragma mark- TWebViewDelegate
//- (void)authorizeToQQInfo:(NSDictionary *)info {
//
//    //获取用户信息
//    [TrochilusQQPlatform geTrochilusUserInfoToQQAccessToken:info[@"access_token"] oauthConsumerKey:[TrochilusPlatformKeys sharedInstance].qqAppId openid:info[@"openid"] completion:^(NSDictionary * user) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            TrochilusUser * userInfo = [[TrochilusUser alloc] init];
//            userInfo.accessToken = info[@"access_token"];
//            userInfo.openid = info[@"openid"];
//
//            userInfo.originalResponse = user;
//            userInfo.name = user[@"nickname"];
//            userInfo.iconurl = user[@"figureurl_qq_2"];
//            userInfo.unionGender = user[@"gender"];
//            userInfo.gender = [user[@"gender"] isEqualToString:@"男"] ? @"M" : @"F";
//
//            [TrochilusQQPlatform authorizeResponseWithState:TrochilusResponseStateSuccess userInfo:userInfo error:nil];
//
//        });
//
//    }];
//
//}
//
//- (void)authorizeCancel {
//    self.authorizeStateChangedHandler(TrochilusResponseStateCancel, nil, nil);
//}

#pragma mark- 分享参数构造
+ (NSString *)fileTypeWithPlatformType:(TrochilusPlatformType)platformType contentType:(TrochilusContentType)contentType {
    
    if (platformType == TrochilusPlatformSubTypeQZone && contentType != TrochilusContentTypeWebPage) {
        //QQ空间 && 不是 链接分享
        return @"qzone";
    }
    else if (contentType == TrochilusContentTypeWebPage) {
        return @"news";
    }
    else if (contentType == TrochilusContentTypeText) {
        return @"text";
    }
    else if (contentType == TrochilusContentTypeImage) {
        return @"img";
    }
    return @"";
}

+ (NSString *)cflagWithPlatformType:(TrochilusPlatformType)platformType contentType:(TrochilusContentType)contentType {
    
    if (platformType == TrochilusPlatformSubTypeQZone && contentType == TrochilusContentTypeWebPage) {
        //QQ空间 && 链接分享
        return @"1";
    }
    else if (platformType == TrochilusPlatformSubTypeQQFriend) {
        return @"0";
    }
    return @"";
}

+ (NSString *)shareTextWithPlatformType:(TrochilusPlatformType)platformType parameters:(NSMutableDictionary *)parameters {
    
    NSString * text = parameters[@"text"] == nil ? parameters[@"title"] :  parameters[@"text"];
    
    if (platformType == TrochilusPlatformSubTypeQQFriend) {
        
        return [NSString stringWithFormat:@"&file_data=%@",[NSString trochilus_base64Encode:text]];
    }
    else if (platformType == TrochilusPlatformSubTypeQZone) {
        
        return [NSString stringWithFormat:@"&title=%@&objectlocation=pasteboard",[NSString trochilus_base64Encode:text]];
    }
    
    return @"";
}

+ (NSString *)shareImageWithPlatformType:(TrochilusPlatformType)platformType parameters:(NSMutableDictionary *)parameters {
    
    NSDictionary *data = nil;

    if (platformType == TrochilusPlatformSubTypeQQFriend) {
        
        NSData * imageData = parameters[@"images"][0];
        
        NSData * thumbImgData = parameters[@"thumbImage"][0];
        
        data=@{@"file_data":imageData,
               @"previewimagedata":thumbImgData};
        
        [UIPasteboard trochilus_setPasteboard:@"com.tencent.mqq.api.apiLargeData" value:data encoding:TrochilusPboardEncodingKeyedArchiver];
        return [NSString stringWithFormat:@"&description=%@&title=%@&objectlocation=pasteboard",[NSString trochilus_base64Encode:parameters[@"text"]],[NSString trochilus_base64Encode:parameters[@"title"]]];
        
    }
    else if (platformType == TrochilusPlatformSubTypeQZone) {
        
        data = @{@"image_data_list" : parameters[@"images"] };
        
        [UIPasteboard trochilus_setPasteboard:@"com.tencent.mqq.api.apiLargeData" value:data encoding:TrochilusPboardEncodingKeyedArchiver];
        
        return @"&objectlocation=pasteboard";
    }
    
    return @"";
}

+ (NSString *)shareNewsWithPlatformType:(TrochilusPlatformType)platformType parameters:(NSMutableDictionary *)parameters {
    
    NSDictionary *data = nil;
    
    if (platformType == TrochilusPlatformSubTypeQQFriend || platformType == TrochilusPlatformSubTypeQZone) {
    
        NSData * thumbImgData = parameters[@"thumbImage"][0];
        
        data=@{@"previewimagedata":thumbImgData};
        
        return [NSString stringWithFormat:@"&description=%@&title=%@&url=%@&objectlocation=pasteboard",
                [NSString trochilus_base64Encode:parameters[@"text"]],
                [NSString trochilus_base64Encode:parameters[@"title"]],
                [NSString trochilus_base64Encode:parameters[@"url"]]];
    }
    
    return @"";
}

+ (NSString *)shareVideoWithPlatformType:(TrochilusPlatformType)platformType parameters:(NSMutableDictionary *)parameters {
    
    if (platformType == TrochilusPlatformSubTypeQZone) {
        return [NSString stringWithFormat:@"&video_assetURL=%@&objectlocation=pasteboard",[NSString trochilus_base64Encode:parameters[@"url"]]];
    }
    
    return @"";
}
@end


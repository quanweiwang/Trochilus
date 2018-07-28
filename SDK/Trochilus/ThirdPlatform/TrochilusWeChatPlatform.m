//
//  TrochilusWeChatPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusWeChatPlatform.h"
#import "TrochilusUser.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "TrochilusError.h"
#import "TrochilusSysDefine.h"
#import "TrochilusNetWorking.h"

#import "UIPasteboard+Trochilus.h"
#import "NSMutableDictionary+TrochilusShare.h"
#import "UIImage+Trochilus.h"
#import "NSMutableDictionary+Trochilus.h"

@interface TrochilusWeChatPlatform ()

@property (nonatomic, copy) TrochilusStateChangedHandler stateChangedHandler; //分享
@property (nonatomic, copy) TrochilusAuthorizeStateChangedHandler authorizestateChangedHandler; //授权
@property (nonatomic, copy) TrochilusPayStateChangedHandler payStateChangedHandler;//支付

@property (nonatomic, strong) NSString * appSecret;
@property (nonatomic, strong) NSString * appId;

@end

@implementation TrochilusWeChatPlatform

#pragma mark- 单例模式
static TrochilusWeChatPlatform * _instance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    }) ;
    
    return _instance ;
}

+ (void)registerWithParameters:(NSDictionary *)parameters {
    
    [TrochilusWeChatPlatform sharedInstance].appSecret = parameters[@"appSecret"];
    [TrochilusWeChatPlatform sharedInstance].appId = parameters[@"appId"];
    
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

#pragma mark- 分享
+ (NSString *)shareWithPlatformType:(TrochilusPlatformType)platformType
                          parameter:(NSMutableDictionary *)parameters
                     onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    //判断有没有填写 appID 没填写不能分享
    if ([[TrochilusWeChatPlatform sharedInstance].appId length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAppKeyNotFound];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        
        NSDictionary * wechatDic;
        
        TrochilusContentType contentType = [parameters[@"contentType"] integerValue];
        
        if (contentType == TrochilusContentTypeText) {
            //文本
            NSString * shareText = parameters[@"text"];
            
            wechatDic = [TrochilusWeChatPlatform shareWithText:shareText
                                                  platformType:platformType];
        }
        else if (contentType == TrochilusContentTypeImage && parameters[@"emoticonData"] == nil) {
            //图片
            wechatDic = [TrochilusWeChatPlatform shareWithImage:parameters[@"image"]
                                                     thumbImage:parameters[@"thumbImage"]
                                                   emoticonData:nil
                                               shareDescription:parameters[@"text"]
                                                   platformType:platformType];
        }
        else if (contentType == TrochilusContentTypeWebPage) {
            //链接
            wechatDic = [TrochilusWeChatPlatform shareWithLink:parameters[@"url"]
                                                  mediaTagName:parameters[@"mediaTagName"]
                                                         title:parameters[@"title"]
                                              shareDescription:parameters[@"text"]
                                                         image:parameters[@"image"]
                                                    thumbImage:parameters[@"thumbImage"]
                                                  platformType:platformType];
            
        }
        else if (contentType == TrochilusContentTypeAudio) {
            //音频
            wechatDic = [TrochilusWeChatPlatform shareWithAudioUrl:parameters[@"url"]
                                                             title:parameters[@"title"]
                                                  shareDescription:parameters[@"text"]
                                                            images:parameters[@"image"]
                                                        thumbImage:parameters[@"thumbImage"]
                                                      platformType:platformType];
        }
        else if (contentType == TrochilusContentTypeVideo) {
            //视频
            wechatDic = [TrochilusWeChatPlatform shareWithVideoUrl:parameters[@"url"]
                                                             title:parameters[@"title"]
                                                  shareDescription:parameters[@"text"]
                                                            images:parameters[@"image"]
                                                        thumbImage:parameters[@"thumbImage"]
                                                      platformType:platformType];
        }
        else if (contentType == TrochilusContentTypeApp) {
            //应用消息
            wechatDic = [TrochilusWeChatPlatform shareWithApp:parameters[@"url"]
                                                        title:parameters[@"title"]
                                             shareDescription:parameters[@"text"]
                                                       images:parameters[@"image"]
                                                   thumbImage:parameters[@"thumbImage"]
                                                      extInfo:parameters[@"extInfo"]
                                                     fileData:parameters[@"fileData"]
                                                messageAction:parameters[@"messageAction"]
                                                 platformType:platformType];
            
        }
        else if (contentType == TrochilusContentTypeImage && parameters[@"emoticonData"]) {
            //表情图片
            NSData * thumbImageData = parameters[@"thumbImage"];
            
            wechatDic = [TrochilusWeChatPlatform shareWithImage:nil
                                                     thumbImage:thumbImageData
                                                   emoticonData:parameters[@"emoticonData"]
                                               shareDescription:parameters[@"text"]
                                                   platformType:platformType];
            
        }
        else if (contentType == TrochilusContentTypeFile) {
            //文件 仅微信可用
            wechatDic = [TrochilusWeChatPlatform shareWithSourceFileData:parameters[@"fileData"]
                                                                   title:parameters[@"title"]
                                                        shareDescription:parameters[@"text"]
                                                                  images:parameters[@"image"]
                                                              thumbImage:parameters[@"thumbImage"]
                                                     sourceFileExtension:parameters[@"fileExtension"]
                                                            platformType:platformType];
            
        }
        else if (contentType == TrochilusContentTypeMiniProgram) {
            //小程序
            wechatDic = [TrochilusWeChatPlatform shareMiniProgramWithParameter:parameters];
            
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        [UIPasteboard trochilusSetPasteboard:@"content" value:@{[TrochilusWeChatPlatform sharedInstance].appId : wechatDic} encoding:TrochilusPboardEncodingPropertyListSerialization];
        
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?supportcontentfromwx=8191",[TrochilusWeChatPlatform sharedInstance].appId];
    
    }
    else {
        
        NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboUninstalled];
        [TrochilusWeChatPlatform shareResponseWithState:TrochilusResponseStateFail error:err];
        
    }
    
    return nil;
    
}

#pragma mark 分享类型
//文本分享
+ (NSDictionary *)shareWithText:(NSString *)text platformType:(TrochilusPlatformType)platformType {
    
    
    
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    NSDictionary * wechatDic =  @{@"command" : @"1020",
                                  @"result" : @"1",
                                  @"returnFromApp" : @"0",
                                  @"scene" : scene,
                                  @"sdkver" : kWeChatSDKVer,
                                  @"title" : text};
    return wechatDic;
}

//图片分享
+ (NSDictionary *)shareWithImage:(id)image
                      thumbImage:(id)thumbImage
                    emoticonData:(id)emoticonData
                shareDescription:(NSString *)shareDescription
                    platformType:(TrochilusPlatformType)platformType {
    
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    NSString * objectType = emoticonData ? @"8" : @"2";
    
    NSData * imageData;
    
    if (emoticonData) {
        imageData = emoticonData;
    }
    else {
        imageData = image;
    }
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:@(0) forKey:@"miniprogramType"];
    [wechatDic setValue:objectType forKey:@"objectType"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"0" forKey:@"withShareTicket"];
    [wechatDic setValue:scene forKey:@"scene"];
    [wechatDic setValue:imageData forKey:@"fileData"];
    [wechatDic setValue:thumbImage forKey:@"thumbData"];
    
    return wechatDic;
}

//链接分享
+ (NSDictionary *)shareWithLink:(NSString *)url
                   mediaTagName:(NSString *)mediaTagName
                          title:(NSString *)title
               shareDescription:(NSString *)shareDescription
                          image:(id)image
                     thumbImage:(id)thumbImage
                   platformType:(TrochilusPlatformType)platformType {
    
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    //链接
    NSData * thumbData = thumbImage;
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:@(0) forKey:@"miniprogramType"];
    [wechatDic setValue:@"5" forKey:@"objectType"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"0" forKey:@"withShareTicket"];
    [wechatDic setValue:scene forKey:@"scene"];
    [wechatDic setValue:shareDescription forKey:@"description"];
    [wechatDic setValue:thumbData forKey:@"thumbData"];
    [wechatDic setValue:title forKey:@"title"];
    [wechatDic setValue:mediaTagName forKey:@"mediaTagName"];
    [wechatDic setValue:url forKey:@"mediaUrl"];
    
    return [wechatDic copy];
}

//网络音频
+ (NSDictionary *)shareWithAudioUrl:(NSString *)audioUrl
                              title:(NSString *)title
                   shareDescription:(NSString *)shareDescription
                             images:(id)images thumbImage:(id)thumbImage
                       platformType:(TrochilusPlatformType)platformType {
    
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    //音频
    NSData * thumbData = thumbImage;
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    [wechatDic setValue:@"3" forKey:@"objectType"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:scene forKey:@"scene"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"0" forKey:@"withShareTicket"];
    [wechatDic setValue:@(0) forKey:@"miniprogramType"];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:shareDescription forKey:@"description"];
    [wechatDic setValue:title forKey:@"title"];
    [wechatDic setValue:audioUrl forKey:@"mediaUrl"];
#warning mediaDataUrl 什么鬼???
    [wechatDic setValue:audioUrl forKey:@"mediaDataUrl"];
    [wechatDic setValue:thumbData forKey:@"thumbData"];
    
    return wechatDic;
}

//网络视频
+ (NSDictionary *)shareWithVideoUrl:(NSString *)videoUrl
                              title:(NSString *)title
                   shareDescription:(NSString *)shareDescription
                             images:(id)images
                         thumbImage:(id)thumbImage
                       platformType:(TrochilusPlatformType)platformType {
    
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    //视屏
    NSData * thumbData = thumbImage;
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    [wechatDic setValue:@"4" forKey:@"objectType"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:scene forKey:@"scene"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"0" forKey:@"withShareTicket"];
    [wechatDic setValue:@(0) forKey:@"miniprogramType"];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:shareDescription forKey:@"description"];
    [wechatDic setValue:title forKey:@"title"];
    [wechatDic setValue:videoUrl forKey:@"mediaUrl"];
    [wechatDic setValue:thumbData forKey:@"thumbData"];
    
    return wechatDic;
}

//应用消息
+ (NSDictionary *)shareWithApp:(NSString *)appUrl
                         title:(NSString *)title
              shareDescription:(NSString *)shareDescription
                        images:(id)images
                    thumbImage:(id)thumbImage
                       extInfo:(NSString *)extInfo
                      fileData:(id)fileData
                 messageAction:(NSString *)messageAction
                  platformType:(TrochilusPlatformType)platformType {
    
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    NSData * thumbData = thumbImage;
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    [wechatDic setValue:@"7" forKey:@"objectType"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:scene forKey:@"scene"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"0" forKey:@"withShareTicket"];
    [wechatDic setValue:@(0) forKey:@"miniprogramType"];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:shareDescription forKey:@"description"];
    [wechatDic setValue:extInfo forKey:@"extInfo"];
    [wechatDic setValue:messageAction forKey:@"messageAction"];
    [wechatDic setValue:title forKey:@"title"];
    [wechatDic setValue:appUrl forKey:@"mediaUrl"];
    [wechatDic setValue:thumbData forKey:@"thumbData"];
    [wechatDic setValue:extInfo forKey:@"messageExt"];
    [wechatDic setValue:fileData forKey:@"fileData"];

    return wechatDic;
    
}

//本地文件
+ (NSDictionary *)shareWithSourceFileData:(NSData *)sourceFileData
                                    title:(NSString *)title
                         shareDescription:(NSString *)shareDescription
                                   images:(id)images
                               thumbImage:(id)thumbImage
                      sourceFileExtension:(NSString *)sourceFileExtension
                             platformType:(TrochilusPlatformType)platformType {
    
    //文件 仅微信可用
    NSString * scene = [TrochilusWeChatPlatform sceneWtihPlatformType:platformType];
    
    NSData * thumbData = thumbImage;
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    [wechatDic setValue:@"6" forKey:@"objectType"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:scene forKey:@"scene"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"0" forKey:@"withShareTicket"];
    [wechatDic setValue:@(0) forKey:@"miniprogramType"];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:shareDescription forKey:@"description"];
    [wechatDic setValue:sourceFileData forKey:@"fileData"];
    [wechatDic setValue:title forKey:@"title"];
    [wechatDic setValue:sourceFileExtension forKey:@"fileExt"];
    [wechatDic setValue:thumbData forKey:@"thumbData"];
    
    return wechatDic;
    
}

//小程序分享
+ (NSDictionary *)shareMiniProgramWithParameter:(NSMutableDictionary *)parameters {
    
//    SDKSample[10543:2635740] description---小程序Desc
//    2018-07-28 10:12:18.902734+0800 SDKSample[10543:2635740] hdThumbData---
//    2018-07-28 10:12:18.951378+0800 SDKSample[10543:2635740] appBrandUserName---gh_d43f693ca31f
//    2018-07-28 10:12:18.951444+0800 SDKSample[10543:2635740] objectType---36
//    2018-07-28 10:12:18.951481+0800 SDKSample[10543:2635740] scene---0
//    2018-07-28 10:12:18.951499+0800 SDKSample[10543:2635740] appBrandPath---
//    2018-07-28 10:12:18.951534+0800 SDKSample[10543:2635740] title---小程序title
//    2018-07-28 10:12:18.951614+0800 SDKSample[10543:2635740] mediaUrl---https://www.baidu.com
//    2018-07-28 10:12:18.951664+0800 SDKSample[10543:2635740] sdkver---1.8.2
//    2018-07-28 10:12:18.951725+0800 SDKSample[10543:2635740] command---1010
//    2018-07-28 10:12:18.951761+0800 SDKSample[10543:2635740] result---1
//    2018-07-28 10:12:18.951824+0800 SDKSample[10543:2635740] withShareTicket---1
//    2018-07-28 10:12:18.951852+0800 SDKSample[10543:2635740] returnFromApp---0
//    2018-07-28 10:12:18.951892+0800 SDKSample[10543:2635740] miniprogramType---0
    
    //    TrochilusMessageObject * message = [parameter objectForKey:@"TrochilusMessageObject"];
    
    NSString * title = parameters[@"title"];
    
    NSString * miniProgramDescription = parameters[@"text"];
    
    NSString * path = parameters[@"path"];
    
    NSString * userName = parameters[@"userName"];
    
    NSString * withShareTicket = [parameters[@"withShareTicket"] boolValue] == YES ? @"1" : @"0";
    
    NSNumber * programType = parameters[@"programType"];
    
    //网址（6.5.6以下版本微信会自动转化为分享链接 必填）
    NSString * webpageUrl = parameters[@"webpageUrl"];
    
    NSData * hdThumbData = parameters[@"hdThumImage"];
    
    NSMutableDictionary * wechatDic = [NSMutableDictionary dictionary];
    
    [wechatDic setValue:title forKey:@"title"];
    [wechatDic setValue:miniProgramDescription forKey:@"description"];
    [wechatDic setValue:path forKey:@"appBrandPath"];
    [wechatDic setValue:userName forKey:@"appBrandUserName"];
    [wechatDic setValue:withShareTicket forKey:@"withShareTicket"];
    [wechatDic setValue:programType forKey:@"miniprogramType"];
    [wechatDic setValue:webpageUrl forKey:@"mediaUrl"];
    [wechatDic setValue:@"36" forKey:@"objectType"];
    [wechatDic setValue:@"0" forKey:@"scene"];
    [wechatDic setValue:@"1010" forKey:@"command"];
    [wechatDic setValue:kWeChatSDKVer forKey:@"sdkver"];
    [wechatDic setValue:@"1" forKey:@"result"];
    [wechatDic setValue:@"0" forKey:@"returnFromApp"];
    [wechatDic setValue:hdThumbData forKey:@"hdThumbData"];
    
    return [wechatDic copy];

}

#pragma mark- 授权登录
+ (NSMutableString *)authorizeWithPlatformSettings:(NSString *)settings
                                          onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusWeChatPlatform sharedInstance].appId length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppIdNotFound];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    else if ([[TrochilusWeChatPlatform sharedInstance].appSecret length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppSecretNotFound];
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].authorizestateChangedHandler = stateChangedHandler;
    }
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        
        //获取setting参数 用户有配置就用用户的，没配置就默认
        NSString * scopes;
        if ([settings length] == 0) {
            scopes = @"snsapi_userinfo";
        }
        
        //    weixin://app/wx4868b35061f87885/auth/?scope=snsapi_userinfo&state=1499220438
        NSString * timeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        NSMutableString * wechatAuthorize = [[NSMutableString alloc] initWithString:@"weixin://app/"];
        [wechatAuthorize appendFormat:@"%@/",[TrochilusWeChatPlatform sharedInstance].appId];
        [wechatAuthorize appendFormat:@"auth/?scope=%@",scopes];
        [wechatAuthorize appendFormat:@"&state=%@",timeInterval];
        
        return wechatAuthorize;
    }
    else {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatUninstalled];
        [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:error];
    }
    
    return nil;
    
}

//获取微信access_token
+ (void)getOpenIdToCode:(NSString *)code appId:(NSString *)appId secret:(NSString *)secret {
    
    //微信access_token
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appId,secret,code];
    
    [TrochilusNetWorking getWithUrl:url success:^(id  _Nonnull responseObj) {
        
        if (responseObj[@"errcode"]) {
            //失败
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAuthorizeFail userInfo:responseObj];

            [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
            
        }
        else {
            
            [TrochilusWeChatPlatform getUserInfoToWechatAccessToken:responseObj[@"access_token"] openid:responseObj[@"openid"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        //授权失败
        NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:error.userInfo];
        [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
        
    }];
    
}

//获取微信用户信息
+ (void)getUserInfoToWechatAccessToken:(NSString *)accessToken openid:(NSString *)openid {
    
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN
    NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN",accessToken,openid];
    
    [TrochilusNetWorking getWithUrl:url success:^(id  _Nonnull responseObj) {
       
        if (responseObj[@"errcode"]) {
            //失败
            
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:responseObj];
            [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
            
        }
        else{
            //成功
            TrochilusUser * user = [[TrochilusUser alloc] init];
            user.accessToken = accessToken;
            user.unionId = responseObj[@"unionid"];
            user.uid = responseObj[@"unionid"];
            user.openid = responseObj[@"openid"];
            user.refreshToken = responseObj[@"refresh_token"];
            user.originalResponse = responseObj;
            user.name = responseObj[@"nickname"];
            user.iconurl = responseObj[@"headimgurl"];
            user.unionGender = [responseObj[@"sex"] integerValue] == 1 ? @"男" : @"女";
            user.gender = [NSString stringWithFormat:@"%ld",[responseObj[@"sex"] integerValue]];
            
            [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateSuccess userInfo:user error:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:error.userInfo];
        [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
        
    }];
    
}

#pragma mark- 微信支付
+ (NSString *)payToWechatParameters:(id)parameters
                     onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        
        if (stateChangedHandler) {
            [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler = stateChangedHandler;
        }
        
        if ([parameters isKindOfClass:[NSString class]]) {
            
            return [NSString stringWithFormat:@"weixin://app/%@/pay/?%@",[TrochilusWeChatPlatform sharedInstance].appId,parameters];
        }
        else {
            
            NSString * partnerId = parameters[@"partnerId"];
            NSString * prepayId = parameters[@"prepayId"];
            NSString * nonceStr = parameters[@"nonceStr"];
            NSString * timeStamp = parameters[@"timeStamp"];
            NSString * sign = parameters[@"sign"];
            
            NSString * wechatPayInfo = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",[TrochilusWeChatPlatform sharedInstance].appId,nonceStr,partnerId,prepayId,timeStamp,sign];
    
            return wechatPayInfo;
        }
    }
    else {
        
        NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboUninstalled];
        [TrochilusWeChatPlatform shareResponseWithState:TrochilusResponseStateFail error:err];
    }
    
    return nil;
    
}

#pragma mark- 回调
+ (BOOL)handleUrlWithWeChat:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"wx"]) {
        
        if ([url.absoluteString rangeOfString:@"://oauth"].location != NSNotFound) {
            //微信登录
            NSDictionary * wechat = [NSMutableDictionary trochilusDictionaryWithUrl:url];
            
            if ([wechat[@"ErrCode"] integerValue] == 0) {
                //用户同意
                [TrochilusWeChatPlatform getOpenIdToCode:wechat[@"code"] appId:[TrochilusWeChatPlatform sharedInstance].appId secret:[TrochilusWeChatPlatform sharedInstance].appSecret];
            }
            else if ([wechat[@"ErrCode"] integerValue] == -4) {
                //用户拒绝授权
                [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateCancel userInfo:nil error:nil];
            }
            else if ([wechat[@"ErrCode"] integerValue] == -2) {
                //用户取消
                [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateCancel userInfo:nil error:nil];
            }
            
        }
        else if ([url.absoluteString rangeOfString:@"://pay/"].location != NSNotFound) {
            //微信支付
            NSDictionary * wechat = [NSMutableDictionary trochilusDictionaryWithUrl:url];
            if ([wechat[@"ret"] integerValue] == 0) {
                //支付成功
                
                [TrochilusWeChatPlatform payResponseWithState:TrochilusResponseStateSuccess error:nil];
                
            }else if ([wechat[@"ret"] integerValue] == -2){
                //用户点击取消并返回
                
                [TrochilusWeChatPlatform payResponseWithState:TrochilusResponseStateCancel error:nil];
            }
            else {
                //支付失败
                
                NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatPayFail userInfo:wechat];
                
                [TrochilusWeChatPlatform payResponseWithState:TrochilusResponseStateFail error:err];
                
            }
            
        }
        else {
            //分享
            //获取剪切板内容
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
//            NSLog(@"%@",pasteboard.pasteboardTypes);
            //微信分享
            //            {
            //                wx4868b35061f87885 =     {
            //                    command = 2020;
            //                    country = CN;
            //                    language = "zh_CN";
            //                    result = 0;
            //                    returnFromApp = 0;
            //                    sdkver = "1.5";
            //                };
            //            }
            //获取剪切板内容 content 是通过上面打印得知的
            NSData * wechatData = [pasteboard valueForPasteboardType:@"content"];
            
            //微信的NSData序列号方式为NSPropertyListSerialization
            NSDictionary * wechatInfo = [NSPropertyListSerialization propertyListWithData:wechatData options:0 format:NULL error:nil];
//            NSLog(@"%@",wechatInfo);
            
            //获取微信返回值
            NSDictionary * wechatResponse = wechatInfo[[TrochilusWeChatPlatform sharedInstance].appId];
            
            if ([wechatResponse[@"result"] integerValue] == 0) {
                //分享成功
                [TrochilusWeChatPlatform shareResponseWithState:TrochilusResponseStateSuccess error:nil];
            }
            else if ([wechatResponse[@"result"] integerValue] == -2) {
                //用户点击取消并返回
                [TrochilusWeChatPlatform shareResponseWithState:TrochilusResponseStateCancel error:nil];
            }
            else {
                //分享失败
                NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatShareFail userInfo:wechatResponse];
                [TrochilusWeChatPlatform shareResponseWithState:TrochilusResponseStateFail error:err];
            }
            
        }
        return YES;
    }
    return NO;
}

#pragma mark- 客户端是否安装
/**
 判断是否安装了微信
 
 @return YES or NO
 */
+ (BOOL)isWeChatInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

#pragma mark- 支付结果查询通知(iOS9后出现左上角返回APP功能，这样无法收到支付平台的回调 需要去自己服务器查询)
- (void)checkPayState {
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //延迟0.5s执行
        
        [TrochilusWeChatPlatform payResponseWithState:TrochilusResponseStatePayWait error:nil];
    });
    
}

#pragma mark- 状态回调
//分享
+ (void)shareResponseWithState:(TrochilusResponseState)responseState error:(NSError *)error {
    
    if ([TrochilusWeChatPlatform sharedInstance].stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].stateChangedHandler(responseState, nil, error);
    }
    
    [TrochilusWeChatPlatform sharedInstance].stateChangedHandler = nil;
}

//授权
+ (void)authorizeResponseWithState:(TrochilusResponseState)responseState userInfo:(TrochilusUser *)user error:(NSError *)error {
    
    if ([TrochilusWeChatPlatform sharedInstance].authorizestateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].authorizestateChangedHandler(responseState, user, error);
    }
    
    [TrochilusWeChatPlatform sharedInstance].authorizestateChangedHandler = nil;
}

+ (void)payResponseWithState:(TrochilusResponseState)responseState error:(NSError *)error {
    
    if ([TrochilusWeChatPlatform sharedInstance].payStateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler(responseState,error);
    }
    
    [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler = nil;
}

#pragma mark- 判断scene值
+ (NSString *)sceneWtihPlatformType:(TrochilusPlatformType)platformType {
    
    NSString * scene = @"";
    
    if (platformType == TrochilusPlatformSubTypeWechatSession) {
        //微信好友
        scene = @"0";
    }
    else if (platformType == TrochilusPlatformSubTypeWechatTimeline) {
        //微信朋友圈
        scene = @"1";
    }
    else if (platformType == TrochilusPlatformSubTypeWechatFav) {
        //微信收藏
        scene = @"2";
    }
    
    return scene;
}

@end


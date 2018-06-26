//
//  TrochilusWeChatPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusWeChatPlatform.h"
#import "NSMutableDictionary+TrochilusShare.h"
#import <UIKit/UIKit.h>
#import "UIPasteboard+Trochilus.h"
#import "NSData+Trochilus.h"
#import "NSMutableArray+Trochilus.h"
#import "TrochilusUser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TrochilusPlatformKeys.h"
#import "TrochilusError.h"
#import "TrochilusSysDefine.h"

@interface TrochilusWeChatPlatform ()

@property(copy, nonatomic)TrochilusStateChangedHandler stateChangedHandler; //分享
@property(copy, nonatomic)TrochilusAuthorizeStateChangedHandler authorizestateChangedHandler; //授权
@property(copy, nonatomic)TrochilusPayStateChangedHandler payStateChangedHandler;//支付

@end

@implementation TrochilusWeChatPlatform

#pragma mark- 单例模式
static TrochilusWeChatPlatform * _instance = nil;

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
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

#pragma mark- 分享
+ (NSString *)shareWithWeChatPlatform:(NSMutableDictionary *)parameters onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([[TrochilusPlatformKeys sharedInstance].wechatAppId length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppIdNotFound];
        [TrochilusWeChatPlatform shareResponseWithState:TrochilusResponseStateFail error:error];
        
        return nil;
    }
    
    if ([[parameters trochilus_platformSubType] integerValue] == TrochilusPlatformSubTypeWechatSession) {
        //微信好友
        return [TrochilusWeChatPlatform shareWithWechatSessionParameters:parameters onStateChanged:stateChangedHandler];
    }
    else if ([[parameters trochilus_platformSubType] integerValue] == TrochilusPlatformSubTypeWechatTimeline) {
        //微信朋友圈
        return [TrochilusWeChatPlatform shareWithWechatTimelineParameters:parameters onStateChanged:stateChangedHandler];
    }
    else {
        //微信收藏
        return [TrochilusWeChatPlatform shareWithWechatFavParameters:parameters onStateChanged:stateChangedHandler];
    }
    
}

//微信好友分享
+ (NSString *)shareWithWechatSessionParameters:(NSMutableDictionary *)parameters onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        
        TrochilusContentType contentType = [[parameters trochilus_contentType] integerValue];
        NSDictionary * wechatDic;
        
        if (contentType == TrochilusContentTypeText) {
            //文本
            NSString * shareText = [parameters trochilus_text];
            
            wechatDic = [TrochilusWeChatPlatform shareWithText:shareText
                                                  platformType:TrochilusPlatformSubTypeWechatSession];
        }
        else if (contentType == TrochilusContentTypeImage && [parameters trochilus_emoticonData] == nil) {
            //图片
            wechatDic = [TrochilusWeChatPlatform shareWithImage:[parameters trochilus_images]
                                                     thumbImage:[parameters trochilus_thumbImage]
                                                   emoticonData:nil
                                               shareDescription:[parameters trochilus_text]
                                                   platformType:TrochilusPlatformSubTypeWechatSession];
        }
        else if (contentType == TrochilusContentTypeWebPage) {
            //链接
            wechatDic = [TrochilusWeChatPlatform shareWithLink:[parameters trochilus_url].absoluteString
                                             title:[parameters trochilus_title]
                                  shareDescription:[parameters trochilus_text]
                                             image:[parameters trochilus_images]
                                        thumbImage:[parameters trochilus_thumbImage]
                                                  platformType:TrochilusPlatformSubTypeWechatSession];
           
        }
        else if (contentType == TrochilusContentTypeAudio) {
            
            //音频
            wechatDic = [TrochilusWeChatPlatform shareWithAudioUrl:[parameters trochilus_url].absoluteString
                                                 title:[parameters trochilus_title]
                                      shareDescription:[parameters trochilus_text]
                                                images:[parameters trochilus_images]
                                            thumbImage:[parameters trochilus_thumbImage]
                                          platformType:TrochilusPlatformSubTypeWechatSession];
        }
        else if (contentType == TrochilusContentTypeVideo) {
            
            //视频
            wechatDic = [TrochilusWeChatPlatform shareWithVideoUrl:[parameters trochilus_url].absoluteString
                                                             title:[parameters trochilus_title]
                                                  shareDescription:[parameters trochilus_text]
                                                            images:[parameters trochilus_images]
                                                        thumbImage:[parameters trochilus_thumbImage]
                                                      platformType:TrochilusPlatformSubTypeWechatSession];
        }
        else if (contentType == TrochilusContentTypeApp) {
            
            //应用消息
            wechatDic = [TrochilusWeChatPlatform shareWithApp:[parameters trochilus_url].absoluteString
                                                        title:[parameters trochilus_title]
                                             shareDescription:[parameters trochilus_text]
                                                       images:[parameters trochilus_images]
                                                   thumbImage:[parameters trochilus_thumbImage]
                                                      extInfo:[parameters trochilus_extInfo]
                                                     fileData:[parameters trochilus_fileData]
                                                 platformType:TrochilusPlatformSubTypeWechatSession];
            
        }
        else if (contentType == TrochilusContentTypeImage && [parameters trochilus_emoticonData]) {
            //表情图片
            NSAssert([parameters trochilus_emoticonData], @"emoticonData 不能为空，传表情图片");
            NSData * imageData = [NSData dataWithContentsOfFile:[parameters trochilus_emoticonData]];
            NSArray * thumbData =  [NSMutableArray trochilus_arrayWithImages:[parameters trochilus_thumbImage] isCompress:YES];
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters trochilus_text],
                           @"fileData" : imageData,
                           @"objectType" : @"8",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : kWeChatSDKVer,
                           @"thumbData" : thumbData[0]
                           };
            
        }
        else if (contentType == TrochilusContentTypeFile) {
            //文件 仅微信可用
            NSString * sourceFile = [parameters trochilus_sourceFileData];
            NSData * sourceFileData = [NSData dataWithContentsOfFile:sourceFile];
            
            wechatDic = [TrochilusWeChatPlatform shareWithSourceFileData:sourceFileData
                                                                   title:[parameters trochilus_title]
                                                        shareDescription:[parameters trochilus_text]
                                                                  images:[parameters trochilus_images]
                                                              thumbImage:[parameters trochilus_thumbImage]
                                                     sourceFileExtension:[parameters trochilus_sourceFileExtension]
                                                            platformType:TrochilusPlatformSubTypeWechatSession];
            
        }
        else if (contentType == TrochilusContentTypeMiniProgram) {
            //小程序
            NSArray * thumbData = [NSMutableArray trochilus_arrayWithImages:[parameters trochilus_thumbImage] isCompress:YES];;
            wechatDic =  @{@"appBrandPath" : [parameters trochilus_path],
                           @"appBrandUserName" : [parameters trochilus_userName],
                           @"command" : @"1010",
                           @"description" : [parameters trochilus_descriptions],
                           @"mediaUrl" : [parameters trochilus_url].absoluteString,
                           @"objectType" : @"36",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : kWeChatSDKVer,
                           @"thumbData" : thumbData[0],
                           @"title" : [parameters trochilus_title]
                           };
            
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        
        [UIPasteboard trochilus_setPasteboard:@"content" value:@{[TrochilusPlatformKeys sharedInstance].wechatAppId : wechatDic} encoding:TrochilusPboardEncodingPropertyListSerialization];
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[TrochilusPlatformKeys sharedInstance].wechatAppId];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatUninstalled];
            stateChangedHandler(TrochilusResponseStateFail,nil,err);
        }
        
    }
    
    return nil;
}

//微信朋友圈
+ (NSString *)shareWithWechatTimelineParameters:(NSMutableDictionary *)parameters onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        
        TrochilusContentType platformType = [[parameters trochilus_contentType] integerValue];
        NSDictionary * wechatDic = nil;
        
        if (platformType == TrochilusContentTypeText) {
            //文本
            
            wechatDic = [TrochilusWeChatPlatform shareWithText:[parameters trochilus_text] platformType:TrochilusPlatformSubTypeWechatTimeline];
        }
        else if (platformType == TrochilusContentTypeImage) {
            //图片
            wechatDic = [TrochilusWeChatPlatform shareWithImage:[parameters trochilus_images]
                                                     thumbImage:[parameters trochilus_thumbImage]
                                                   emoticonData:nil
                                               shareDescription:[parameters trochilus_text]
                                                   platformType:TrochilusPlatformSubTypeWechatTimeline];
        }
        else if (platformType == TrochilusContentTypeWebPage) {
            
            //链接
            wechatDic = [TrochilusWeChatPlatform shareWithLink:[parameters trochilus_url].absoluteString
                                                         title:[parameters trochilus_title]
                                              shareDescription:[parameters trochilus_text]
                                                         image:[parameters trochilus_images]
                                                    thumbImage:[parameters trochilus_thumbImage]
                                                  platformType:TrochilusPlatformSubTypeWechatTimeline];
        }
        else if (platformType == TrochilusContentTypeAudio) {
            
            //音频
            wechatDic = [TrochilusWeChatPlatform shareWithAudioUrl:[parameters trochilus_url].absoluteString
                                                             title:[parameters trochilus_title]
                                                  shareDescription:[parameters trochilus_text]
                                                            images:[parameters trochilus_images]
                                                        thumbImage:[parameters trochilus_thumbImage]
                                                      platformType:TrochilusPlatformSubTypeWechatTimeline];
            
        }
        else if (platformType == TrochilusContentTypeVideo) {
            
            //视频
            wechatDic = [TrochilusWeChatPlatform shareWithVideoUrl:[parameters trochilus_url].absoluteString
                                                             title:[parameters trochilus_title]
                                                  shareDescription:[parameters trochilus_text]
                                                            images:[parameters trochilus_images]
                                                        thumbImage:[parameters trochilus_thumbImage]
                                                      platformType:TrochilusPlatformSubTypeWechatTimeline];
            
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        
        [UIPasteboard trochilus_setPasteboard:@"content" value:@{[TrochilusPlatformKeys sharedInstance].wechatAppId : wechatDic} encoding:TrochilusPboardEncodingPropertyListSerialization];
        
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[TrochilusPlatformKeys sharedInstance].wechatAppId];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatUninstalled];
            stateChangedHandler(TrochilusResponseStateFail,nil,err);
        }
        
    }
    
    return nil;
}

//微信收藏
+ (NSString *)shareWithWechatFavParameters:(NSMutableDictionary *)parameters onStateChanged:(TrochilusStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        
        TrochilusContentType contentType = [[parameters trochilus_contentType] integerValue];
        NSDictionary * wechatDic = nil;
        
        if (contentType == TrochilusContentTypeText) {
            
            //文本
            wechatDic = [TrochilusWeChatPlatform shareWithText:[parameters trochilus_text] platformType:TrochilusPlatformSubTypeWechatFav];
        }
        else if (contentType == TrochilusContentTypeImage) {
            //图片
            //这里有个坑参数打印如果是打印剪切板content的话，打印出来的参数不完整，需要使用items打印
            wechatDic = [TrochilusWeChatPlatform shareWithImage:[parameters trochilus_images]
                                                     thumbImage:[parameters trochilus_thumbImage]
                                                   emoticonData:nil
                                               shareDescription:[parameters trochilus_text]
                                                   platformType:TrochilusPlatformSubTypeWechatFav];
            
        }
        else if (contentType == TrochilusContentTypeWebPage) {
            //链接
            
            wechatDic = [TrochilusWeChatPlatform shareWithLink:[parameters trochilus_url].absoluteString
                                                         title:@""
                                              shareDescription:[parameters trochilus_text]
                                                         image:[parameters trochilus_images]
                                                    thumbImage:[parameters trochilus_thumbImage]
                                                  platformType:TrochilusPlatformSubTypeWechatFav];
        }
        else if (contentType == TrochilusContentTypeAudio) {
            
            //音频
            wechatDic = [TrochilusWeChatPlatform shareWithAudioUrl:[parameters trochilus_url].absoluteString
                                                             title:@""
                                                  shareDescription:[parameters trochilus_text]
                                                            images:[parameters trochilus_images]
                                                        thumbImage:[parameters trochilus_thumbImage]
                                                      platformType:TrochilusPlatformSubTypeWechatFav];
        }
        else if (contentType == TrochilusContentTypeVideo) {
            
            //视频
            wechatDic = [TrochilusWeChatPlatform shareWithVideoUrl:[parameters trochilus_url].absoluteString
                                                             title:@""
                                                  shareDescription:[parameters trochilus_text]
                                                            images:[parameters trochilus_images]
                                                        thumbImage:[parameters trochilus_thumbImage]
                                                      platformType:TrochilusPlatformSubTypeWechatFav];
            
        }
        else if (contentType == TrochilusContentTypeFile) {
            //文件 仅微信可用
            //这里有个坑参数打印如果是打印剪切板content的话，打印出来的参数不完整，需要使用items打印
            NSString * sourceFile = [parameters trochilus_sourceFileData];
            NSData * sourceFileData = [NSData dataWithContentsOfFile:sourceFile];
            
            wechatDic = [TrochilusWeChatPlatform shareWithSourceFileData:sourceFileData
                                                                   title:[parameters trochilus_title]
                                                        shareDescription:[parameters trochilus_text]
                                                                  images:[parameters trochilus_images]
                                                              thumbImage:[parameters trochilus_thumbImage]
                                                     sourceFileExtension:[parameters trochilus_sourceFileExtension]
                                                            platformType:TrochilusPlatformSubTypeWechatFav];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        [UIPasteboard trochilus_setPasteboard:@"content" value:@{[TrochilusPlatformKeys sharedInstance].wechatAppId : wechatDic} encoding:TrochilusPboardEncodingPropertyListSerialization];
        
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[TrochilusPlatformKeys sharedInstance].wechatAppId];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatUninstalled];
            stateChangedHandler(TrochilusResponseStateFail,nil,err);
        }
        
    }
    
    return nil;
}

#pragma mark 分享
//文本分享
+ (NSDictionary *)shareWithText:(NSString *)text platformType:(TrochilusPlatformType)platformType {
    
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
    NSDictionary * wechatDic =  @{@"command" : @"1020",
                                  @"result" : @"1",
                                  @"returnFromApp" : @"0",
                                  @"scene" : scene,
                                  @"sdkver" : kWeChatSDKVer,
                                  @"title" : text};
    return wechatDic;
}

//图片分享
+ (NSDictionary *)shareWithImage:(id)image thumbImage:(id)thumbImage emoticonData:(id)emoticonData shareDescription:(NSString *)shareDescription platformType:(TrochilusPlatformType)platformType {
    
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
    
    NSArray * imageArray = [NSMutableArray trochilus_arrayWithImages:image isCompress:NO];
    
    NSArray * thumbData = thumbImage == nil ? [NSMutableArray trochilus_arrayWithImages:image isCompress:YES] : [NSMutableArray trochilus_arrayWithImages:thumbImage isCompress:YES];
    
    NSDictionary * wechatDic =  @{@"command" : @"1010",
                                  @"description" : shareDescription,
                                  @"fileData" : imageArray[0],
                                  @"objectType" : @"2",
                                  @"result" : @"1",
                                  @"returnFromApp" : @"0",
                                  @"scene" : scene,
                                  @"sdkver" : kWeChatSDKVer,
                                  @"thumbData" : thumbData[0]
                                  };
    
//    wechatDic =  @{@"command" : @"1010",
//                   @"description" : [parameters trochilus_text],
//                   @"fileData" : imageData,
//                   @"objectType" : @"8",
//                   @"result" : @"1",
//                   @"returnFromApp" : @"0",
//                   @"scene" : @"0",
//                   @"sdkver" : kWeChatSDKVer,
//                   @"thumbData" : thumbData[0]
//                   };
    
    return wechatDic;
}

//链接分享
+ (NSDictionary *)shareWithLink:(NSString *)url title:(NSString *)title shareDescription:(NSString *)shareDescription image:(id)image thumbImage:(id)thumbImage platformType:(TrochilusPlatformType)platformType {
    
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
    
    //链接
    NSArray * thumbData;
    if (thumbImage == nil && image != nil) {
        //缩略图为空 大图不为空
        thumbData = [NSMutableArray trochilus_arrayWithImages:image isCompress:YES];
    }
    else  {
        //缩略图 或者 没缩略图都走这个
        thumbData = [NSMutableArray trochilus_arrayWithImages:thumbImage isCompress:YES];
    }
    
    NSDictionary * wechatDic =  @{@"command" : @"1010",
                   @"description" : shareDescription,
                   @"thumbData" : thumbData[0],
                   @"mediaUrl" : url,
                   @"objectType" : @"5",
                   @"result" : @"1",
                   @"returnFromApp" : @"0",
                   @"scene" : scene,
                   @"sdkver" : kWeChatSDKVer,
                   @"title" : title
                   };
    
    return wechatDic;
}

+ (NSDictionary *)shareWithAudioUrl:(NSString *)audioUrl title:(NSString *)title shareDescription:(NSString *)shareDescription images:(id)images thumbImage:(id)thumbImage platformType:(TrochilusPlatformType)platformType {
    
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
    
    //音频
    NSArray * thumbData;
    if (thumbImage == nil && images != nil) {
        //缩略图为空 大图不为空
        thumbData = [NSMutableArray trochilus_arrayWithImages:images isCompress:YES];
    }
    else  {
        //缩略图 或者 没缩略图都走这个
        thumbData = [NSMutableArray trochilus_arrayWithImages:thumbImage isCompress:YES];
    }
    
    NSDictionary * wechatDic =  @{@"command" : @"1010",
                   @"description" : shareDescription,
                   @"thumbData" : thumbData[0],
                   @"mediaUrl" : audioUrl,
                   @"objectType" : @"3",
                   @"result" : @"1",
                   @"returnFromApp" : @"0",
                   @"scene" : scene,
                   @"sdkver" : kWeChatSDKVer,
                   @"title" : title
                   };
    
    return wechatDic;
}

+ (NSDictionary *)shareWithVideoUrl:(NSString *)videoUrl title:(NSString *)title shareDescription:(NSString *)shareDescription images:(id)images thumbImage:(id)thumbImage platformType:(TrochilusPlatformType)platformType {
    
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
    
    //音频
    NSArray * thumbData;
    if (thumbImage == nil && images != nil) {
        //缩略图为空 大图不为空
        thumbData = [NSMutableArray trochilus_arrayWithImages:images isCompress:YES];
    }
    else  {
        //缩略图 或者 没缩略图都走这个
        thumbData = [NSMutableArray trochilus_arrayWithImages:thumbImage isCompress:YES];
    }
    
    NSDictionary * wechatDic =  @{@"command" : @"1010",
                                  @"description" : shareDescription,
                                  @"thumbData" : thumbData[0],
                                  @"mediaUrl" : videoUrl,
                                  @"objectType" : @"3",
                                  @"result" : @"1",
                                  @"returnFromApp" : @"0",
                                  @"scene" : scene,
                                  @"sdkver" : kWeChatSDKVer,
                                  @"title" : title
                                  };
    
    return wechatDic;
}

+ (NSDictionary *)shareWithApp:(NSString *)appUrl title:(NSString *)title shareDescription:(NSString *)shareDescription images:(id)images thumbImage:(id)thumbImage extInfo:(NSString *)extInfo fileData:(id)fileData platformType:(TrochilusPlatformType)platformType {
    
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
    
    NSArray * thumbData;
    if (thumbImage == nil && images != nil) {
        //缩略图为空 大图不为空
        thumbData = [NSMutableArray trochilus_arrayWithImages:images isCompress:YES];
    }
    else  {
        //缩略图 或者 没缩略图都走这个
        thumbData = [NSMutableArray trochilus_arrayWithImages:thumbImage isCompress:YES];
    }
    
    NSDictionary * wechatDic =  @{@"command" : @"1010",
                                  @"description" : shareDescription,
                                  @"thumbData" : thumbData[0],
                                  @"mediaUrl" : appUrl,
                                  @"objectType" : @"7",
                                  @"result" : @"1",
                                  @"returnFromApp" : @"0",
                                  @"scene" : scene,
                                  @"sdkver" : kWeChatSDKVer,
                                  @"title" : title,
                                  @"extInfo" : extInfo,
                                  @"fileData" : fileData
                                  };
    
    return wechatDic;
    
}

+ (NSDictionary *)shareWithSourceFileData:(NSData *)sourceFileData title:(NSString *)title shareDescription:(NSString *)shareDescription images:(id)images thumbImage:(id)thumbImage sourceFileExtension:(NSString *)sourceFileExtension platformType:(TrochilusPlatformType)platformType {
    
    //文件 仅微信可用
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

    NSArray * thumbData;
    if (thumbImage == nil && images != nil) {
        //缩略图为空 大图不为空
        thumbData = [NSMutableArray trochilus_arrayWithImages:images isCompress:YES];
    }
    else  {
        //缩略图 或者 没缩略图都走这个
        thumbData = [NSMutableArray trochilus_arrayWithImages:thumbImage isCompress:YES];
    }
    
//    NSString * sourceFile = [parameters trochilus_sourceFileData];
//    NSData * sourceFileData = [NSData dataWithContentsOfFile:sourceFile];
    
    NSDictionary * wechatDic =  @{@"command" : @"1010",
                                  @"fileData" : sourceFileData,
                                  @"objectType" : @"6",
                                  @"result" : @"1",
                                  @"returnFromApp" : @"0",
                                  @"scene" : scene,
                                  @"sdkver" : kWeChatSDKVer,
                                  @"thumbData" : thumbData[0],
                                  @"fileExt" : sourceFileExtension,
                                  @"title" : title,
                                  @"description" : shareDescription
                                  };
    return wechatDic;
    
}

#pragma mark- 授权登录
+ (NSMutableString *)authorizeWithWeChatPlatformSettings:(NSDictionary *)settings
                                          onStateChanged:(TrochilusAuthorizeStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusPlatformKeys sharedInstance].wechatAppId length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppIdNotFound];
        
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        return nil;
    }
    else if ([[TrochilusPlatformKeys sharedInstance].wechatAppSecret length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppSecretNotFound];
        
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].authorizestateChangedHandler = stateChangedHandler;
    }
    
    //获取setting参数 用户有配置就用用户的，没配置就默认
    NSString * scopes = @"snsapi_userinfo";
    if (settings && settings[@"TAuthSettingKeyScopes"] != nil) {
        if ([settings[@"TAuthSettingKeyScopes"] isKindOfClass:[NSArray class]]) {
            //如果格式不对也不处理，使用默认
            scopes = [(NSArray *)settings[@"TAuthSettingKeyScopes"] componentsJoinedByString:@","];
        }
    }
    
    //    weixin://app/wx4868b35061f87885/auth/?scope=snsapi_userinfo&state=1499220438
    NSString * timeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSMutableString * wechatAuthorize = [[NSMutableString alloc] initWithString:@"weixin://app/"];
    [wechatAuthorize appendFormat:@"%@/",[TrochilusPlatformKeys sharedInstance].wechatAppId];
    [wechatAuthorize appendFormat:@"auth/?scope=%@",scopes];
    [wechatAuthorize appendFormat:@"&state=%@",timeInterval];
    
    return wechatAuthorize;
    
}

//获取微信access_token
+ (void)getOpenIdToCode:(NSString *)code appId:(NSString *)appId secret:(NSString *)secret {
    
    //微信access_token
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appId,secret,code];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (userInfo[@"errcode"] != nil) {
                //失败
                NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAuthorizeFail userInfo:userInfo];
                
                [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
                
            }
            else {
                
                __block TrochilusUser * user = [[TrochilusUser alloc] init];
                user.accessToken = userInfo[@"access_token"];
                user.unionId = userInfo[@"unionid"];
                user.uid = userInfo[@"unionid"];
                user.openid = userInfo[@"openid"];
                user.refreshToken = userInfo[@"refresh_token"];
                
                [TrochilusWeChatPlatform geTrochilusUserInfoToWechatAccessToken:user.accessToken openid:user.openid completion:^(NSDictionary *userInfoDic) {
                    
                    user.originalResponse = userInfoDic;
                    user.name = userInfoDic[@"nickname"];
                    user.iconurl = userInfoDic[@"headimgurl"];
                    user.unionGender = [userInfoDic[@"sex"] integerValue] == 1 ? @"男" : @"女";
                    user.gender = [NSString stringWithFormat:@"%ld",[userInfoDic[@"sex"] integerValue]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateSuccess userInfo:user error:nil];
                    });
                }];
            }
            
            NSLog(@"%@",userInfo);
            
        }
        else {
            
            //授权失败
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:error.userInfo];
            [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
            
        }
        
    }];
    [task resume];
    
}

//获取微信用户信息
+ (void)geTrochilusUserInfoToWechatAccessToken:(NSString *)accessToken openid:(NSString *)openid completion:(void (^ __nullable)(NSDictionary * userInfoDic))completion {
    
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN
    NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN",accessToken,openid];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (userInfo[@"errcode"] != nil) {
                //失败
                
                NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:userInfo];
                [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
                
            }
            else{
                //成功
                
                if (completion) {
                    completion(userInfo);
                }
                
            }
        }
        else {
            //失败
            
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWeiboAuthorizeFail userInfo:error.userInfo];
            [TrochilusWeChatPlatform authorizeResponseWithState:TrochilusResponseStateFail userInfo:nil error:err];
            
        }
        
    }];
    [task resume];
    
}

#pragma mark- 微信支付
+ (NSString *)payToWechatParameters:(NSDictionary *)parameters onStateChanged:(TrochilusPayStateChangedHandler)stateChangedHandler {
    
    if ([[TrochilusPlatformKeys sharedInstance].wechatAppId length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppIdNotFound];
        
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    else if ([[TrochilusPlatformKeys sharedInstance].wechatAppSecret length] == 0) {
        
        NSError * error = [TrochilusError errorWithCode:TrochilusErrorCodeWechatAppSecretNotFound];
        
        stateChangedHandler(TrochilusResponseStateFail,nil,error);
        
        return nil;
    }
    
    if (stateChangedHandler) {
        [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler = stateChangedHandler;
    }
    
    //生成URLscheme
    //    NSString *str = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",appid,nonceStr,partnerId,prepayId,[NSString stringWithFormat:@"%d",[timeStamp intValue] ],sign];
    
    if ([TrochilusWeChatPlatform isWeChatInstalled]) {
        NSString * partnerId = parameters[@"partnerId"];
        NSString * prepayId = parameters[@"prepayId"];
        NSString * nonceStr = parameters[@"nonceStr"];
        NSString * timeStamp = parameters[@"timeStamp"];
        
        //    NSString * package = parameters[@"package"];
        NSString * sign = parameters[@"sign"];
        
        //判断是否有appid，如果字典里有appid使用字典里的，没有就看看是否有注册
        NSString * wechatAppId = parameters[@"appId"];
        if (wechatAppId == nil && [TrochilusPlatformKeys sharedInstance].wechatAppId == nil) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请注册微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return @"";
        }
        NSString * wechatPayInfo = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",[TrochilusPlatformKeys sharedInstance].wechatAppId,nonceStr,partnerId,prepayId,timeStamp,sign];
        
        return wechatPayInfo;
    }
    else {
        if (stateChangedHandler) {
            NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatUninstalled];
            stateChangedHandler(TrochilusResponseStateFail,nil,err);
        }
    }
    
    return nil;
    
}

#pragma mark- 回调
+ (BOOL)handleUrlWithWeChat:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"wx"]) {
        
        if ([url.absoluteString rangeOfString:@"://oauth"].location != NSNotFound) {
            //微信登录
            NSDictionary * wechat = [NSMutableDictionary trochilus_dictionaryWithUrl:url];
            
            [TrochilusWeChatPlatform getOpenIdToCode:wechat[@"code"] appId:[TrochilusPlatformKeys sharedInstance].wechatAppId secret:[TrochilusPlatformKeys sharedInstance].wechatAppSecret];
            
        }
        else if ([url.absoluteString rangeOfString:@"://pay/"].location != NSNotFound) {
            //微信支付
            NSDictionary * wechat = [NSMutableDictionary trochilus_dictionaryWithUrl:url];
            if ([wechat[@"ret"] integerValue] == 0) {
                //支付成功
                if ([TrochilusWeChatPlatform sharedInstance].payStateChangedHandler) {
                    [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler(TrochilusResponseStateSuccess, nil, nil);
                }
            }else if ([wechat[@"ret"] integerValue] == -2){
                //用户点击取消并返回
                if ([TrochilusWeChatPlatform sharedInstance].payStateChangedHandler) {
                    [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler(TrochilusResponseStateCancel, nil, nil);
                }
            }
            else {
                //支付失败
                if ([TrochilusWeChatPlatform sharedInstance].payStateChangedHandler) {
                    
                    NSError * err = [TrochilusError errorWithCode:TrochilusErrorCodeWechatPayFail userInfo:wechat];
                    [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler(TrochilusResponseStateFail, nil, err);
                }
                
            }
            [TrochilusWeChatPlatform sharedInstance].payStateChangedHandler = nil;
        }
        else {
            //分享
            //获取剪切板内容
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
            NSLog(@"%@",pasteboard.pasteboardTypes);
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
            NSLog(@"%@",wechatInfo);
            
            //获取微信返回值
            NSDictionary * wechatResponse = wechatInfo[[TrochilusPlatformKeys sharedInstance].wechatAppId];
            
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
        if (self.payStateChangedHandler) {
            //调用自己的服务器去查询支付结果
            self.payStateChangedHandler(TrochilusResponseStatePayWait, nil, nil);
            self.payStateChangedHandler = nil;
        }
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

@end


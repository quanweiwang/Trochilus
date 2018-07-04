//
//  NSMutableDictionary+Share.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSMutableDictionary+TrochilusShare.h"
#import "TrochilusMessageObject.h"

@implementation NSMutableDictionary (TrochilusShare)
#pragma mark- 通用分享参数
/**
 *  设置分享参数
 *
 *  @param text     文本
 *  @param images   图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage。如: @"http://www.mob.com/images/logo_black.png" 或 @[@"http://www.mob.com/images/logo_black.png"]
 *  @param url      网页路径/应用路径
 *  @param title    标题
 *  @param type     分享类型
 */
- (void)trochilus_SetupShareParamsByText:(NSString *)text
                         images:(id)images
                            url:(NSURL *)url
                          title:(NSString *)title
                           type:(TrochilusContentType)type {
    
    //文本
    if (text) {
        [self setObject:text forKey:@"Text"];
    }
    
    //图片
    if (images) {
        [self setObject:images forKey:@"Images"];
    }
    
    //网页路径/应用路径
    if (url) {
        [self setObject:url forKey:@"URL"];
    }
    
    //标题
    if (title) {
        [self setObject:title forKey:@"Title"];
    }
    
    //分享类型
    if (type) {
        [self setObject:@(type) forKey:@"ContentType"];
    }
    
}

#pragma mark- QQ
/**
 *  设置QQ分享参数
 *
 *  @param text            分享内容
 *  @param title           分享标题
 *  @param url             分享链接(如果分享类型为音频/视频时,应该传入音频/视频的网络URL地址)
 [特别说明:分享视频到QZone时,视频为网络视频,请传入视频网络URL地址;视频为本地视频的,请传入来源于手机系统相册的相关的Asset URL地址]
 *  @param audioFlashURL   分享音频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Audio时生效
 *  @param videoFlashURL   分享视频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Video时生效
 *  @param thumbImage      缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 *  @param images          图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 QQ会采用首张图片，QZone则支持图片数组
 *  @param type            分享类型, 仅支持Text、Image、WebPage、Audio、Video类型
 *  @param platformSubType 平台子类型，只能传入TPlatformSubTypeQZone或者TPlatformSubTypeQQFriend其中一个
 */
- (void)trochilus_SetupQQParamsByText:(NSString *)text
                       title:(NSString *)title
                         url:(NSString *)url
               audioFlashURL:(NSString *)audioFlashURL
               videoFlashURL:(NSString *)videoFlashURL
                  thumbImage:(id)thumbImage
                      images:(id)images
                        type:(TrochilusContentType)type
          forPlatformSubType:(TrochilusPlatformType)platformSubType {
    
    //文本
    if (text) {
        [self setObject:text forKey:@"Text"];
    }
    
    //标题
    if (title) {
        [self setObject:title forKey:@"Title"];
    }
    
    //分享链接(如果分享类型为音频/视频时,应该传入音频/视频的网络URL地址)
    //[特别说明:分享视频到QZone时,视频为网络视频,请传入视频网络URL地址;视频为本地视频的,请传入来源于手机系统相册的相关的Asset URL地址]
    if (url) {
        [self setObject:url forKey:@"URL"];
    }
    
    //分享音频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Audio时生效
    if (audioFlashURL && platformSubType == TrochilusPlatformSubTypeQQFriend && type == TrochilusContentTypeAudio) {
        [self setObject:audioFlashURL forKey:@"AudioFlashURL"];
    }
    
    //分享视频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Video时生效
    if (videoFlashURL && platformSubType == TrochilusPlatformSubTypeQQFriend && type == TrochilusContentTypeVideo) {
        [self setObject:videoFlashURL forKey:@"VideoFlashURL"];
    }
    
    //缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
    if (thumbImage) {
        [self setObject:thumbImage forKey:@"ThumbImage"];
    }
    
    //图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImageQQ会采用首张图片，QZone则支持图片数组
    if (images) {
        [self setObject:images forKey:@"Images"];
    }
    
    //分享类型, 仅支持Text、Image、WebPage、Audio、Video类型
    if (type) {
        [self setObject:@(type) forKey:@"ContentType"];
    }
    
    //平台子类型，只能传入TPlatformSubTypeQZone或者TPlatformSubTypeQQFriend其中一个
    if (platformSubType) {
        [self setObject:@(platformSubType) forKey:@"PlatformSubType"];
    }
    
    
}
#pragma mark- QZone
/**
 *  设置QQ分享参数
 *
 *  @param text            分享内容
 *  @param title           分享标题
 *  @param url             分享链接(如果分享类型为音频/视频时,应该传入音频/视频的网络URL地址)
 [特别说明:分享视频到QZone时,视频为网络视频,请传入视频网络URL地址;视频为本地视频的,请传入来源于手机系统相册的相关的Asset URL地址]
 *  @param audioFlashURL   分享音频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Audio时生效
 *  @param videoFlashURL   分享视频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Video时生效
 *  @param thumbImage      缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 *  @param images          图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 QQ会采用首张图片，QZone则支持图片数组
 *  @param type            分享类型, 仅支持Text、Image、WebPage、Audio、Video类型
 *  @param platformSubType 平台子类型，只能传入TPlatformSubTypeQZone或者TPlatformSubTypeQQFriend其中一个
 */
- (void)trochilus_SetupQZoneParamsByText:(NSString *)text
                          title:(NSString *)title
                            url:(NSURL *)url
                  audioFlashURL:(NSURL *)audioFlashURL
                  videoFlashURL:(NSURL *)videoFlashURL
                     thumbImage:(id)thumbImage
                         images:(id)images
                           type:(TrochilusContentType)type
             forPlatformSubType:(TrochilusPlatformType)platformSubType {
    
    //文本
    if (text) {
        [self setObject:text forKey:@"Text"];
    }
    
    //标题
    if (title) {
        [self setObject:title forKey:@"Title"];
    }
    
    //分享链接(如果分享类型为音频/视频时,应该传入音频/视频的网络URL地址)
    //[特别说明:分享视频到QZone时,视频为网络视频,请传入视频网络URL地址;视频为本地视频的,请传入来源于手机系统相册的相关的Asset URL地址]
    if (url) {
        [self setObject:url forKey:@"URL"];
    }
    
    //分享音频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Audio时生效
    if (audioFlashURL && platformSubType == TrochilusPlatformSubTypeQQFriend && type == TrochilusContentTypeAudio) {
        [self setObject:audioFlashURL forKey:@"AudioFlashURL"];
    }
    
    //分享视频时缩略图播放源,仅平台子类型为TPlatformSubTypeQQFriend,且分享类型为Video时生效
    if (videoFlashURL && platformSubType == TrochilusPlatformSubTypeQQFriend && type == TrochilusContentTypeVideo) {
        [self setObject:videoFlashURL forKey:@"VideoFlashURL"];
    }
    
    //缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
    if (thumbImage) {
        [self setObject:thumbImage forKey:@"ThumbImage"];
    }
    
    //图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImageQQ会采用首张图片，QZone则支持图片数组
    if (images) {
        [self setObject:images forKey:@"Images"];
    }
    
    //分享类型, 仅支持Text、Image、WebPage、Audio、Video类型
    if (type) {
        [self setObject:@(type) forKey:@"ContentType"];
    }
    
    //平台子类型，只能传入TPlatformSubTypeQZone或者TPlatformSubTypeQQFriend其中一个
    if (platformSubType) {
        [self setObject:@(platformSubType) forKey:@"PlatformSubType"];
    }
    
    
}

#pragma mark 微信分享参数
/**
 *  设置微信分享参数
 *
 *  @param text         文本
 *  @param title        标题
 *  @param url          分享链接
 *  @param thumbImage   缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 *  @param image        图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 *  @param musicFileURL 音乐文件链接地址
 *  @param extInfo      扩展信息
 *  @param fileData     文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）
 *  @param emoticonData 表情数据，可以为NSData、UIImage、NSURL（文件路径）
 *  @param type         分享类型，支持TrochilusContentTypeText、TrochilusContentTypeImage、TrochilusContentTypeWebPage、TrochilusContentTypeApp、TrochilusContentTypeAudio和TrochilusContentTypeVideo
 *  @param platformSubType 平台子类型，只能传入TrochilusPlatformSubTypeWechatSession、TrochilusPlatformSubTypeWechatTimeline和TrochilusPlatformSubTypeWechatFav其中一个
 *
 *  分享文本时：
 *  设置type为TrochilusContentTypeText, 并填入text参数
 *
 *  分享图片时：
 *  设置type为TrochilusContentTypeImage, 非gif图片时：填入title和image参数，如果为gif图片则需要填写title和emoticonData参数
 *
 *  分享网页时：
 *  设置type为TrochilusContentTypeWebPage, 并设置text、title、url以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作。
 *
 *  分享应用时：
 *  设置type为TrochilusContentTypeApp，并设置text、title、extInfo（可选）以及fileData（可选）参数。
 *
 *  分享音乐时：
 *  设置type为TrochilusContentTypeAudio，并设置text、title、url以及musicFileURL（可选）参数。
 *
 *  分享视频时：
 *  设置type为TrochilusContentTypeVideo，并设置text、title、url参数
 */
- (void)trochilus_SetupWeChatParamsByText:(NSString *)text
                                    title:(NSString *)title
                                      url:(NSString *)url
                             mediaTagName:(NSString *)mediaTagName
                            messageAction:(NSString *)messageAction
                               thumbImage:(id)thumbImage
                                    image:(id)image
                             musicFileURL:(NSString *)musicFileURL
                                  extInfo:(NSString *)extInfo
                                 fileData:(id)fileData
                            fileExtension:(NSString *)fileExtension
                             emoticonData:(id)emoticonData
                                     type:(TrochilusContentType)type {
    
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.text = text;
    message.title = title;
    message.url = url;
    message.mediaTagName = mediaTagName;
    message.messageAction = messageAction;
    message.thumbImage = thumbImage;
    message.image = image;
    message.mediaUrl = musicFileURL;
    message.extInfo = extInfo;
    message.fileData = fileData;
    message.emoticonData = emoticonData;
    message.fileExtension = fileExtension;
    message.emoticonData = emoticonData;
    message.contentType = type;
    
    [self setObject:message forKey:@"TrochilusMessageObject"];

}

/**
 设置微信小程序分享

 @param webpageUrl 网址（6.5.6以下版本微信会自动转化为分享链接 必填）
 @param userName 小程序的userName （必填）
 @param path 跳转到页面路径
 @param title 标题
 @param description 详细说明
 @param thumbImage 缩略图 （必填）, 旧版微信客户端（6.5.8及以下版本）小程序类型消息卡片使用小图卡片样式 要求图片数据小于32k
 @param hdImageData 高清缩略图，建议长宽比是 5:4 ,6.5.9及以上版本微信客户端小程序类型分享使用 要求图片数据小于128k
 @param withShareTicket 是否使用带 shareTicket 的转发
 @param programType 分享小程序的版本（0-正式，1-开发，2-体验）
 */
- (void)trochilus_SetupWeChatMiniProgramShareParamsByWebpageUrl:(NSString *)webpageUrl
                                                       userName:(NSString *)userName
                                                           path:(NSString *)path
                                                          title:(NSString *)title
                                                    description:(NSString *)description
                                                     thumbImage:(UIImage *)thumbImage
                                                    hdImageData:(UIImage *)hdImageData
                                                withShareTicket:(BOOL)withShareTicket
                                                    contentType:(TrochilusContentType)contentType
                                                miniProgramType:(TrochilusMiniProgramType)programType {
    
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    
    message.url = webpageUrl;
    message.userName = userName;
    message.path = path;
    message.title = title;
    message.text = description;
    message.thumbImage = thumbImage;
    message.image = hdImageData;
    message.withShareTicket = withShareTicket == YES ? @"1" : @"0";
    message.miniProgramType = programType;
    message.contentType = contentType;
    
    [self setObject:message forKey:@"TrochilusMessageObject"];
}

#pragma mark- 新浪微博
/**
 *  设置新浪微博分享参数
 *
 *  @param text      文本
 *  @param title     标题
 *  @param image     图片对象，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 *  @param url       分享链接
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param objectID  对象ID，标识系统内内容唯一性，应传入系统中分享内容的唯一标识，没有时可以传入nil
 *  @param type      分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
 */
- (void)trochilus_SetupSinaWeiboShareParamsByText:(NSString *)text
                                   title:(NSString *)title
                                   image:(id)image
                                     url:(NSString *)url
                                latitude:(double)latitude
                               longitude:(double)longitude
                                objectID:(NSString *)objectID
                                    type:(TrochilusContentType)type {
    
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.text = text;
    message.title = title;
    message.image = image;
    message.url = url;
    message.latitude = latitude;
    message.longitude = longitude;
    message.objectID = objectID;
    message.contentType = type;
    
    [self setObject:message forKey:@"TrochilusMessageObject"];
    
//    if (text) {
//        [self setObject:text forKey:@"Text"];
//    }
//    
//    if (title) {
//        [self setObject:title forKey:@"Title"];
//    }
//    
//    if (image) {
//        [self setObject:image forKey:@"Images"];
//    }
//    
//    if (url) {
//        [self setObject:url forKey:@"URL"];
//    }
//    
//    if (latitude) {
//        [self setObject:@(latitude) forKey:@"Latitude"];
//    }
//    
//    if (longitude) {
//        [self setObject:@(longitude) forKey:@"Longitude"];
//    }
//    
//    if (objectID) {
//        [self setObject:objectID forKey:@"objectID"];
//    }
//    
//    if (type) {
//        [self setObject:@(type) forKey:@"ContentType"];
//    }
    
}

#pragma mark- 通过key获取Value
//文本
- (NSString *)trochilus_text {
    
    return [self objectForKey:@"Text"];
}

- (NSString *)trochilus_title {
    
    return [self objectForKey:@"Title"];
}

- (NSString *)trochilus_path {
    
    return [self objectForKey:@"Path"];
}

- (NSString *)trochilus_userName {
    return [self objectForKey:@"UserName"];
}

- (NSString *)trochilus_url {
    return [self objectForKey:@"URL"];
}

- (NSString *)trochilus_withShareTicket {
    
    return [self objectForKey:@"WithShareTicket"];
}

- (NSNumber *)trochilus_miniProgramType {
    
    return [self objectForKey:@"MiniProgramType"];
}

- (NSNumber *)trochilus_platformSubType {
    return [self objectForKey:@"PlatformSubType"];
}

- (NSNumber *)trochilus_contentType {
    return [self objectForKey:@"ContentType"];
}

- (NSString *)trochilus_mediaTagName {
    return [self objectForKey:@"MediaTagName"];
}

- (id)trochilus_images {
    return [self objectForKey:@"Images"];
}

- (id)trochilus_thumbImage {
    return [self objectForKey:@"ThumbImage"];
}

- (NSString *)trochilus_extInfo {
    return [self objectForKey:@"ExtInfo"];
}

- (id)trochilus_fileData {
    return [self objectForKey:@"FileData"];
}

- (id)trochilus_sourceFileData {
    return [self objectForKey:@"SourceFileData"];
}

- (NSString *)trochilus_sourceFileExtension {
    return [self objectForKey:@"SourceFileExtension"];
}

- (id)trochilus_emoticonData {
    return [self objectForKey:@"EmoticonData"];
}

+(NSMutableDictionary *)trochilus_dictionaryWithUrl:(NSURL*)url {
    
    
    NSString * urlString = [[url query] isEqualToString:@""] ? [url absoluteString] : [url query];
    
    //QQ 网页授权返回url格式有# 所以要处理下
    //auth://www.qq.com?#access_token=68656BB22C0699511CE047EAF2624619&expires_in=7776000&openid=039015BD8F609BD51FFF4B820B50FC50&pay_token=BC389EC1E6B05EFB82A9AA996217826E&state=test&ret=0&pf=openmobile_ios&pfkey=aa3cb964950d309e47ad8c751123f11f&auth_time=1499929922100&page_type=1
    urlString = [urlString stringByReplacingOccurrencesOfString:@"auth://www.qq.com?#" withString:@""];
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSRange range=[keyValuePair rangeOfString:@"="];
        [queryStringDictionary setObject:range.length>0?[keyValuePair substringFromIndex:range.location+1]:@"" forKey:(range.length?[keyValuePair substringToIndex:range.location]:keyValuePair)];
    }
    return queryStringDictionary;
}

@end

//
//  NSMutableDictionary+Share.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrochilusTypeDefine.h"

@interface NSMutableDictionary (TrochilusShare)

/**
 *  设置分享参数 通用分享
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
                           type:(TrochilusContentType)type;

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
                         url:(NSURL *)url
               audioFlashURL:(NSURL *)audioFlashURL
               videoFlashURL:(NSURL *)videoFlashURL
                  thumbImage:(id)thumbImage
                      images:(id)images
                        type:(TrochilusContentType)type
          forPlatformSubType:(TrochilusPlatformType)platformSubType;

/**
 *  设置微信分享参数
 *
 *  @param text         文本
 *  @param title        标题
 *  @param url          分享链接
 *  @param thumbImage   缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 *  @param image        图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、TImage
 *  @param musicFileURL 音乐文件链接地址
 *  @param extInfo      扩展信息
 *  @param fileData     文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）、TData、TImage
 *  @param emoticonData 表情数据，可以为NSData、UIImage、NSURL（文件路径）、TData、TImage
 *  @param type         分享类型，支持TContentTypeText、TContentTypeImage、TContentTypeWebPage、TContentTypeApp、TContentTypeAudio和TContentTypeVideo
 *  @param platformSubType 平台子类型，只能传入TPlatformSubTypeWechatSession、TPlatformSubTypeWechatTimeline和TPlatformSubTypeWechatFav其中一个
 *
 *  分享文本时：
 *  设置type为TContentTypeText, 并填入text参数
 *
 *  分享图片时：
 *  设置type为TContentTypeImage, 非gif图片时：填入title和image参数，如果为gif图片则需要填写title和emoticonData参数
 *
 *  分享网页时：
 *  设置type为TContentTypeWebPage, 并设置text、title、url以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作。
 *
 *  分享应用时：
 *  设置type为TContentTypeApp，并设置text、title、extInfo（可选）以及fileData（可选）参数。
 *
 *  分享音乐时：
 *  设置type为TContentTypeAudio，并设置text、title、url以及musicFileURL（可选）参数。
 *
 *  分享视频时：
 *  设置type为TContentTypeVideo，并设置text、title、url参数
 */
- (void)trochilus_SetupWeChatParamsByText:(NSString *)text
                           title:(NSString *)title
                             url:(NSURL *)url
                      thumbImage:(id)thumbImage
                           image:(id)image
                    musicFileURL:(NSURL *)musicFileURL
                         extInfo:(NSString *)extInfo
                        fileData:(id)fileData
                    emoticonData:(id)emoticonData
             sourceFileExtension:(NSString *)fileExtension
                  sourceFileData:(id)sourceFileData
                            type:(TrochilusContentType)type
              forPlatformSubType:(TrochilusPlatformType)platformSubType;

/**
 设置微信小程序分享
 
 @param title 标题
 @param description 详细说明
 @param webpageUrl 网址（6.5.6以下版本微信会自动转化为分享链接 必填）
 @param path 跳转到页面路径
 @param thumbImage 缩略图 （必填）, 旧版微信客户端（6.5.8及以下版本）小程序类型消息卡片使用小图卡片样式 要求图片数据小于32k
 @param hdThumbImage 高清缩略图，建议长宽比是 5:4 ,6.5.9及以上版本微信客户端小程序类型分享使用 要求图片数据小于128k
 @param userName 小程序的userName （必填）
 @param withShareTicket 是否使用带 shareTicket 的转发
 @param type 分享小程序的版本（0-正式，1-开发，2-体验）
 @param platformSubType 分享自平台 微信小程序暂只支持 TrochilusPlatformSubTypeWechatSession（微信好友分享）
 */
- (void)trochilus_SetupWeChatMiniProgramShareParamsByTitle:(NSString *)title
                                         description:(NSString *)description
                                          webpageUrl:(NSURL *)webpageUrl
                                                path:(NSString *)path
                                          thumbImage:(id)thumbImage
                                        hdThumbImage:(id)hdThumbImage
                                            userName:(NSString *)userName
                                     withShareTicket:(BOOL)withShareTicket
                                     miniProgramType:(NSUInteger)type
                                  forPlatformSubType:(TrochilusPlatformType)platformSubType;

/**
 *  设置新浪微博分享参数
 *
 *  @param text      文本
 *  @param title     标题
 *  @param image     图片对象，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param url       分享链接
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param objectID  对象ID，标识系统内内容唯一性，应传入系统中分享内容的唯一标识，没有时可以传入nil
 *  @param type      分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
 */
- (void)trochilus_SetupSinaWeiboShareParamsByText:(NSString *)text
                                   title:(NSString *)title
                                   image:(id)image
                                     url:(NSURL *)url
                                latitude:(double)latitude
                               longitude:(double)longitude
                                objectID:(NSString *)objectID
                                    type:(TrochilusContentType)type;

- (NSString *)trochilus_text;
- (NSString *)trochilus_title;
- (NSURL *)trochilus_url;
- (NSURL *)trochilus_audioFlashURL;
- (NSURL *)trochilus_videoFlashURL;
- (id )trochilus_thumbImage;
- (id )trochilus_images;
- (NSNumber *)trochilus_contentType;
- (NSNumber *)trochilus_platformSubType;
- (NSString *)trochilus_extInfo;
- (id)trochilus_fileData;
- (id)trochilus_emoticonData;
- (NSString *)trochilus_sourceFileExtension;
- (id)trochilus_sourceFileData;
- (NSString *)trochilus_userName;
- (NSString *)trochilus_path;
- (NSString *)trochilus_descriptions;
+(NSMutableDictionary *)trochilus_dictionaryWithUrl:(NSURL*)url;


@end

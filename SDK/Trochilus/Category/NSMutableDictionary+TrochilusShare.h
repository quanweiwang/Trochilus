//
//  NSMutableDictionary+Share.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrochilusTypeDefine.h"

@interface NSMutableDictionary (TrochilusShare)

/**
 *  设置分享参数 通用分享
 *
 *  @param text     文本
 *  @param images   图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage
 *  @param url      网页路径/应用路径
 *  @param title    标题
 *  @param type     分享类型
 */
- (void)trochilusSetShareParamsByText:(NSString *)text
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
 *  @param audioFlashURL   分享音频时缩略图播放源,仅平台子类型为TrochilusPlatformSubTypeQQFriend,且分享类型为Audio时生效
 *  @param videoFlashURL   分享视频时缩略图播放源,仅平台子类型为TrochilusPlatformSubTypeQQFriend,且分享类型为Video时生效
 *  @param thumbImage      缩略图，可以为UIImage
 *  @param images          图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage
 QQ会采用首张图片，QZone则支持图片数组
 *  @param type            分享类型, 仅支持Text、Image、WebPage、Audio、Video类型
 *  @param platformSubType 平台子类型，只能传入TrochilusPlatformSubTypeQZone或者TrochilusPlatformSubTypeQQFriend其中一个
 */
- (void)trochilusSetQQParamsByText:(NSString *)text
                       title:(NSString *)title
                         url:(NSString *)url
               audioFlashURL:(NSString *)audioFlashURL
               videoFlashURL:(NSString *)videoFlashURL
                  thumbImage:(UIImage *)thumbImage
                      images:(id)images
                        type:(TrochilusContentType)type
          forPlatformSubType:(TrochilusPlatformType)platformSubType;

/**
 *  设置微信分享参数
 *
 *  @param text         文本
 *  @param title        标题
 *  @param url          分享链接
 *  @param thumbImage   缩略图，可以为UIImage
 *  @param image        图片，可以为UIImage
 *  @param musicFileURL 音乐文件链接地址
 *  @param extInfo      扩展信息
 *  @param fileData     文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）
 *  @param emoticonData 表情数据，可以为NSData、UIImage、NSURL（文件路径）
 *  @param type         分享类型，支持TrochilusContentTypeText、TrochilusContentTypeImage、TrochilusContentTypeWebPage、TrochilusContentTypeApp、TrochilusContentTypeAudio和TrochilusContentTypeVideo
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
- (void)trochilusSetWeChatParamsByText:(NSString *)text
                                    title:(NSString *)title
                                      url:(NSString *)url
                             mediaTagName:(NSString *)mediaTagName
                            messageAction:(NSString *)messageAction
                               thumbImage:(UIImage *)thumbImage
                                    image:(UIImage *)image
                             musicFileURL:(NSString *)musicFileURL
                                  extInfo:(NSString *)extInfo
                                 fileData:(id)fileData
                            fileExtension:(NSString *)fileExtension
                             emoticonData:(id)emoticonData
                                     type:(TrochilusContentType)type;

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
- (void)trochilusSetWeChatMiniProgramShareParamsByWebpageUrl:(NSString *)webpageUrl
                                                       userName:(NSString *)userName
                                                           path:(NSString *)path
                                                          title:(NSString *)title
                                                    description:(NSString *)description
                                                     thumbImage:(UIImage *)thumbImage
                                                    hdThumImage:(UIImage *)hdThumImage
                                                withShareTicket:(BOOL)withShareTicket
                                                    contentType:(TrochilusContentType)contentType
                                                miniProgramType:(TrochilusMiniProgramType)programType;

/**
 *  设置新浪微博分享参数
 *
 *  @param text      文本
 *  @param title     标题
 *  @param image     图片对象，可以为UIImage、NSString（图片路径）、NSURL（图片路径) 必须小于32k 大于将自动进行压缩
 *  @param url       分享链接
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param objectID  对象ID，标识系统内内容唯一性，应传入系统中分享内容的唯一标识，没有时可以传入nil
 *  @param type      分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
 */
- (void)trochilusSetSinaWeiboShareParamsByText:(NSString *)text
                                   title:(NSString *)title
                                   image:(UIImage *)image
                                     url:(NSString *)url
                                latitude:(double)latitude
                               longitude:(double)longitude
                                objectID:(NSString *)objectID
                                    type:(TrochilusContentType)type;




@end

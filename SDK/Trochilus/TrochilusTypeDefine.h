//
//  TrochilusTypeDefine.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TrochilusUser.h"

#ifndef TrochilusTypeDefine_h
#define TrochilusTypeDefine_h

#define weChat      @"WeChat"
#define qq          @"QQ"
#define sinaWeiBo   @"SinaWeiBo"

/**
 *  结合SSO和Web授权方式
 */
extern NSString *const TAuthTypeBoth;
/**
 *  SSO授权方式
 */
extern NSString *const TAuthTypeSSO;
/**
 *  网页授权方式
 */
extern NSString *const TAuthTypeWeb;

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, TrochilusContentType){
    
    /**
     *  自动适配类型，视传入的参数来决定
     */
    TrochilusContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    TrochilusContentTypeText         = 1,
    
    /**
     *  图片
     */
    TrochilusContentTypeImage        = 2,
    
    /**
     *  网页
     */
    TrochilusContentTypeWebPage      = 3,
    
    /**
     *  应用
     */
    TrochilusContentTypeApp          = 4,
    
    /**
     *  音频
     */
    TrochilusContentTypeAudio        = 5,
    
    /**
     *  视频
     */
    TrochilusContentTypeVideo        = 6,
    
    /**
     *  文件类型(暂时仅微信可用)
     */
    TrochilusContentTypeFile         = 7,
    
    //图片类型 仅FacebookMessage 分享图片并需要明确结果时 注此类型分享后不会显示应用名称与icon
    //v3.6.2 增加
    TrochilusContentTypeFBMessageImages = 8,
    
    //图片类型 仅FacebookMessage 分享视频并需要明确结果时 注此类型分享后不会显示应用名称与icon
    //所分享的视频地址必须为相册地址
    //v3.6.2 增加
    TrochilusContentTypeFBMessageVideo = 9,
    
    //小程序
    TrochilusContentTypeMiniProgram = 10,
};

typedef NS_ENUM(NSUInteger, TrochilusMiniProgramType) {
    //小程序分享(暂时仅微信可用) 正式版
    TrochilusMiniProgramTypeRelease  = 0,
    
    //小程序分享(暂时仅微信可用) 开发版
    TrochilusMiniProgramTypeTest  = 1,
    
    //小程序分享(暂时仅微信可用) 体验版
    TrochilusMiniProgramTypePreview  = 2
};

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, TrochilusPlatformType){
    /**
     *  未知
     */
    TrochilusPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    TrochilusPlatformTypeSinaWeibo           = 1,
    /**
     *  腾讯微博
     */
    TrochilusPlatformTypeTencentWeibo        = 2,
    /**
     *  豆瓣
     */
    TrochilusPlatformTypeDouBan              = 5,
    /**
     *  QQ空间
     */
    TrochilusPlatformSubTypeQZone            = 6,
    /**
     *  人人网
     */
    TrochilusPlatformTypeRenren              = 7,
    /**
     *  开心网
     */
    TrochilusPlatformTypeKaixin              = 8,
    /**
     *  Facebook
     */
    TrochilusPlatformTypeFacebook            = 10,
    /**
     *  Twitter
     */
    TrochilusPlatformTypeTwitter             = 11,
    /**
     *  印象笔记
     */
    TrochilusPlatformTypeYinXiang            = 12,
    /**
     *  Google+
     */
    TrochilusPlatformTypeGooglePlus          = 14,
    /**
     *  Instagram
     */
    TrochilusPlatformTypeInstagram           = 15,
    /**
     *  LinkedIn
     */
    TrochilusPlatformTypeLinkedIn            = 16,
    /**
     *  Tumblr
     */
    TrochilusPlatformTypeTumblr              = 17,
    /**
     *  邮件
     */
    TrochilusPlatformTypeMail                = 18,
    /**
     *  短信
     */
    TrochilusPlatformTypeSMS                 = 19,
    /**
     *  打印
     */
    TrochilusPlatformTypePrint               = 20,
    /**
     *  拷贝
     */
    TrochilusPlatformTypeCopy                = 21,
    /**
     *  微信好友
     */
    TrochilusPlatformSubTypeWechatSession    = 22,
    /**
     *  微信朋友圈
     */
    TrochilusPlatformSubTypeWechatTimeline   = 23,
    /**
     *  QQ好友
     */
    TrochilusPlatformSubTypeQQFriend         = 24,
    /**
     *  Instapaper
     */
    TrochilusPlatformTypeInstapaper          = 25,
    /**
     *  Pocket
     */
    TrochilusPlatformTypePocket              = 26,
    /**
     *  有道云笔记
     */
    TrochilusPlatformTypeYouDaoNote          = 27,
    /**
     *  Pinterest
     */
    TrochilusPlatformTypePinterest           = 30,
    /**
     *  Flickr
     */
    TrochilusPlatformTypeFlickr              = 34,
    /**
     *  Dropbox
     */
    TrochilusPlatformTypeDropbox             = 35,
    /**
     *  VKontakte
     */
    TrochilusPlatformTypeVKontakte           = 36,
    /**
     *  微信收藏
     */
    TrochilusPlatformSubTypeWechatFav        = 37,
    /**
     *  易信好友
     */
    TrochilusPlatformSubTypeYiXinSession     = 38,
    /**
     *  易信朋友圈
     */
    TrochilusPlatformSubTypeYiXinTimeline    = 39,
    /**
     *  易信收藏
     */
    TrochilusPlatformSubTypeYiXinFav         = 40,
    /**
     *  明道
     */
    TrochilusPlatformTypeMingDao             = 41,
    /**
     *  Line
     */
    TrochilusPlatformTypeLine                = 42,
    /**
     *  WhatsApp
     */
    TrochilusPlatformTypeWhatsApp            = 43,
    /**
     *  KaKao Talk
     */
    TrochilusPlatformSubTypeKakaoTalk        = 44,
    /**
     *  KaKao Story
     */
    TrochilusPlatformSubTypeKakaoStory       = 45,
    /**
     *  Facebook Messenger
     */
    TrochilusPlatformTypeFacebookMessenger   = 46,
    /**
     *  支付宝好友
     */
    TrochilusPlatformTypeAliPaySocial        = 50,
    /**
     *  支付宝朋友圈
     */
    TrochilusPlatformTypeAliPaySocialTimeline= 51,
    /**
     *  钉钉
     */
    TrochilusPlatformTypeDingTalk            = 52,
    /**
     *  youtube
     */
    TrochilusPlatformTypeYouTube             = 53,
    /**
     *  美拍
     */
    TrochilusPlatformTypeMeiPai              = 54,
    /**
     *  支付宝平台
     */
    TrochilusPlatformTypeAliPay              = 993,
    /**
     *  易信
     */
    TrochilusPlatformTypeYiXin               = 994,
    /**
     *  KaKao
     */
    TrochilusPlatformTypeKakao               = 995,
    /**
     *  印象笔记国际版
     */
    TrochilusPlatformTypeEvernote            = 996,
    /**
     *  微信平台,
     */
    TrochilusPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    TrochilusPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    TrochilusPlatformTypeAny                 = 999
};

/**
 *  回复状态
 */
typedef NS_ENUM(NSUInteger, TrochilusResponseState){
    
    /**
     *  开始
     */
    TrochilusResponseStateBegin     = 0,
    
    /**
     *  成功
     */
    TrochilusResponseStateSuccess    = 1,
    
    /**
     *  失败
     */
    TrochilusResponseStateFail       = 2,
    
    /**
     *  取消
     */
    TrochilusResponseStateCancel     = 3,
    
    
    //视频文件开始上传
    TrochilusResponseStateBeginUPLoad = 4,
    
    /**
     *  支付结果等待查询(iOS9起点击左上角返回，需要自己去服务器查询状态)
     */
    TrochilusResponseStatePayWait      = 5
};

/**
 *  导入原平台SDK回调处理器
 *
 *  @param platformType 需要导入原平台SDK的平台类型
 */
typedef void(^TImportHandler) (TrochilusPlatformType platformType);

/**
 *  配置分享平台回调处理器
 *
 *  @param platformType 需要初始化的分享平台类型
 *  @param appInfo      需要初始化的分享平台应用信息
 */
typedef void(^TrochilusConfigurationHandler) (TrochilusPlatformType platformType, NSMutableDictionary *appInfo);

typedef NS_ENUM(NSUInteger, TrochilusPboardEncoding) {
    TrochilusPboardEncodingKeyedArchiver,
    TrochilusPboardEncodingPropertyListSerialization,
};

/**
 *  分享内容状态变更回调处理器
 *
 *  @param state            状态
 *  @param userData         附加数据, 返回状态以外的一些数据描述，如：邮件分享取消时，标识是否保存草稿等
 *  @param error            错误信息,当且仅当state为TrochilusResponseStateFail时返回
 */
typedef void(^TrochilusStateChangedHandler) (TrochilusResponseState state, NSDictionary *userData, NSError *error);

/**
 *  授权状态变化回调处理器
 *
 *  @param state      状态
 *  @param user       授权用户信息，当且仅当state为TrochilusResponseStateSuccess时返回
 *  @param error      错误信息，当且仅当state为TrochilusResponseStateFail时返回
 */
typedef void(^TrochilusAuthorizeStateChangedHandler) (TrochilusResponseState state, TrochilusUser *user, NSError *error);

/**
 *  支付状态变化回调处理器
 *
 *  @param state      状态
 *  @param error      错误信息，当且仅当state为TrochilusResponseStateFail时返回
 */
typedef void(^TrochilusPayStateChangedHandler) (TrochilusResponseState state,NSError *error);


#endif /* TrochilusTypeDefine_h */


//
//  TrochilusMessageObject.h
//  Trochilus
//
//  Created by 王权伟 on 2018/7/3.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrochilusTypeDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrochilusMessageObject : NSObject

@property(strong, nonatomic) NSString * title;
@property(strong, nonatomic) NSString * text;
@property(strong, nonatomic) NSString * url;
@property(strong, nonatomic) id image;
@property(strong, nonatomic) UIImage * thumbImage;
@property(assign, nonatomic) TrochilusContentType contentType;
//for 微信
@property(strong, nonatomic) NSString * extInfo;
@property(strong, nonatomic) NSString * mediaUrl;
@property(strong, nonatomic) NSString * fileExt;
@property(strong, nonatomic) NSData * fileData;  //文件
@property(strong, nonatomic) NSString * fileExtension;
@property(strong, nonatomic) NSData * emoticonData; //微信分享gif
@property(strong, nonatomic) NSString * mediaTagName;
@property(strong, nonatomic) NSString * messageAction;

//for 微信小程序
@property(strong, nonatomic) NSString * path;
@property(assign, nonatomic) BOOL withShareTicket;
@property(assign, nonatomic) TrochilusMiniProgramType miniProgramType;
@property(strong, nonatomic) NSString * userName;

//for 微博
@property(assign, nonatomic) long latitude;
@property(assign, nonatomic) long longitude;
@property(strong, nonatomic) NSString * objectID;

+ (instancetype)messageObject;


/**
 判断必填参数是否为空

 @param contentType 分享类型
 @return YES or NO
 */
-(BOOL)isNotEmpty:(NSArray*)attributes;

@end

NS_ASSUME_NONNULL_END

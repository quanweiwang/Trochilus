//
//  TrochilusPlatformParameter.h
//  Trochilus
//
//  Created by 王权伟 on 2018/6/29.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrochilusPlatformParameter : NSObject

@property (strong,nonatomic) NSString * text;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * url;
@property (strong,nonatomic) NSString * mediaTagName;
@property (strong,nonatomic) NSString * messageAction;
@property (strong,nonatomic) NSString * audioFlashURL;
@property (strong,nonatomic) NSString * videoFlashURL;
@property (strong,nonatomic) id thumbImage;
@property (strong,nonatomic) id images;
@property (assign,nonatomic) NSInteger contentType;
@property (assign,nonatomic) NSInteger platformSubType;
@property (strong,nonatomic) NSString * extInfo;
@property (strong,nonatomic) id fileData;
@property (strong,nonatomic) id emoticonData;
@property (strong,nonatomic) NSString * sourceFileExtension;
@property (strong,nonatomic) id sourceFileData;
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * path;
@property (strong,nonatomic) NSString * descriptions;
@property (strong,nonatomic) NSString * withShareTicket;
@property (strong,nonatomic) NSNumber * miniProgramType;
@property (strong,nonatomic) NSString * musicFileURL;

@end

NS_ASSUME_NONNULL_END

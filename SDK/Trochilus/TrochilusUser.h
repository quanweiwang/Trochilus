//
//  TrochilusUser.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TrochilusTypeDefine.h"

@interface TrochilusUser : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * openid;
@property (nonatomic, copy) NSString * refreshToken;
@property (nonatomic, copy) NSDate   * expiration;
@property (nonatomic, copy) NSString * accessToken;
@property (nonatomic, copy) NSString * unionId;

/**
 第三方平台昵称
 */
@property (nonatomic, copy) NSString * name;

/**
 第三方平台头像地址
 */
@property (nonatomic, copy) NSString * iconurl;

/**
 通用平台性别属性
 QQ、微信、微博返回 "男", "女"
 Facebook返回 "male", "female"
 */
@property (nonatomic, copy) NSString * unionGender;

@property (nonatomic, copy) NSString * gender;

//@property (nonatomic, assign) TPlatformType platformType;
/**
 * 第三方原始数据
 */
@property (nonatomic, strong) id originalResponse;

@end





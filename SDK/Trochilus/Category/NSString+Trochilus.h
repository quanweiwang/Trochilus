//
//  NSString+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Trochilus)

/**
 base64编码

 @param string base64编码前的字符串
 @return base64编码后的字符串
 */
+ (NSString *)trochilusBase64Encode:(NSString *)string;

/**
 还原base64编码的字符串

 @param string base64编码的字符串
 @return base64编码前的字符串
 */
+ (NSString *)trochilusBase64Decode:(NSString *)string;

+ (NSString *)trochilusUrlDecode:(NSString*)input;

/**
 获取设备型号

 @return 例如 iphone8,2
 */
+ (NSString*)trochilusDeviceModel;

@end

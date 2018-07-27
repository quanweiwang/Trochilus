//
//  NSString+Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSString+Trochilus.h"
#import <sys/utsname.h>

@implementation NSString (Trochilus)

+ (NSString *)trochilusBase64Encode:(NSString *)string {
    
    NSString * base64String = @"";
    if (string) {
        base64String = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    }
    return base64String;
}

+ (NSString *)trochilusBase64Decode:(NSString *)string {
    return [[NSString alloc ] initWithData:[[NSData alloc] initWithBase64EncodedString:string options:0] encoding:NSUTF8StringEncoding];
}

+ (NSString *)trochilusUrlDecode:(NSString*)input {
    return [[input stringByReplacingOccurrencesOfString:@"+" withString:@" "]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString*)trochilusDeviceModel {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceModel;
}

@end


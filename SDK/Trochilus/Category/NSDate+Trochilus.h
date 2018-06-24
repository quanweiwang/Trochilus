//
//  NSDate+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Trochilus)

/**
 将格林尼治时转为本地时间
 
 @param GMTDate 格林尼治时
 @return 本地时间
 */
+ (NSDate *)trochilus_localDateWithGMTDate:(NSDate *)GMTDate;

@end

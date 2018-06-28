//
//  UIImage+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2018/6/27.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Trochilus)

/**
 图片压缩

 @param image 原始图片
 @param maxLength 最大占用内存值 字节
 @return 压缩后的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END

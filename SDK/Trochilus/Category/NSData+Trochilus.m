//
//  NSData+Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSData+Trochilus.h"

@implementation NSData (Trochilus)

+ (NSData *)trochilus_dataWithImage:(UIImage *)image {
    
    return UIImageJPEGRepresentation(image, 0.5f);
}

+ (NSData *)trochilus_dataWithImage:(UIImage *)image scale:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(scaledImage, 1);
}

@end

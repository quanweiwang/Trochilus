//
//  UIImage+Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2018/7/17.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "UIImage+Trochilus.h"

@implementation UIImage (Trochilus)

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1.f);
    }
    
    return resultImage;
    
}

+ (NSData *)trochilusDataWithImage:(UIImage *)image {
    
    return UIImageJPEGRepresentation(image, 1.f);
}

+ (NSArray *)trochilusDataArrayWithImages:(id)images {
    
    NSMutableArray * array = [NSMutableArray array];
    
    if ([images isKindOfClass:[NSArray class]]) {
        
        for (id image in images) {
            
            @autoreleasepool {
                if ([image isKindOfClass:[UIImage class]]) {
                    NSData * imageData = UIImageJPEGRepresentation(image, 1.f);
                    if (imageData) {
                        [array addObject:imageData];
                    }
                    
                }
            }
        }
    }
    else {
        NSData * imageData = UIImageJPEGRepresentation(images, 1.f);
        if (imageData) {
            [array addObject:imageData];
        }
    }
    
    return array;
}

+ (NSData *)trochilusDataWithThumbImage:(UIImage *)thumbImage {
    
    UIImage * image = [self compressImage:thumbImage toByte:32768];
    
    return UIImageJPEGRepresentation(image, 1.f);
}

+ (NSData *)trochilusDataWithHDThumbImage:(UIImage *)hdThumbImage {
    
    UIImage * image = [self compressImage:hdThumbImage toByte:131072];
    
    return UIImageJPEGRepresentation(image, 1.f);
}

@end

//
//  NSMutableArray+Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSMutableArray+Trochilus.h"
#import <UIKit/UIKit.h>
#import "NSData+Trochilus.h"

@implementation NSMutableArray (Trochilus)

+ (NSMutableArray<NSData *> *)trochilus_arrayWithImages:(id)images isCompress:(BOOL)compress {
    
    NSMutableArray * imageArray = [NSMutableArray array];
    
    if (images) {
        
        if ([images isKindOfClass:[NSString class]]) {
            
            NSData * imageData;
            UIImage * image = [UIImage imageWithContentsOfFile:images];
            imageData = compress == YES ? [NSData trochilus_dataWithImage:image scale:CGSizeMake(100, 100)] : [NSData trochilus_dataWithImage:image];
            [imageArray addObject:imageData];
        }
        else if ([images isKindOfClass:[NSArray class]]) {
            
            for (id image in images) {
                
                NSData * imageData = nil;
                
                if ([image isKindOfClass:[UIImage class]]) {
                    imageData = compress == YES ? [NSData trochilus_dataWithImage:(UIImage *)image scale:CGSizeMake(100, 100)] : [NSData trochilus_dataWithImage:(UIImage *)image];
                }
                else if ([image isKindOfClass:[NSString class]]) {
                    imageData = compress == YES ? [NSData trochilus_dataWithImage:[UIImage imageWithContentsOfFile:image] scale:CGSizeMake(100, 100)] : [NSData trochilus_dataWithImage:[UIImage imageWithContentsOfFile:image]];
                }
                else {
                    //[image isKindOfClass:[NSURL class]]
                    NSData * imgData = [NSData dataWithContentsOfURL:image];
                    imageData = compress == YES ? [NSData trochilus_dataWithImage:[UIImage imageWithData:imgData] scale:CGSizeMake(100, 100)] : [NSData trochilus_dataWithImage:[UIImage imageWithData:imgData]];
                }
                
                [imageArray addObject:imageData];
            }
        }
        else {
            NSData * imageData = compress == YES ? [NSData trochilus_dataWithImage:images scale:CGSizeMake(100, 100)] : [NSData trochilus_dataWithImage:images];
            [imageArray addObject:imageData];
        }
    }
    else {
        //什么图片都没有
        NSData * data = [NSData data];
        [imageArray addObject:data];
    }
    
    return imageArray;
}


@end

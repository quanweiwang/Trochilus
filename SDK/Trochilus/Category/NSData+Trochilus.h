//
//  NSData+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (Trochilus)

+ (NSData *)trochilus_dataWithImage:(UIImage *)image;
+ (NSData *)trochilus_dataWithImage:(UIImage *)image scale:(CGSize)size;

@end

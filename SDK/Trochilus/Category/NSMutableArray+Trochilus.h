//
//  NSMutableArray+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Trochilus)

/**
 图片集合
 
 @param images 可以是UIImage 或者 数组<UIImage,NSSring,NSUrl>
 @param compress 是否压缩
 @return 返回二进制图片集合
 */
+ (NSMutableArray<NSData *> *)trochilus_arrayWithImages:(id)images isCompress:(BOOL)compress;


@end

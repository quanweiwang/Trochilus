//
//  NSMutableDictionary+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2018/7/15.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Trochilus)

- (NSError *)nonEmptyWithAttribute:(NSArray *)attributes;

+ (NSMutableDictionary *)trochilusDictionaryWithUrl:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END

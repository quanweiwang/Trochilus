//
//  NSMutableDictionary+Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2018/7/15.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "NSMutableDictionary+Trochilus.h"
#import "TrochilusError.h"

@implementation NSMutableDictionary (Trochilus)

- (NSError *)nonEmptyWithAttribute:(NSArray *)attributes {
    
    NSDictionary * errDic;
    
    if ([self valueForKey:@"title"] == nil && [self valueForKey:@"text"] == nil) {
        
    }
    
    if ([self valueForKey:@"thumbImage"]) {
        
    }
    
    for (NSString * attribute in attributes) {
        
        if (![self valueForKey:attribute]) {
            errDic = @{
                       NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@不能为空",attribute],
                       NSLocalizedRecoverySuggestionErrorKey : [NSString stringWithFormat:@"请填写%@",attribute]
                       };
            return [TrochilusError errorWithCode:TrochilusErrorCodeParameter userInfo:errDic];
        }
        
    }
    
    return nil;
    
}

@end

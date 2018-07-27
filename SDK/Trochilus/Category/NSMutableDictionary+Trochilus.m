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

+ (NSMutableDictionary *)trochilusDictionaryWithUrl:(NSURL*)url {
    
    
    NSString * urlString = [[url query] isEqualToString:@""] ? [url absoluteString] : [url query];
    
    //QQ 网页授权返回url格式有# 所以要处理下
    //auth://www.qq.com?#access_token=68656BB22C0699511CE047EAF2624619&expires_in=7776000&openid=039015BD8F609BD51FFF4B820B50FC50&pay_token=BC389EC1E6B05EFB82A9AA996217826E&state=test&ret=0&pf=openmobile_ios&pfkey=aa3cb964950d309e47ad8c751123f11f&auth_time=1499929922100&page_type=1
    urlString = [urlString stringByReplacingOccurrencesOfString:@"auth://www.qq.com?#" withString:@""];
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSRange range=[keyValuePair rangeOfString:@"="];
        [queryStringDictionary setObject:range.length>0?[keyValuePair substringFromIndex:range.location+1]:@"" forKey:(range.length?[keyValuePair substringToIndex:range.location]:keyValuePair)];
    }
    return queryStringDictionary;
}

@end

//
//  NSMutableDictionary+Pay.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSMutableDictionary+TrochilusPay.h"

@implementation NSMutableDictionary (TrochilusPay)

- (void)trochilus_payWithWechatPartnerId:(NSString *)partnerId prepayId:(NSString *)prepayId appId:(NSString *)appid nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp package:(NSString *)package sign:(NSString *)sign {
    
    if (partnerId) {
        [self setObject:partnerId forKey:@"partnerId"];
    }
    
    if (prepayId) {
        [self setObject:prepayId forKey:@"prepayId"];
    }
    
    if (nonceStr) {
        [self setObject:nonceStr forKey:@"nonceStr"];
    }
    
    if (timeStamp) {
        [self setObject:timeStamp forKey:@"timeStamp"];
    }
    
    if (package) {
        [self setObject:package forKey:@"package"];
    }
    
    if (sign) {
        [self setObject:sign forKey:@"sign"];
    }
    
    if (appid) {
        [self setObject:appid forKey:@"appId"];
    }
}

@end

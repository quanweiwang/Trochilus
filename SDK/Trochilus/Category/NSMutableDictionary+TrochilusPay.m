//
//  NSMutableDictionary+Pay.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "NSMutableDictionary+TrochilusPay.h"

@implementation NSMutableDictionary (TrochilusPay)

- (void)trochilusPayWithWechatPartnerId:(NSString *)partnerId
                               prepayId:(NSString *)prepayId
                                  appId:(NSString *)appid
                               nonceStr:(NSString *)nonceStr
                              timeStamp:(NSString *)timeStamp
                                package:(NSString *)package
                                   sign:(NSString *)sign {
    
    
    [self setValue:partnerId forKey:@"partnerId"];

    [self setValue:prepayId forKey:@"prepayId"];

    [self setValue:nonceStr forKey:@"nonceStr"];

    [self setValue:timeStamp forKey:@"timeStamp"];

    [self setValue:package forKey:@"package"];

    [self setValue:sign forKey:@"sign"];
    
    [self setValue:appid forKey:@"appId"];
    
}

@end

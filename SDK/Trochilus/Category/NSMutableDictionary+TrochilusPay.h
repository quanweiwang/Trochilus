//
//  NSMutableDictionary+Pay.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TrochilusPay)

/**
 微信支付
 
 @param partnerId 商家向财付通申请的商家id
 @param prepayId 预支付订单
 @param nonceStr 随机串，防重发
 @param timeStamp 时间戳，防重发
 @param package 商家根据财付通文档填写的数据和签名
 @param sign 商家根据微信开放平台文档对数据做的签名
 */
- (void)trochilusPayWithWechatPartnerId:(NSString *)partnerId
                       prepayId:(NSString *)prepayId
                          appId:(NSString *)appid
                       nonceStr:(NSString *)nonceStr
                      timeStamp:(NSString *)timeStamp
                        package:(NSString *)package
                           sign:(NSString *)sign ;

@end

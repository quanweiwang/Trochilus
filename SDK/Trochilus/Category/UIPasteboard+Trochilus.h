//
//  UIPasteboard+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrochilusTypeDefine.h"

@interface UIPasteboard (Trochilus)

+ (void)trochilusSetPasteboard:(NSString*)key value:(NSDictionary*)value encoding:(TrochilusPboardEncoding)encoding;

+ (NSDictionary *)trochilusGetPasteboard:(NSString*)key encoding:(TrochilusPboardEncoding)encoding;

@end

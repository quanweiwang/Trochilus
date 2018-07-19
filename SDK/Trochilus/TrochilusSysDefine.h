//
//  TrochilusSysDefine.h
//  Trochilus
//
//  Created by 王权伟 on 2018/6/23.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "NSString+Trochilus.h"

#ifndef TrochilusSysDefine_h
#define TrochilusSysDefine_h

#define PLATFORMNAME(name)\
[NSString stringWithFormat:@"Trochilus%@Platform",name]

#define k32KB 32768

#define kWeChatSDKVer @"1.8.2"
#define kQQSDKVer @"3.2.1"

#define kCFBundleDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

//bundle id
#define kCFBundleIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//设备型号
#define kModel [NSString trochilus_deviceModel]

#define kSystemVersion [[UIDevice currentDevice] systemVersion]

//支付结果查询通知(iOS9后出现左上角返回APP功能，这样无法收到支付平台的回调 需要去自己服务器查询)
#define kTrochilusPayment @"kTrochilusPayment"

#endif /* TrochilusSysDefine_h */

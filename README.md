# 概述
Trochilus是iOS轻量级社会化组件(支持:免SDK支付、打赏、分享、授权)。  

现已支持以下平台:    

QQ (QQ好友分享、QQ空间分享、QQ授权)  
微信 (微信好友分享、微信朋友圈分享、微信收藏、小程序分享、微信授权、微信支付)  
微博 (微博分享、微博授权)  
支付宝 (支付宝支付、支付宝打赏)

# 优势

1、无需导入以下系统库(framework、tbd)

QQ平台  
  
~~libiconv.dylib  
SystemConfiguration.framework  
CoreGraphics.Framework  
libsqlite3.dylib  
CoreTelephony.framework  
libstdc++.dylib  
libz.dylib~~

微信平台  

~~SystemConfiguration.framework  
libz.dylib  
libsqlite3.0.dylib  
libc++.dylib  
Security.framework  
CoreTelephony.framework  
CFNetwork.framework~~

微博平台  

~~ImageIO.framework  
libsqlite3.dylib~~  

支付宝平台  

~~CFNetwork.framework  
SystemConfiguration.framework  
CoreGraphics.framework  
CoreMotion.framework  
CoreTelephony.framework  
CoreText.framework  
libc++.tbd  
libz.tbd~~  

2、无需导入各个平台SDK  

~~QQSDK  
微信SDK  
微博SDK  
支付宝SDK~~

3、各个平台回调Trochilus内部自动处理。  

4、解决iOS9 or latter左上角返回，不触发回调的问题。  

# TODO
- [ ] 必填参数验证(当必填参数未填时返回错误信息)
- [ ] CocoaPods支持
- [ ] 日志系统

# 快速使用
打开AppDelegate.m导入头文件

```
#import <Trochilus/Trochilus.h>
```
在- (BOOL)application: didFinishLaunchingWithOptions:方法中调用registerPlatforms方法来初始化第三方平台

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray * platforms = @[
                            @(TrochilusPlatformTypeSinaWeibo),
                            @(TrochilusPlatformTypeQQ),
                            @(TrochilusPlatformTypeWechat)
                            ];
    
    [Trochilus registerPlatforms:platforms onConfiguration:^(TrochilusPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case TrochilusPlatformTypeSinaWeibo:
                
                [appInfo trochilusSetSinaWeiboByAppKey:kSinaWeiboAppKey
                                             appSecret:kSinaWeiboAppSecret
                                           redirectUri:kSinaWeiboRedirectUri];
                
                break;
            case TrochilusPlatformTypeQQ:
                
                [appInfo trochilusSetQQByAppId:kQQAppId
                                        appKey:kQQAppKey
                                        useTIM:NO];
                break;
            case TrochilusPlatformTypeWechat:
                
                [appInfo trochilusSetWeChatByAppId:kWeChatAppId
                                         appSecret:kWeChatAppSecret];
                
                break;
            default:
                break;
        }
        
    }];
    
    return YES;
}

```
(注意：每一个case对应一个break不要忘记填写，不然很可能有不必要的错误。）

### 分享
添加以下代码，分享之后的效果需要去对应的分享平台上观看，首先要构造分享参数，然后再根据每个平台的方法定制自己想要分享的不同的分享内容。

```
NSMutableDictionary * parameters = [NSMutableDictionary dictionary];

//QQ好友分享
[parameters trochilusSetQQParamsByText:@"Trochilus"
                                 title:nil
                                   url:nil
                         audioFlashURL:nil
                         videoFlashURL:nil
                            thumbImage:nil
                                images:nil
                                  type:self.type];
                           
//微信好友分享
[parameters trochilusSetWeChatParamsByText:@"Trochilus"
                                     title:nil
                                       url:nil
                              mediaTagName:nil
                             messageAction:nil
                                thumbImage:nil
                                     image:nil
                              musicFileURL:nil
                                   extInfo:nil
                                  fileData:nil
                             fileExtension:nil
                              emoticonData:nil
                                      type:TrochilusContentTypeText];

//微信小程序分享
[parameters trochilusSetWeChatMiniProgramShareParamsByWebpageUrl:@"http://www.wangquanwei.com/"
                                                        userName:@"gh_d43f693ca31f"
                                                            path:@"/page/API/pages/share/share"
                                                           title:@"MiniProgram"
                                                     description:@"test MiniProgram"
                                                      thumbImage:thumbImage
                                                     hdThumImage:thumbImage
                                                 withShareTicket:YES
                                                     contentType:TrochilusContentTypeMiniProgram
                                                 miniProgramType:TrochilusMiniProgramTypeRelease];

//微博分享
[parameters trochilusSetSinaWeiboShareParamsByText:@"Trochilus"
                                             title:nil
                                             image:nil
                                               url:nil
                                          latitude:0
                                         longitude:0
                                          objectID:nil
                                              type:TrochilusContentTypeText];
//分享
[Trochilus shareWithPlatformType:{分享平台} parameters:parameters onStateChanged:^(TrochilusResponseState state, NSDictionary *userData, NSError *error) {
        
        switch (state) {
            case TrochilusResponseStateSuccess: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateFail: {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"分享失败\n%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateCancel: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
                break;
        }
}];


```
更多可以参考文件 (Trochilus / Category / NSMutableDictionary+TrochilusShare)中的方法。


### 登录
把如下代码复制并粘贴到你要登录的位置,并且修改相应的参数即可。  
这里以QQ登陆为例
（其他的平台也一样的处理，修改下登陆方法里authorize的平台类型参数：微信登录－> TrochilusPlatformTypeWechat,新浪微博登录－>TrochilusPlatformTypeSinaWeibo。

```
[Trochilus authorizeWithPlatformType:TrochilusPlatformTypeQQ settings:nil onStateChanged:^(TrochilusResponseState state, TrochilusUser *user, NSError *error) {
        
        switch (state) {
            case TrochilusResponseStateSuccess: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"授权成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateFail: {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"授权失败\n%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateCancel: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
                break;
        }
        
        
}];
```

### 支付
首先要构造支付参数，然后再根据每个平台调用不同的方法。  
支付涉及到敏感数据，参数全隐去。
```
//微信支付
NSMutableDictionary * wechatPay = [NSMutableDictionary dictionary];
[wechatPay payWithWechatPartnerId:{partnerId}
                             prepayId:{prepayId}
                             nonceStr:{nonceStr}
                            timeStamp:@"1499752264"
                              package:@"Sign=WXPay" //iOS微信支付package只能为Sign=WXPay
                                 sign:{sign}];
                                 
[Trochilus wechatPayWithParameters:wechatPay onStateChanged:^(TrochilusResponseState state,NSError *error) {
        
        switch (state) {
            case TrochilusResponseStateSuccess: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateFail: {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付失败\n%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateCancel: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStatePayWait: {
                
                //iOS9 or later 左上角返回app时 返回TrochilusResponseStatePayWait状态，客户端需要自己去服务器查询是否支付成功
                
                break;
            }
            default:
                break;
        }
}];

```

```
//支付宝支付
NSString * urlScheme = {urlScheme};
NSString * orderString = {由服务器返回构造好的支付字符串};

[Trochilus aliPayWithUrlScheme:urlScheme orderString:orderString onStateChanged:^(TrochilusResponseState state, NSError *error) {
        
        switch (state) {
            case TrochilusResponseStateSuccess: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateFail: {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付失败\n%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStateCancel: {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case TrochilusResponseStatePayWait: {
                
                //iOS9 or later 左上角返回app时 返回TrochilusResponseStatePayWait状态，客户端需要自己去服务器查询是否支付成功
                
                break;
            }
            default:
                break;
        }
        
}];

```

### 适配iOS9+系统
1、http 问题:  
在iOS9下，系统默认会拦截对http协议接口的访问，因此无法获取http协议接口的数据。对Trochilus来说，可能无法获取用户信息。  
解决方法:  
在项目的info.plist中添加一个Key：App Transport Security Settings，类型为字典类型。然后给它添加一个Key：Allow Arbitrary Loads，类型为Boolean类型，值为YES。

![](http://ojgg6fpio.bkt.clouddn.com/Trochilus1.png)  

2、白名单 问题：  
在iOS 9下涉及到平台客户端跳转，系统会自动到项目info.plist下检测是否设置平台Scheme。对于需要配置的平台，如果没有配置，就无法正常跳转平台客户端。因此要支持客户端的分享和授权等，需要配置Scheme名单。  
解决方法:  
在项目的info.plist中添加一LSApplicationQueriesSchemes，类型为Array。然后给它添加一个需要支持的项目，类型为字符串类型。

```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>wechat</string>
	<string>weixin</string>
	<string>sinaweibohd</string>
	<string>sinaweibo</string>
	<string>sinaweibosso</string>
	<string>weibosdk</string>
	<string>weibosdk2.5</string>
	<string>mqqapi</string>
	<string>mqq</string>
	<string>mqqOpensdkSSoLogin</string>
	<string>mqqconnect</string>
	<string>mqqopensdkdataline</string>
	<string>mqqopensdkgrouptribeshare</string>
	<string>mqqopensdkfriend</string>
	<string>mqqopensdkapi</string>
	<string>mqqopensdkapiV2</string>
	<string>mqqopensdkapiV3</string>
	<string>mqzoneopensdk</string>
	<string>wtloginmqq</string>
	<string>wtloginmqq2</string>
	<string>mqqwpa</string>
	<string>mqzone</string>
	<string>mqzonev2</string>
	<string>mqzoneshare</string>
	<string>wtloginqzone</string>
	<string>mqzonewx</string>
	<string>mqzoneopensdkapiV2</string>
	<string>mqzoneopensdkapi19</string>
	<string>mqzoneopensdkapi</string>
	<string>mqzoneopensdk</string>
	<string>alipay</string>
	<string>alipayshare</string>
</array>
```

![](http://ojgg6fpio.bkt.clouddn.com/Trochilus2.png)

### URL Scheme
别忘了配置URL Scheme否则将无法返回客户端。  
具体规则请看各个平台文档。

# Support or Contact
在使用Trochilus过程中有任何问题，都可以添加一个[issues](https://github.com/quanweiwang/Trochilus/issues)，我会及时解决。如果您想贡献代码，欢迎Pull Requests。

# 下载
[Trochilus https://github.com/quanweiwang/Trochilus](https://github.com/quanweiwang/Trochilus)

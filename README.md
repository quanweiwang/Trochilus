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

# 快速使用
打开AppDelegate.m导入头文件

```
#import "Trochilus.h"
```
在- (BOOL)application: didFinishLaunchingWithOptions:方法中调用registerActivePlatforms方法来初始化第三方平台

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //平台注册
    NSArray *platforems = @[@(TPlatformTypeQQ),
                            @(TPlatformTypeWechat),
                            @(TPlatformTypeSinaWeibo)];
    
        [Trochilus registerPlatforms:platforems onConfiguration:^(TPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case TPlatformTypeQQ:
                [appInfo TSetupQQByAppId:@"您的appid"
                                  appKey:@"您的appKey"
                                authType:TAuthTypeBoth
                                  useTIM:NO];
                break;
            case TPlatformTypeWechat:
                [appInfo TSetupWeChatByAppId:@"您的appid"
                                   appSecret:@"您的appSecret"];
                break;
            case TPlatformTypeSinaWeibo:
                [appInfo TSetupSinaWeiboByAppKey:@"您的AppKey"
                                       appSecret:@"您的appSecret"
                                     redirectUri:@"您的回调url"
                                        authType:TAuthTypeBoth];
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
[parameters TSetupQQParamsByText:@"222"
                                        title:nil
                                          url:nil
                                audioFlashURL:nil
                                videoFlashURL:nil
                                   thumbImage:nil
                                       images:nil
                                         type:self.type
                           forPlatformSubType:TPlatformSubTypeQQFriend];
                           
//微信好友分享
[parameters TSetupWeChatParamsByText:@"222"
                                            title:nil
                                              url:nil
                                       thumbImage:nil
                                            image:nil
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TContentTypeText
                               forPlatformSubType:TPlatformSubTypeWechatSession];
                      
//微博分享
[parameters TSetupSinaWeiboShareParamsByText:@"222 http://www.wangquanwei.com/"
                                                    title:nil
                                                    image:nil
                                                      url:nil
                                                 latitude:0
                                                longitude:0
                                                 objectID:nil
                                                     type:TContentTypeText];
//分享
[Trochilus share:{这里填分享平台}
          parameters:parameters
      onStateChanged:^(TResponseState state, NSDictionary *userData, NSError *error) {
        
          switch (state) {
              case TResponseStateSuccess: {
                  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  [alert show];
              }
                  break;
              case TResponseStateFail: {
                  
                  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"分享失败\n%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  [alert show];
              }
                  break;
              case TResponseStateCancel: {
                  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  [alert show];
              }
                  break;
              default:
                  break;
          }
          
}];

```
更多可以参考文件 (Trochilus / Category / NSMutableDictionary+Share)中的方法。


### 登录
把如下代码复制并粘贴到你要登录的位置,并且修改相应的参数即可。  
这里以QQ登陆为例
（其他的平台也一样的处理，修改下登陆方法里authorize的平台类型参数：微信登录－> TPlatformTypeWechat,新浪微博登录－>TPlatformTypeSinaWeibo。

```
[Trochilus authorize:TPlatformTypeQQ settings:nil onStateChanged:^(TResponseState state, TUser *user, NSError *error) {
        
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
                                 
[Trochilus payToWechatParameters:wechatPay onStateChanged:^(TResponseState state, TUser *user, NSError *error) {
        

}];

```

```
//支付宝支付
NSString * urlScheme = {urlScheme};
NSString * orderString = {由服务器返回构造好的支付字符串};

[Trochilus payToAliPayUrlScheme:urlScheme orderString:orderString onStateChanged:^(TResponseState state, TUser *user, NSError *error) {
        
                
}];
```

### 适配iOS9+系统
1、http  
问题:  
在iOS9下，系统默认会拦截对http协议接口的访问，因此无法获取http协议接口的数据。对Trochilus来说，具体表现可能是，无法授权、分享、获取用户信息等。  
解决方法:  
在项目的info.plist中添加一个Key：App Transport Security Settings，类型为字典类型。然后给它添加一个Key：Allow Arbitrary Loads，类型为Boolean类型，值为YES。

![](http://ojgg6fpio.bkt.clouddn.com/Trochilus1.png)  

2、白名单  
问题：  
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

### 下载
[Trochilus](https://github.com/quanweiwang/Trochilus)

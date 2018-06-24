//
//  TWechatContactsVC.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TWechatContactsVC.h"
#import <Trochilus/Trochilus.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TWechatContactsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray * titleArray;
@property (assign, nonatomic) TrochilusContentType type;
@end

@implementation TWechatContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"微信";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * sectionArray = self.titleArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellString = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellString forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self authorize];
    }
    else if (indexPath.section == 1) {
        //微信支付
        [self pay];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //文字
            self.type = TrochilusContentTypeText;
            [self shareText];
        }
        else if (indexPath.row == 1) {
            self.type = TrochilusContentTypeImage;
            [self shareImage];
        }
        else if (indexPath.row == 2) {
            self.type = TrochilusContentTypeWebPage;
            [self shareLink];
        }
        else if (indexPath.row == 3) {
            self.type = TrochilusContentTypeAudio;
            [self shareAudio];
        }
        else if (indexPath.row == 4) {
            self.type = TrochilusContentTypeVideo;
            [self shareVideo];
        }
        else if (indexPath.row == 5) {
            self.type = TrochilusContentTypeApp;
            [self shareApp];
        }
        else if (indexPath.row == 6) {
            self.type = TrochilusContentTypeImage;
            [self shareEmoticon];
        }
        else if (indexPath.row == 7) {
            self.type = TrochilusContentTypeFile;
            [self shareFile];
        }
        else if (indexPath.row == 8) {
            self.type = TrochilusContentTypeMiniProgram;
            [self shareMiniProgram];
        }
        
    }
    else {
        
        NSString * msg = @"";
        if ([Trochilus isInstalledPlatformType:TrochilusPlatformTypeWechat]) {
            msg = @"已安装";
        }
        else {
            msg = @"未安装";
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark- 分享
/**
 分享文字
 */
-(void)shareText
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"222"
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
                                             type:TrochilusContentTypeText
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    
    [self shareWithParameters:parameters];
}

/**
 分享图片
 */
- (void)shareImage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"222"
                                            title:nil
                                              url:nil
                                       thumbImage:nil
                                            image:[UIImage imageNamed:@"COD13"]
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TrochilusContentTypeImage
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    
    [self shareWithParameters:parameters];
}

- (void)shareLink
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"222 Link Desc"
                                            title:@"222"
                                              url:[NSURL URLWithString:@"https://www.mob.com"]
                                       thumbImage:nil
                                            image:[UIImage imageNamed:@"COD13"]
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TrochilusContentTypeWebPage
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    
    [self shareWithParameters:parameters];
}

- (void)shareAudio
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //网络音频
    
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"崔健"
                                            title:@"一无所有"
                                              url:[NSURL URLWithString:@"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT"]
                                       thumbImage:[UIImage imageNamed:@"COD13"]
                                            image:nil
                                     musicFileURL:[NSURL URLWithString:@"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT"]
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TrochilusContentTypeAudio
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    [self shareWithParameters:parameters];
}

- (void)shareVideo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //网络视频
    
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"视频"
                                            title:@"乔布斯"
                                              url:[NSURL URLWithString:@"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html"]
                                       thumbImage:[UIImage imageNamed:@"COD13"]
                                            image:nil
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TrochilusContentTypeVideo
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    [self shareWithParameters:parameters];
}

- (void)shareApp
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"222"
                                            title:@"App消息"
                                              url:[NSURL URLWithString:@"http://www.mob.com"]
                                       thumbImage:[UIImage imageNamed:@"COD13"]
                                            image:nil
                                     musicFileURL:nil
                                          extInfo:@"<xml>extend info</xml>"
                                         fileData:[@"13232" dataUsingEncoding:NSUTF8StringEncoding]
                                     emoticonData:nil
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TrochilusContentTypeApp
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    [self shareWithParameters:parameters];
}

- (void)shareEmoticon
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //gif 或 普通格式图片
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:nil
                                            title:nil
                                              url:nil
                                       thumbImage:[UIImage imageNamed:@"COD13"]
                                            image:nil
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:[[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"]
                              sourceFileExtension:nil
                                   sourceFileData:nil
                                             type:TrochilusContentTypeImage
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    
    [self shareWithParameters:parameters];
}

- (void)shareFile
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //平台定制
    [parameters trochilus_SetupWeChatParamsByText:@"222"
                                            title:@"file"
                                              url:nil
                                       thumbImage:[UIImage imageNamed:@"COD13"]
                                            image:nil
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil
                              sourceFileExtension:@"mp4"
                                   sourceFileData:[[NSBundle mainBundle] pathForResource:@"cat" ofType:@"mp4"]
                                             type:TrochilusContentTypeFile
                               forPlatformSubType:TrochilusPlatformSubTypeWechatSession];
    
    [self shareWithParameters:parameters];
}

- (void)shareMiniProgram
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //平台定制
    //    [parameters TSetupWeChatParamsByTitle:@"MiniProgram"
    //                                 description:@"test MiniProgram"
    //                                  webpageUrl:[NSURL URLWithString:@"http://www.mob.com"]
    //                                        path:@"/page/API/pages/share/share"
    //                                  thumbImage:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]
    //                                    userName:@"gh_d43f693ca31f"
    //                          forPlatformSubType:TPlatformSubTypeWechatSession];
    
    [self shareWithParameters:parameters];
}

- (void)shareWithParameters:(NSMutableDictionary *)parameters
{
    if(parameters.count == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请先设置分享参数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [Trochilus shareWithPlatformType:TrochilusPlatformSubTypeWechatSession parameters:parameters onStateChanged:^(TrochilusResponseState state, NSDictionary *userData, NSError *error) {
        
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
}

#pragma mark- 支付
- (void) pay {
    //weixin://app/wx822295c9333f22d8/pay/?nonceStr=Ijs2foLuSi8sHEYS&package=Sign%3DWXPay&partnerId=1236691302&prepayId=wx20170711135104183fad0d3b0405256507&timeStamp=1499752264&sign=A8350D3407446ABE65DD25F8BB786B9F&signType=SHA1
    
    NSMutableDictionary * wechatPay = [NSMutableDictionary dictionary];
    [wechatPay trochilus_payWithWechatPartnerId:@"1374443602"
                             prepayId:@"wx20171103162205656805fbde0807352087"
                                appId:@"wx259627eb5f9f6cf4"
                             nonceStr:@"URpSOgEHqcJbnqyC"
                            timeStamp:@"1509697325"
                              package:@"Sign=WXPay"
                                 sign:@"797EE32700174351922D9CDADBCB70B8"];
    
    [Trochilus wechatPayWithParameters:wechatPay onStateChanged:^(TrochilusResponseState state, TrochilusUser *user, NSError *error) {
        if (state == TrochilusResponseStateFail) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付失败\n%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }];
}

#pragma mark- 登录
- (void)authorize {
    
    [Trochilus authorizeWithPlatformType:TrochilusPlatformTypeWechat settings:nil onStateChanged:^(TrochilusResponseState state, TrochilusUser *user, NSError *error) {
        
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
}

#pragma mark- 懒加载
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[@[@"微信登录"],@[@"微信支付"],@[@"文字",@"图片",@"链接",@"网络音频",@"网络视频",@"应用消息",@"表情",@"文件(本地视频)",@"小程序"],@[@"是否安装客户端"]];
    }
    return _titleArray;
}


@end

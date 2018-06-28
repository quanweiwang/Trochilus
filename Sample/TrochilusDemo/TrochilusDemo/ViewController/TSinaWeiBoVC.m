//
//  TSinaWeiBoVC.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/5.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TSinaWeiBoVC.h"
#import <Trochilus/Trochilus.h>

@interface TSinaWeiBoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray * titleArray;
@end

@implementation TSinaWeiBoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新浪微博";
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
        [self authAct];
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //文字分享
            [self shareText];
        }
        else if (indexPath.row == 1) {
            //图片分享
            [self shareImage];
        }
        else if (indexPath.row == 2) {
            //链接分享
            [self shareLinkToAPP];
        }
    }
    else {
        
        NSString * msg = @"";
        if ([Trochilus isInstalledPlatformType:TrochilusPlatformTypeSinaWeibo]) {
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
- (void)shareText
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置 文字中必须有绑定域下的URL链接
    //绑定域在新浪开放平台“我的应用 － 应用信息 － 基本应用信息编辑 － 安全域名”里设置。
    //平台定制
    [parameters trochilus_SetupSinaWeiboShareParamsByText:@"Share SDK http://www.mob.com/"
                                                    title:nil
                                                    image:nil
                                                      url:nil
                                                 latitude:0
                                                longitude:0
                                                 objectID:nil
                                                     type:TrochilusContentTypeText];
    [self shareWithParameters:parameters];
}

/**
 分享图片
 */
- (void)shareImage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置 文字中必须有绑定域下的URL链接
    //绑定域在新浪开放平台“我的应用 － 应用信息 － 基本应用信息编辑 － 安全域名”里设置。
    //平台定制
    [parameters trochilus_SetupSinaWeiboShareParamsByText:@"Share SDK http://www.mob.com/"
                                                    title:nil
                                                    image:[UIImage imageNamed:@"COD13"]
                                                      url:nil
                                                 latitude:0
                                                longitude:0
                                                 objectID:nil
                                                     type:TrochilusContentTypeImage];
    [self shareWithParameters:parameters];
}

- (void)shareTextAdvanced
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    //2017年6月30日后需申请高级权限
    [parameters trochilus_SetupShareParamsByText:@"Share SDK"
                                          images:nil
                                             url:nil
                                           title:nil
                                            type:TrochilusContentTypeText];
    //    [parameters TEnableAdvancedInterfaceShare];
    //平台定制
    //    [parameters TSetupSinaWeiboShareParamsByText:@"Share SDK http://www.mob.com/"
    //                                              title:nil
    //                                              image:nil
    //                                                url:nil
    //                                           latitude:nil
    //                                          longitude:nil
    //                                           objectID:nil
    //                                               type:TContentTypeText];
    [self shareWithParameters:parameters];
}

- (void)shareImageAdvanced
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    //2017年6月30日后需申请高级权限
    [parameters trochilus_SetupShareParamsByText:@"Share SDK"
                                          images:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]
                                             url:nil
                                           title:nil
                                            type:TrochilusContentTypeImage];
    //    [parameters TEnableAdvancedInterfaceShare];
    //平台定制
    //    [parameters TSetupSinaWeiboShareParamsByText:nil
    //                                              title:nil
    //                                              image:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]
    //                                                url:nil
    //                                           latitude:nil
    //                                          longitude:nil
    //                                           objectID:nil
    //                                               type:TContentTypeImage];
    [self shareWithParameters:parameters];
}

- (void)shareTextToAPP
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters trochilus_SetupShareParamsByText:@"Share SDK"
                                          images:nil
                                             url:nil
                                           title:nil
                                            type:TrochilusContentTypeText];
    //    [parameters TEnableUseClientShare];
    //平台定制
    //    [parameters TSetupSinaWeiboShareParamsByText:@"Share SDK http://www.mob.com/"
    //                                              title:nil
    //                                              image:nil
    //                                                url:nil
    //                                           latitude:0
    //                                          longitude:0
    //                                           objectID:nil
    //                                               type:TContentTypeText];
    [self shareWithParameters:parameters];
}

- (void)shareImageToAPP
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters trochilus_SetupShareParamsByText:@"Share SDK"
                                          images:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]
                                             url:nil
                                           title:nil
                                            type:TrochilusContentTypeImage];
    //    [parameters TEnableUseClientShare];
    //平台定制
    //    [parameters TSetupSinaWeiboShareParamsByText:@"Share SDK"
    //                                              title:nil
    //                                              image:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]
    //                                                url:nil
    //                                           latitude:0
    //                                          longitude:0
    //                                           objectID:nil
    //                                               type:TContentTypeImage];
    [self shareWithParameters:parameters];
}

- (void)shareLinkToAPP
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    //    [parameters TSetupShareParamsByText:@"Share SDK Link Desc"
    //                                    images:[UIImage imageNamed:@"COD13.jpg"]
    //                                       url:[NSURL URLWithString:@"http://www.mob.com"]
    //                                     title:@"MOB"
    //                                      type:TContentTypeWebPage];
    //    [parameters TEnableUseClientShare];
    //平台定制
    [parameters trochilus_SetupSinaWeiboShareParamsByText:@"Share SDK Link Desc"
                                                    title:@"MOB"
                                                    image:[UIImage imageNamed:@"COD13.jpg"]
                                                      url:@"http://www.mob.com"
                                                 latitude:0
                                                longitude:0
                                                 objectID:nil
                                                     type:TrochilusContentTypeWebPage];
    
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
    
    [Trochilus shareWithPlatformType:TrochilusPlatformTypeSinaWeibo parameters:parameters onStateChanged:^(TrochilusResponseState state, NSDictionary *userData, NSError *error) {
        
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

#pragma mark- 授权
- (void)authAct
{
    [Trochilus authorizeWithPlatformType:TrochilusPlatformTypeSinaWeibo settings:nil onStateChanged:^(TrochilusResponseState state, TrochilusUser *user, NSError *error) {
        
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
        _titleArray = @[@[@"微博登录"],@[@"文字",@"图片",@"链接"],@[@"是否安装客户端"]];
    }
    return _titleArray;
}
@end

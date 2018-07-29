//
//  TQQFriendVC.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TQQFriendVC.h"
#import <Trochilus/Trochilus.h>

@interface TQQFriendVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray * titleArray;
@property (assign, nonatomic) TrochilusContentType type;
@end

@implementation TQQFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"QQ";
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        [self authorize];
    }
    else if (indexPath.section == 1) {
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
    }
    else {
        
        NSString * msg = @"";
        if ([Trochilus isInstalledPlatformType:TrochilusPlatformTypeQQ]) {
            msg = @"已安装";
        }
        else {
            msg = @"未安装";
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

#pragma mark- 分享
//文字分享
- (void)shareText {
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetQQParamsByText:@"222"
                                     title:nil
                                       url:nil
                             audioFlashURL:nil
                             videoFlashURL:nil
                                thumbImage:nil
                                    images:nil
                                      type:self.type];
    
    [self shareWithParameters:parameters];
}

//图片分享
- (void)shareImage {
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetQQParamsByText:@"222"
                                     title:nil
                                       url:nil
                             audioFlashURL:nil
                             videoFlashURL:nil
                                thumbImage:nil
                                    images:[UIImage imageNamed:@"COD13"]
                                      type:self.type];
    
    [self shareWithParameters:parameters];
}

//链接分享
- (void)shareLink {
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetQQParamsByText:@"Link Desc"
                                     title:@"Title"
                                       url:@"http://www.hao123.com"
                             audioFlashURL:nil
                             videoFlashURL:nil
                                thumbImage:[UIImage imageNamed:@"COD13"] //链接使用缩略图
                                    images:nil
                                      type:self.type];
    
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
    
    [Trochilus shareWithPlatformType:TrochilusPlatformSubTypeQQFriend
          parameters:parameters
      onStateChanged:^(TrochilusResponseState state, NSDictionary *userData, NSError *error) {
        
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

#pragma mark- 登录
- (void)authorize {
    
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
}

#pragma mark- 懒加载
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[@[@"QQ登录"],@[@"文字",@"图片",@"链接"],@[@"是否安装客户端"]];
    }
    return _titleArray;
}

@end

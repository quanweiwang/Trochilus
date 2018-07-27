//
//  TWechatMomentsVC.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TWechatMomentsVC.h"
#import <Trochilus/Trochilus.h>

@interface TWechatMomentsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray * titleArray;
@property (assign, nonatomic) TrochilusContentType type;

@end

@implementation TWechatMomentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"微信朋友圈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 分享
/**
 分享文字
 */
-(void)shareText
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetWeChatParamsByText:@"222"
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
    
    [self shareWithParameters:parameters];
}

/**
 分享图片
 */
- (void)shareImage
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetWeChatParamsByText:@"222"
                                            title:nil
                                              url:nil
                                     mediaTagName:nil
                                    messageAction:nil
                                       thumbImage:nil
                                            image:[UIImage imageNamed:@"COD13"]
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                    fileExtension:nil
                                     emoticonData:nil
                                             type:TrochilusContentTypeImage];
    
    [self shareWithParameters:parameters];
}

- (void)shareLink
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetWeChatParamsByText:@"222"
                                            title:nil
                                              url:@"https://www.baidu.com"
                                     mediaTagName:@"aaa"
                                    messageAction:nil
                                       thumbImage:nil
                                            image:[UIImage imageNamed:@"COD13"]
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                    fileExtension:nil
                                     emoticonData:nil
                                             type:TrochilusContentTypeWebPage];
    
    [self shareWithParameters:parameters];
}

- (void)shareAudio
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetWeChatParamsByText:@"崔健"
                                            title:@"一无所有"
                                              url:@"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT"
                                     mediaTagName:@"aaa"
                                    messageAction:nil
                                       thumbImage:nil
                                            image:[UIImage imageNamed:@"COD13"]
                                     musicFileURL:@"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT"
                                          extInfo:nil
                                         fileData:nil
                                    fileExtension:nil
                                     emoticonData:nil
                                             type:TrochilusContentTypeAudio];
    
    [self shareWithParameters:parameters];
}

- (void)shareVideo
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters trochilusSetWeChatParamsByText:@"视频"
                                            title:@"乔布斯"
                                              url:@"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html"
                                     mediaTagName:nil
                                    messageAction:nil
                                       thumbImage:nil
                                            image:[UIImage imageNamed:@"COD13"]
                                     musicFileURL:nil
                                          extInfo:nil
                                         fileData:nil
                                    fileExtension:nil
                                     emoticonData:nil
                                             type:TrochilusContentTypeVideo];
    
    [self shareWithParameters:parameters];
}

- (void)shareWithParameters:(NSMutableDictionary *)parameters
{
    if(parameters == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请先设置分享参数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [Trochilus shareWithPlatformType:TrochilusPlatformSubTypeWechatTimeline parameters:parameters onStateChanged:^(TrochilusResponseState state, NSDictionary *userData, NSError *error) {
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

#pragma mark- tableView 相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellString = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellString forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark- 懒加载
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[@"文字",@"图片",@"链接",@"网络音频",@"网络视频"];
    }
    return _titleArray;
}

@end

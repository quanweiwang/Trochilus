//
//  TWechatFavVC.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TWechatFavVC.h"
#import <Trochilus/Trochilus.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TWechatFavVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray * titleArray;
@property (assign, nonatomic) TrochilusContentType type;
@end

@implementation TWechatFavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"微信收藏";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    else if (indexPath.row == 5) {
        self.type = TrochilusContentTypeFile;
        [self shareFile];
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
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.title = @"222";
    message.contentType = TrochilusContentTypeText;
    [self shareWithParameters:message];
}

/**
 分享图片
 */
- (void)shareImage
{
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.title = @"222";
    message.image = [UIImage imageNamed:@"COD13"];
    message.contentType = TrochilusContentTypeImage;
    
    [self shareWithParameters:message];
}

- (void)shareLink
{
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.title = @"222";
    message.image = [UIImage imageNamed:@"COD13"];
    message.url = @"https://www.baidu.com";
    message.mediaTagName = @"aaa";
    message.contentType = TrochilusContentTypeWebPage;
    
    [self shareWithParameters:message];
}

- (void)shareAudio
{
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.title = @"一无所有";
    message.text = @"崔健";
    message.image = [UIImage imageNamed:@"COD13"];
    message.thumbImage = [UIImage imageNamed:@"COD13"];
    message.url = @"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT";
    message.mediaUrl = @"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT";
    message.mediaTagName = @"aaa";
    message.contentType = TrochilusContentTypeAudio;
    
    [self shareWithParameters:message];
}

- (void)shareVideo
{
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.title = @"乔布斯";
    message.text = @"视频";
    message.url = @"http://v.youku.com/v_show/id_XNTUxNDY1NDY4.html";
    message.thumbImage = [UIImage imageNamed:@"COD13"];
    message.contentType = TrochilusContentTypeVideo;
    [self shareWithParameters:message];
}

- (void)shareFile
{
    TrochilusMessageObject * message = [TrochilusMessageObject messageObject];
    message.thumbImage = [UIImage imageNamed:@"COD13"];
    message.fileExtension = @"mp4";
    message.fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cat" ofType:@"mp4"]];
    message.contentType = TrochilusContentTypeFile;
    [self shareWithParameters:message];
}

- (void)shareWithParameters:(TrochilusMessageObject *)parameters
{
    if(parameters == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请先设置分享参数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [Trochilus shareWithPlatformType:TrochilusPlatformSubTypeWechatFav parameters:parameters onStateChanged:^(TrochilusResponseState state, NSDictionary *userData, NSError *error) {
        
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

#pragma mark- 懒加载
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[@"文字",@"图片",@"链接",@"网络音频",@"网络视频",@"文件(本地视频)"];
    }
    return _titleArray;
}


@end

//
//  ViewController.m
//  QWThirdShare
//
//  Created by 王权伟 on 2017/6/23.
//  Copyright © 2017年 QWThirdShare. All rights reserved.
//

#import "ViewController.h"
#import <Trochilus/Trochilus.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TQQFriendVC.h"
#import "TQZoneVC.h"
#import "TWechatContactsVC.h"
#import "TSinaWeiBoVC.h"
#import "TWechatMomentsVC.h"
#import "TAliPayVC.h"
#import "TWechatFavVC.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray * titleArray;
@property (strong, nonatomic) NSArray * platforemArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Trochilus";
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellString = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellString forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    NSString *iconImageName = [NSString stringWithFormat:@"sns_icon_%ld",[self.platforemArray[indexPath.row] integerValue]];
    cell.imageView.image = [UIImage imageNamed:iconImageName];
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        TQQFriendVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TQQFriendVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        TQZoneVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TQZoneVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        TWechatContactsVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TWechatContactsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3) {
        TWechatMomentsVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TWechatMomentsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 4) {
        TWechatFavVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TWechatFavVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5) {
        TSinaWeiBoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TSinaWeiBoVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.row == 6) {
        TAliPayVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TAliPayVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- 懒加载
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[@"QQ",@"QZone",@"Wechat contacts",@"Wechat moments",@"Wechat favorites",@"Sina weibo",@"AliPay"];
    }
    return _titleArray;
}

- (NSArray *)platforemArray {
    if (_platforemArray == nil) {
        _platforemArray = @[@(TrochilusPlatformSubTypeQQFriend),
                            @(TrochilusPlatformSubTypeQZone),
                            @(TrochilusPlatformSubTypeWechatSession),
                            @(TrochilusPlatformSubTypeWechatTimeline),
                            @(TrochilusPlatformSubTypeWechatFav),
                            @(TrochilusPlatformTypeSinaWeibo),
                            @(TrochilusPlatformTypeAliPay)];
    }
    return _platforemArray;
}

@end

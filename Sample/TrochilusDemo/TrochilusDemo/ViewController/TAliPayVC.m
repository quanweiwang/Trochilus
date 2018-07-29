//
//  TAliPayVC.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TAliPayVC.h"
#import <Trochilus/Trochilus.h>

@interface TAliPayVC ()
@property (strong, nonatomic) NSArray * titleArray;
@end

@implementation TAliPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付宝";
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
        [self pay];
    }
    else {
        NSString * msg = @"";
        if ([Trochilus isInstalledPlatformType:TrochilusPlatformTypeAliPay]) {
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

- (void)pay {
    
    NSString * urlScheme = @"alipayMobike";
    NSString * orderString = @"payment_type=\"1\"&out_trade_no=\"MBK059114997563803633041\"&partner=\"2088811798787949\"&subject=\"mobike\"&service=\"mobile.securitypay.pay\"&_input_charset=\"UTF-8\"&total_fee=\"5.0\"&body=\"mobike_money\"&notify_url=\"https://apiv2.mobike.com/mobike-api/pay/receivepayinfo.do\"&seller_id=\"developer@mobike.com\"&sign=\"NKHXOHuo2Rv1SoiULpOeiV5J5AYF%2BTB6IoKZ9M50%2FVL2Gf%2BVpwQi3wV46GCauxmVvw6cZ3quW%2BDmoICBUinfWiE5ojCaW3%2BoYiV%2Fw6v%2F5oly%2BTF7PqfeApIWvOGfmM0%2B2jEcKh84pITZxdMQvvv0%2FIKaZ9R7t4VcbJ7CUAyeC7M%3D\"&sign_type=\"RSA\"&bizcontext=\"{\"appkey\":\"2014052600006128\"}\"";
    
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
}

#pragma mark- 懒加载
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        _titleArray = @[@[@"支付宝支付"],@[@"是否安装客户端"]];
    }
    return _titleArray;
}

@end

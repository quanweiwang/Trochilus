//
//  UIApplication+Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/12.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "UIApplication+Trochilus.h"

@implementation UIApplication (Trochilus)

//获取当前屏幕显示的ViewController
- (UIViewController *)currentViewController {
    UIViewController * result;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray * windows = [UIApplication sharedApplication].windows;
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView * frontView = window.subviews.firstObject;
    UIResponder * nextResponder = frontView.nextResponder;
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = (UIViewController *)nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    return result;
}

@end

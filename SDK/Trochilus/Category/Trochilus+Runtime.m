//
//  Trochilus+Runtime.m
//  Trochilus
//
//  Created by 王权伟 on 2017/11/2.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "Trochilus+Runtime.h"
#import "TrochilusSysDefine.h"
#import <objc/runtime.h>

@implementation Trochilus (Runtime)

static void swizzleMethod(SEL defaultSel, SEL originalSel, SEL replacedSel){
    
    //获取appDelegate类名
    Class targetClass = NSClassFromString([Trochilus getAppdelegate]);
    
    IMP newIMP = class_getMethodImplementation([Trochilus class], replacedSel);
    IMP defaultIMP = class_getMethodImplementation([Trochilus class], defaultSel);
    
    class_addMethod(targetClass, replacedSel, newIMP ,nil);
    class_addMethod(targetClass, originalSel, defaultIMP ,nil);
    
    Method oldMethod = class_getInstanceMethod(targetClass, originalSel);
    Method newMethod = class_getInstanceMethod(targetClass, replacedSel);
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //applicationWillEnterForeground
        swizzleMethod(@selector(default_applicationWillEnterForeground:),
                      @selector(applicationWillEnterForeground:),
                      @selector(replaced_applicationWillEnterForeground:));
        
        //application:openURL:options:
        swizzleMethod(@selector(default_application:openURL:options:),
                      @selector(application:openURL:options:),
                      @selector(replaced_application:openURL:options:));
        
        //application:openURL:sourceApplication:annotation:
        swizzleMethod(@selector(default_application:openURL:sourceApplication:annotation:),
                      @selector(application:openURL:sourceApplication:annotation:),
                      @selector(replaced_application:openURL:sourceApplication:annotation:));
    });

}

//获取到项目的Appdelegate类
+ (NSString *)getAppdelegate {
    
    NSString * appdelegateStr = @"";
    
    int allClasses = objc_getClassList(NULL,0);
    Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * allClasses);
    allClasses = objc_getClassList(classes, allClasses);
    
    for (int i = 0; i < allClasses; i++) {
        
        Class clazz = classes[i];
        NSString *className = NSStringFromClass(clazz);
        
        if ([className containsString:@"AppDelegate"]) {
            
            appdelegateStr = className;
            break;
        }
        
    }
    
    free(classes);
    
    return appdelegateStr;
}

//添加默认方法和新的方法
- (void)replaced_applicationWillEnterForeground:(UIApplication *)application {
    
    [self replaced_applicationWillEnterForeground:application];
}

- (void)default_applicationWillEnterForeground:(UIApplication *)application {
    //如果appdelegate没实现方法，那么方法调换后会走这里
}

-(BOOL)replaced_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [Trochilus handleURL:url];
    
    return [self replaced_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

-(BOOL)default_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
}

- (BOOL)replaced_application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [Trochilus handleURL:url];
    
    return [self replaced_application:application openURL:url options:options];
}

- (BOOL)default_application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return YES;
}

@end

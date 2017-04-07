//
//  AppDelegate.m
//  GZPayDemo
//
//  Created by xinshijie on 2017/4/6.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[ViewController alloc]]  ;
    
    self.window.rootViewController = navi ;
     [self.window makeKeyAndVisible];
    //微信支付
    [WXApi registerApp:GZWX_APP_KEY];
    
    [self SetMeiChouApp];
    return YES;
}

- (void)SetMeiChouApp{
    UMConfigInstance.appKey = GZUmengAppkey ;
    UMConfigInstance.channelId = @"App Store" ;
    
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *appVersion = [NSString stringWithFormat:@"2、获取APP的版本号：%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [MobClick setAppVersion:appVersion];
    //对统计数据进行加密
    [MobClick setEncryptEnabled:YES];
    
    /*! 测试信息 */
        [self test];
    // 友盟分享
    [self addShareOpt];
    
}

#pragma mark - *****  友盟分享
- (void)addShareOpt
{
    GZShareManage *manager = [GZShareManage shareManage];
    [manager gz_setupShareConfig];
    
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayResult" object:[resultDic objectForKey:@"resultStatus"]];
        }];
        return YES ;
        
    }else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
}
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //   NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayResult" object:[resultDic objectForKey:@"resultStatus"]];
        }];
        return YES ;
        
    }else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
       return [[UMSocialManager defaultManager] handleOpenURL:url];
    }

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayResult" object:[resultDic objectForKey:@"resultStatus"]];
        }];
        return YES ;
        
    }else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    
    
}

//微信支付结果
- (void) onResp:(BaseResp*)resp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinPay" object:resp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - ***** 设备各种信息获取 设置
- (void)test
{
    /* 1、获取APP的名字 */
    NSString *appName = [NSString stringWithFormat:@"1、获取APP的名字：%@", GZ_APP_Name];

    /* 2、获取APP的版本号 */
    NSString *appVersion = [NSString stringWithFormat:@"2、获取APP的版本号：%@", GZ_APP_Version];

    /* 3、获取App短式版本号 */
    NSString *appVersionShort = [NSString stringWithFormat:@"3、获取App短式版本号：%@", GZ_APP_VersionShort];

    /* 4、获取iOS版本 */
    NSString *systemVersion = [NSString stringWithFormat:@"5、获取iOS版本：%@", [UIDevice currentDevice].systemVersion];
    
    [self.window gz_showHUD:[NSString stringWithFormat:@"%@\n %@\n %@\n %@",appName ,appVersion,appVersionShort,systemVersion] hide:1];
    NSLog(@"%@",[NSString stringWithFormat:@"%@\n,%@\n,%@\n,%@",appName ,appVersion,appVersionShort,systemVersion]);
    

    
}
@end

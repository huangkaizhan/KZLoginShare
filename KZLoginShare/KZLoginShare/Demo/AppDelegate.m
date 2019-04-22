//
//  AppDelegate.m
//  MamaShare
//
//  Created by huang kaizhan on 2018/12/23.
//  Copyright © 2018年 Shengcheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ShareTool_lib.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self setupThirdPatryLoginShareApi];
    
    return YES;
}

- (void)setupThirdPatryLoginShareApi
{
    ShareLoginConfigModel_lib *configModel = [[ShareLoginConfigModel_lib alloc] init];
    configModel.wxAppKey = @"wxf200a0c37c3c3d56";
    configModel.wxAppSecret = @"16733d8b4f712f5253995bd90ce6a8c0";
    configModel.wxGetTokenUrl = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    configModel.redirectUrl = @"http://www.mama.cn";
    configModel.wxGetUserInfoUrl = @"https://api.weixin.qq.com/sns/userinfo";
    configModel.wxUrlSchemes = @"wxf200a0c37c3c3d56";
    [[ShareTool_lib shareTool] setupWithConfigModel:configModel];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// iOS9版本以上应用跳转回调方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options
{
    BOOL result = [self handleWithUrl:url];
    return result;
}

// 第三方应用打开应用程序
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [self handleWithUrl:url];
    return result;
}
// 处理url
- (BOOL)handleWithUrl:(NSURL *)url
{
    BOOL isOk = [[ShareTool_lib shareTool] handleLoginShareUrl:url];
    if (!isOk) {
        // 不是第三方登录分享，有可能是爱丽百川的
//        isOk = [[AlibcTradeSDK sharedInstance] application:application openURL:url options:options];
    }
    return isOk;
}
@end

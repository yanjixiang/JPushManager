//
//  AppDelegate.m
//  YJXJPushManager
//
//  Created by 闫继祥 on 2023/6/14.
//

#import "AppDelegate.h"

#import "AppDelegate+JPush.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //    注意：1.需要要在账号登录或者注册时，设置别名
    //         2.若账号登录过期，或者在其他设备登录导致账号登录过期，也要重新设置别名
    //         3.退出登录时，要删除别名
    
    //初始化极光推送
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    



    
    return YES;
}
//程序进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self appWillEnterForeground:application];
}

//程序被激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self appDidBecomeActive:application];
}


@end

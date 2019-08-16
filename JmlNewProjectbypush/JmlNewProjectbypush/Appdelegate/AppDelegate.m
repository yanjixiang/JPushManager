//
//  AppDelegate.m
//  JmlNewProject
//
//  Created by 闫继祥 on 2019/7/11.
//  Copyright © 2019 闫继祥. All rights reserved.
//

#import "AppDelegate.h"
//启动广告
#import "LLFullScreenAdView.h"

//引导页
#import "LXGuideViewController.h"

#define App_Run_count_KEY @"runCount"

#import "AppDelegate+JpushManager.h"
@interface AppDelegate ()


@end

@implementation AppDelegate

//程序完成加载
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[UITabBar appearance] setTranslucent:NO];
    
    [self loadRootVC];

    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}
// 加载根控制器
- (void)loadRootVC {
    
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:App_Run_count_KEY] + 1;
    if (runCount == 1) {
        //第一次启动
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"haveLogin"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        
      
        self.window.rootViewController = [[LXGuideViewController alloc] init];
        
    } else {
       
        self.window.rootViewController = [[RootViewController alloc]init];
        
    }
    [self.window makeKeyAndVisible];

    [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:App_Run_count_KEY];
    // 注意:一定要在[self.window makeKeyAndVisible]之后添加 这样的效果是先展示启动图，启动图结束之后展示动画图
    [self addADView];       // 添加广告图
    [self getADImageURL];
}
/** 添加广告图 */
- (void)addADView
{
    LLFullScreenAdView *adView = [[LLFullScreenAdView alloc] init];
    adView.tag = 100;
    adView.duration = 5;
    adView.waitTime = 3;
    adView.skipType = SkipButtonTypeCircleAnimationTest;
    adView.adImageTapBlock = ^(NSString *content) {
        NSLog(@"%@", content);
    };
    [self.window addSubview:adView];
}

/** 获取广告图URL */
- (void)getADImageURL
{
    // 此处推荐使用tag来获取adView，勿使用全局变量。因为在AppDelegate中将其设为全局变量时，不会被释放
    LLFullScreenAdView *adView = (LLFullScreenAdView *)[self.window viewWithTag:100];
    
    //    [PPNetworkHelper GET:@"" parameters:nil success:^(id responseObject) {
    //        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
    //            [adView reloadAdImageWithUrl:@""]; // 加载广告图（如果没有设置广告图设置为空）
    //            //750x1334
    //        }else {
    //            [adView reloadAdImageWithUrl:nil]; // 加载广告图（如果没有设置广告图设置为空）
    //        }
    //    } failure:^(NSError *error) {
    //        [adView reloadAdImageWithUrl:nil]; // 加载广告图（如果没有设置广告图设置为空）
    //    }];
    
}
//程序取消激活状态
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self appWillResignActive:application];
}

//程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self appDidEnterBackground:application];
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


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self appWillTerminate:application];
}


@end

//
//  AppDelegate+JpushManager.h
//  JmlNewProjectbypush
//
//  Created by 闫继祥 on 2019/8/15.
//  Copyright © 2019 闫继祥. All rights reserved.
//


#import "AppDelegate.h"
#import "JpushManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (JpushManager)

-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
//程序取消激活状态
- (void)appWillResignActive:(UIApplication *)application;

//程序进入后台
- (void)appDidEnterBackground:(UIApplication *)application;

//程序进入前台
- (void)appWillEnterForeground:(UIApplication *)application;

//程序被激活
- (void)appDidBecomeActive:(UIApplication *)application;

//程序终止
- (void)appWillTerminate:(UIApplication *)application;
@end

NS_ASSUME_NONNULL_END

//
//  AppDelegate+JPush.h
//  YJXJPushManager
//
//  Created by 闫继祥 on 2023/6/14.
//

#import "AppDelegate.h"

#import "JPushManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface AppDelegate (JPush)<JPushApiManagerDelegate>

//初始化
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


//程序进入前台
- (void)appWillEnterForeground:(UIApplication *)application;

//程序被激活
- (void)appDidBecomeActive:(UIApplication *)application;




@end

NS_ASSUME_NONNULL_END

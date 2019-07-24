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
//极光推送
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

#endif
static NSString * const JPUSHAPPKEY = @"e98bc4beea9b2988976bae04"; // 极光appKey
static NSString * const channel = @"Publish channel"; // 固定的

#ifdef DEBUG // 开发

static BOOL const isProduction = FALSE; // 极光FALSE为开发环境

#else // 生产

static BOOL const isProduction = TRUE; // 极光TRUE为生产环境

#endif

#define App_Run_count_KEY @"runCount"
@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[UITabBar appearance] setTranslucent:NO];

    [self loadRootVC];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"haveLogin"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
       
        
    }else{
        //不是第一次启动了
    }
    
    //*****************************极光推送***********************************
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    
    
    
    return YES;
}

// 加载根控制器
- (void)loadRootVC {
    
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:App_Run_count_KEY] + 1;
    if (runCount == 1) {
        self.window.backgroundColor = [UIColor whiteColor];
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = [[LXGuideViewController alloc] init];
        [self.window makeKeyAndVisible];
        
    } else {
        self.window.backgroundColor = [UIColor whiteColor];
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.tabBarController = [[RootViewController alloc]init];
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
        
    }
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
    
    [PPNetworkHelper GET:@"" parameters:nil success:^(id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [adView reloadAdImageWithUrl:@""]; // 加载广告图（如果没有设置广告图设置为空）
            //750x1334
        }else {
            [adView reloadAdImageWithUrl:nil]; // 加载广告图（如果没有设置广告图设置为空）
        }
    } failure:^(NSError *error) {
        [adView reloadAdImageWithUrl:nil]; // 加载广告图（如果没有设置广告图设置为空）
    }];
    
}
#warning 极光推送代理方法
- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    NSString *strBieName = [[NSUserDefaults standardUserDefaults]valueForKey:@"setAlias"];
    //    [JPUSHService setAlias:strBieName callbackSelector:nil object:nil];
    //别名
    //**极光jpush新版本中的方法**
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iResCode == %ld, iAlias == %@",(long)iResCode,iAlias);
        if (![iAlias isEqualToString:strBieName]){
            //设置别名
            [JPUSHService setAlias:strBieName completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                //                NSLog(@"设备别名了");
                //                NSLog(@"设备别名了%ld",seq);
                NSLog(@"callBackTextView %@",[NSString stringWithFormat:@"iResCode:%ld, \niAlias: %@, \nseq: %ld\n", (long)iResCode, iAlias, (long)seq]);
                
            } seq:0];
            
        }
        
    } seq:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}
- (void)goToMssageViewControllerWith:(NSDictionary*)userInfo{
    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
    //    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    //    [pushJudge setObject:@"push"forKey:@"push"];
    //    [pushJudge synchronize];
    NSString *str = [NSString stringWithFormat:@"%@",userInfo[@"key"]];
    NSLog(@"---------userInfo----------%@",userInfo);
    NSLog(@"---------userInfo1111----------%@",str);
//    MessageViewController *detail = [[MessageViewController alloc] init];
//    UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:detail];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
//    //        VC.strType = @"push";
//    //                detail.order_snStr = dic[@"order_sn"];
//    detail.Type = @"motai";
//    [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"尼玛的推送消息呢===%@",userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    [JPUSHService handleRemoteNotification:userInfo];
    application.applicationIconBadgeNumber = 0;
    [self goToMssageViewControllerWith:userInfo];
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];
        [self goToMssageViewControllerWith:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"收到推送消息"
                              
                              message:userInfo[@"aps"][@"alert"]
                              
                              delegate:nil
                              
                              cancelButtonTitle:nil
                              
                              otherButtonTitles:@"确定",nil];
        
        [alert show];
        
    }else {
        [self goToMssageViewControllerWith:userInfo];
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    [application cancelAllLocalNotifications];
    
    [JPUSHService resetBadge];
    
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
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

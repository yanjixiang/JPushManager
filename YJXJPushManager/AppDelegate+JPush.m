//
//  AppDelegate+JPush.m
//  YJXJPushManager
//
//  Created by 闫继祥 on 2023/6/14.
//

#import "AppDelegate+JPush.h"


//极光推送
static NSString * const JPUSHAPPKEY = @"e98bc4beea9b2988976bae04"; // 极光appKey
static NSString * const channel = @"Publish channel"; // 固定的

#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif

@implementation AppDelegate (JPush)

-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //*****************************极光推送***********************************
    [[JPushManager shareManager] YJX_SetupWithOption:launchOptions appKey:JPUSHAPPKEY channel:channel apsForProduction:isProduction advertisingIdentifier:nil delegate:self];
    
    //获取注册ID
    [[JPushManager shareManager] getRegisterIDCallBack:^(NSString *registerID) {
        NSLog(@"极光c注册ID：%@",registerID);
    }];
    
    
}
//极光推送登录成功
- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"极光推送登陆成功");
}
//推送注册
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}
//推送注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"推送注册失败: %@", error);
}
#pragma mark ------当程序在前台时, 收到推送弹出的通知-------
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"程序在前台收到推送：&&-==%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //程序在前台收到远程推送
        [self didRemoteNotificationAppStatues:1 withUserInfo:userInfo];
    }else {
        //程序在前台收到本地推送
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
}

#pragma mark ------通过点击推送弹出的通知 -------
//在iOS10 及以上系统，收到通知后，点击通知框，进行的逻辑页面跳转（比如：跳转到指定页面）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"通过点击推送弹出的通知调用该方法：%@",userInfo);
        [self didRemoteNotificationAppStatues:0 withUserInfo:userInfo];
        
    }else {
        //本地推送
    }
    completionHandler();  // 系统要求执行这个方法
}
//这里在iOS7及以上系统的方法中，如果需要在前台和后台做不同的处理的时候，需要判断一下app 的状态，判断方式如下
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //这里在iOS7及以上系统的方法中，如果需要在前台和后台做不同的处理的时候，需要判断一下app 的状态，判断方式如下
    if ([application applicationState] == UIApplicationStateActive) {
        // 应用程序正在前台运行
        [self didRemoteNotificationAppStatues:1 withUserInfo:userInfo];
        
    }else if ([application applicationState] == UIApplicationStateInactive) {
        // 应用程序正在从后台启动
        [self didRemoteNotificationAppStatues:0 withUserInfo:userInfo];
        
    }else if ([application applicationState] == UIApplicationStateBackground) {
        // 应用程序正在后台运行，可能处于静默处理状态
        [self didRemoteNotificationAppStatues:0 withUserInfo:userInfo];
        
    }
}
#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    
}
#endif

//将要从后台进入前台
- (void)appWillEnterForeground:(UIApplication *)application{
    
    [[JPushManager shareManager] setBadge:0];
}

//程序被激活
- (void)appDidBecomeActive:(UIApplication *)application{
    [[JPushManager shareManager] setBadge:0];
    
}

/**
 iOS 10以上的收到远程推送通知的回调方法
 
 @param code 1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)didRemoteNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo {
    if (code == 1) {
        //程序在前台时收到远程推送
        
    }else if (code == 0){
        //点击通知消息
        
    }
    
}



@end

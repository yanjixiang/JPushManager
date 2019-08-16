//
//  JpushManager.m
//  JmlNewProject
//
//  Created by 闫继祥 on 2019/7/11.
//  Copyright © 2019 闫继祥. All rights reserved.
//

#import "JpushManager.h"

@implementation JpushManager

+(instancetype)shareManager{
    
    static JpushManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[JpushManager alloc]init];
        }
    });
    return _instance;
}

//初始化推送
-(void)lsd_setupWithOption:(NSDictionary *)launchingOption
                appKey:(NSString *)appKey
               channel:(NSString *)channel
      apsForProduction:(BOOL)isProduction
 advertisingIdentifier:(NSString *)advertisingId{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        __IPHONE_10_0
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
   
    [JPUSHService setupWithOption:launchingOption appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            //设置别名
            [JPUSHService setAlias:@"user200287"  completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
//获取极光推送注册ID
- (void)getRegisterIDCallBack:(void (^)(NSString *))completionHandler{
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            NSLog(@"registrationID获取成功：%@",registrationID);
            completionHandler(registrationID);
            
        }
    }];
}
//设置别名
- (void)setAlias:(NSString *)aliasName {
    //设置别名
    //**极光jpush新版本中的方法**
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iResCode == %ld, iAlias == %@",(long)iResCode,iAlias);
        if (![iAlias isEqualToString:aliasName]){
            [JPUSHService setAlias:aliasName completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                NSLog(@"callBackTextView %@",[NSString stringWithFormat:@"iResCode:%ld, \niAlias: %@, \nseq: %ld\n", (long)iResCode, iAlias, (long)seq]);
                
            } seq:0];
            
        }
        
    } seq:0];
    
}
//删除别名
- (void)deleteAlias {
    //设置别名
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];

}
// 在appdelegate注册设备处调用
- (void)lsd_registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    return;
    
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (self.afterReceiveNoticationHandle) {
        self.afterReceiveNoticationHandle(userInfo);
    }
    
    NSLog(@"iOS6及以下系统，收到通知");
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (self.afterReceiveNoticationHandle) {
        self.afterReceiveNoticationHandle(userInfo);
    }
    NSLog(@"iOS7及以上系统，收到通知");
    completionHandler(UIBackgroundFetchResultNewData);
}

//设置角标
- (void)lsd_setBadge:(int)badge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
       [JPUSHService handleRemoteNotification:userInfo];
        
        if (self.afterReceiveNoticationHandle) {
            self.afterReceiveNoticationHandle(userInfo);
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
}

// iOS 10 Support
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        if (self.afterReceiveNoticationHandle) {
            self.afterReceiveNoticationHandle(userInfo);
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
        NSLog(@"从通知界面直接进入应用");
    }else{
        //从通知设置界面进入应用
        NSLog(@"设置界面进入应用进入应用");
    }
}
- (UIViewController *)getCurrentViewController{
    UIViewController *vc = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController]; //拿到当前页面的VC
    return vc;
}
- (UIViewController *)topVC:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}

#endif

@end

//
//  AppDelegate+JpushManager.m
//  JmlNewProjectbypush
//
//  Created by 闫继祥 on 2019/8/15.
//  Copyright © 2019 闫继祥. All rights reserved.
//

#import "AppDelegate+JpushManager.h"

//极光推送
static NSString * const JPUSHAPPKEY = @"e98bc4beea9b2988976bae04"; // 极光appKey
static NSString * const channel = @"Publish channel"; // 固定的

#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif


@implementation AppDelegate (JpushManager)

-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    
    //*****************************极光推送***********************************
    [[JpushManager shareManager] lsd_setupWithOption:launchOptions appKey:JPUSHAPPKEY channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    //获取注册ID
    [[JpushManager shareManager] getRegisterIDCallBack:^(NSString *registerID) {
        NSLog(@"极光c注册ID：%@",registerID);
        //    //设置别名
        
        [[JpushManager shareManager] setAlias:[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"]];
    }];
    
    [[JpushManager shareManager] lsd_setBadge:0];
    
    __weak __typeof(self)weakSelf = self;
    [JpushManager shareManager].afterReceiveNoticationHandle = ^(NSDictionary *userInfo){
        NSLog(@"接收到消息后处理消息");
        [weakSelf getMessageToHandle];
    };
    //    //设置别名
    //    [[JpushManager shareManager] setAlias:@"userid"];
    //
    //    //删除别名
    //    [[JpushManager shareManager] deleteAlias];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[JpushManager shareManager] lsd_registerDeviceToken:deviceToken];
}

- (void)getMessageToHandle {
    NSLog(@"33333------%@",[[JpushManager shareManager] getCurrentViewController]);
    
}
//将要从后台进入前台
- (void)appWillEnterForeground:(UIApplication *)application{

    [[JpushManager shareManager] lsd_setBadge:0];
}
//程序取消激活状态
- (void)appWillResignActive:(UIApplication *)application{
    
}

//程序进入后台
- (void)appDidEnterBackground:(UIApplication *)application{
    
}


//程序被激活
- (void)appDidBecomeActive:(UIApplication *)application{
    
}

//程序终止
- (void)appWillTerminate:(UIApplication *)application{
    
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // 1.取消正在下载的操作
    [manager cancelAll];
    
    // 2.清除内存缓存
    [manager.imageCache clearMemory];
}

@end

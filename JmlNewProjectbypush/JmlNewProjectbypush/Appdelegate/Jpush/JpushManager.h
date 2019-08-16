//
//  JpushManager.h
//  JmlNewProject
//
//  Created by 闫继祥 on 2019/7/11.
//  Copyright © 2019 闫继祥. All rights reserved.
//

#import <Foundation/Foundation.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
typedef void(^AfterReceiveNoticationHandle)(NSDictionary *userInfo);

@interface JpushManager : NSObject<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

//单例
+(instancetype)shareManager;

//初始化推送
-(void)lsd_setupWithOption:(NSDictionary *)launchingOption
                appKey:(NSString *)appKey
               channel:(NSString *)channel
      apsForProduction:(BOOL)isProduction
 advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
- (void)lsd_registerDeviceToken:(NSData *)deviceToken;

//设置角标
- (void)lsd_setBadge:(int)badge;


//获取注册ID
- (void)getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler;

//设置别名
- (void)setAlias:(NSString *)aliasName;
//清除别名
- (void)deleteAlias;
//获取当前vc
- (UIViewController *)getCurrentViewController;

//接收到消息后的处理
@property(copy,nonatomic)AfterReceiveNoticationHandle afterReceiveNoticationHandle;


@end

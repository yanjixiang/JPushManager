//
//  JPushManager.m
//  YJXJPushManager
//
//  Created by 闫继祥 on 2023/6/14.
//

#import "JPushManager.h"


@implementation JPushManager

//单例
+(instancetype)shareManager{
    
    static JPushManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[JPushManager alloc]init];
        }
    });
    return _instance;
}

//初始化推送
-(void)YJX_SetupWithOption:(NSDictionary *)launchingOption
                    appKey:(NSString *)appKey
                   channel:(NSString *)channel
          apsForProduction:(BOOL)isProduction
     advertisingIdentifier:(NSString *)advertisingId delegate:(nonnull id<JPushApiManagerDelegate>)delegate{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    //    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
    
    
    [JPUSHService setupWithOption:launchingOption appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
}
//设置Alias
- (void)setAlias:(NSString *)alias
      completion:(JPUSHAliasOperationCompletion)completion
             seq:(NSInteger)seq {
    [JPUSHService setAlias:alias completion:completion seq:seq];
}

//删除alias
- (void)deleteAlias:(JPUSHAliasOperationCompletion)completion
                seq:(NSInteger)seq {
    [JPUSHService deleteAlias:completion seq:seq];
}

//查询当前alias
- (void)getAlias:(JPUSHAliasOperationCompletion)completion
             seq:(NSInteger)seq {
    [JPUSHService getAlias:completion seq:seq];
    
}

//设置角标为0
- (void)setBadge:(int)badge {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
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

@end

//
//  JPushManager.h
//  YJXJPushManager
//
//  Created by 闫继祥 on 2023/6/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JPushApiManagerDelegate <JPUSHRegisterDelegate>


@end

@interface JPushManager : NSObject

@property (nonatomic, weak ) id<JPushApiManagerDelegate> delegate;


//单例
+(instancetype)shareManager;

//初始化推送
-(void)YJX_SetupWithOption:(NSDictionary *)launchingOption
                appKey:(NSString *)appKey
               channel:(NSString *)channel
      apsForProduction:(BOOL)isProduction
 advertisingIdentifier:(nullable NSString *)advertisingId delegate:(nonnull id<JPushApiManagerDelegate>)delegate;


//设置Alias 注意：1.需要要在账号登录或者注册时，设置别名
//         2.若账号登录过期，或者在其他设备登录导致账号登录过期，也要重新设置别名
//         3.退出登录时，要删除别名
- (void)setAlias:(NSString *)alias
      completion:(JPUSHAliasOperationCompletion)completion
             seq:(NSInteger)seq;

//删除alias - 账号退出登录时要删除别名 
- (void)deleteAlias:(JPUSHAliasOperationCompletion)completion
                seq:(NSInteger)seq;

//查询当前alias
- (void)getAlias:(JPUSHAliasOperationCompletion)completion
             seq:(NSInteger)seq;

//设置角标为0
- (void)setBadge:(int)badge;

//获取注册ID
- (void)getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler;


@end

NS_ASSUME_NONNULL_END

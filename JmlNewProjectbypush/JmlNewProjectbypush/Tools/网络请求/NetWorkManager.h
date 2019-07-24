//
//  NetWorkManager.h
//  Chuangke
//
//  Created by 闫继祥 on 2019/7/13.
//  Copyright © 2019 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//请求类型
typedef enum {
    postType = 1,
    getType = 2,
} netType;

//参数类型
typedef enum {
    HTTPType = 1,
    JSONType = 2,
} parametersType;

@interface NetWorkManager : NSObject
/*   urlStr 请求地址 （必填）
 *   parameter 请求参数 （选填）
 *   type 请求类型 （postType: post,   getType:get  必填）
 *   headerValue （请求头value，不设置为nil）
 *   HTTPHeaderField（请求头名称，不设置为nil）
 *   vc （当前vc 选填）
 *   parametersType (请求参数类型 HTTPType：二进制     JSONType：json)
 */
+ (void)GetDataWithURL:(NSString *)urlStr parameter:(id _Nullable)parameter netType:(netType)type NetHeaderValue:(NSString *__nullable)headerValue HTTPHeaderField:(NSString *__nullable)HTTPHeaderField parametersType:(parametersType)parametersType nowVC:(UIViewController *__nullable)vc success:(void (^)(id responseObject))response filed:(void (^)(NSError *error))err;


@end

NS_ASSUME_NONNULL_END

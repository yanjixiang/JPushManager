//
//  NetWorkManager.m
//  Chuangke
//
//  Created by 闫继祥 on 2019/7/13.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "NetWorkManager.h"

@implementation NetWorkManager
//nettype 请求k类型
+ (void)GetDataWithURL:(NSString *)urlStr parameter:(id _Nullable)parameter netType:(netType)type NetHeaderValue:(NSString *__nullable)headerValue HTTPHeaderField:(NSString *__nullable)HTTPHeaderField parametersType:(parametersType)parametersType nowVC:(UIViewController *__nullable)vc success:(void (^)(id responseObject))response filed:(void (^)(NSError *error))err{
    
    if ([self isBlankString:headerValue]&&[self isBlankString:HTTPHeaderField]) {
//        为空字符串
    }else {
        //设置请求头
        [PPNetworkHelper setValue:headerValue forHTTPHeaderField:HTTPHeaderField];
    }
    if (parametersType == HTTPType) {
        
        //请求参数二进制
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
       
    }else {
        //请求参数json
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    }
    if (type == postType) {
        //post请求
        [PPNetworkHelper POST:urlStr parameters:parameter success:^(id responseObject) {
            response(responseObject);
        } failure:^(NSError *error) {
            err(error);
            if (vc == NULL|| vc == nil) {
                
            }else {
                [MBProgressHUD showNotice:@"网络错误" view:vc.view];
            }
        }];
    }else {
        //get请求
        [PPNetworkHelper GET:urlStr parameters:parameter success:^(id responseObject) {
            response(responseObject);
        } failure:^(NSError *error) {
            err(error);
            if (vc == NULL|| vc == nil) {
                
            }else {
                [MBProgressHUD showNotice:@"网络错误" view:vc.view];
            }
            
        }];
    }
}
-(void)dealWithResultData:(NSData*)resultData
{
    
}
//错误提示
+  (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}


- (id)objFromJson:(NSString*)jsonstr
{
    jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    NSData *jsonData = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    id objFromJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    return objFromJson;
}
@end

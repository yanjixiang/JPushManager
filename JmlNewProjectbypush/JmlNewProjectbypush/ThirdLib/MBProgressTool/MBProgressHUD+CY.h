//
//  MBProgressHUD+CY.h
//  MBProgress_使用
//
//  Created by sunshine on 2017/8/26.
//  Copyright © 2017年 sunshine. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CY)


+ (MBProgressHUD *)createHUD:(UIView *)view;
+ (MBProgressHUD *)defaultMBProgress:(UIView *)view;
+ (MBProgressHUD *)defaultMBProgressWithText:(NSString *)text view:(UIView *)view;


+ (void)showSuccess:(NSString *)success view:(UIView *)view;
+ (void)showError:(NSString *)error view:(UIView *)view;
+ (MBProgressHUD *)showNotice:(NSString *)notice view:(UIView *)view;

/*****帧动画*****/
+ (MBProgressHUD *)showCustomAnimate:(NSString *)text imageName:(NSString *)imageName imageCounts:(NSInteger)imageCounts view:(UIView *)view;

+ (void)drawErrorViewWithText:(NSString *)text view:(UIView *)view;
+ (void)drawRightViewWithText:(NSString *)text view:(UIView *)view;
+ (MBProgressHUD *)drawRoundLoadingView:(NSString *)tex view:(UIView *)viewt;


@end

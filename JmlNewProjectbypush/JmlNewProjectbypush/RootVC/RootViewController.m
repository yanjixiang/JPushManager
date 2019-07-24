//
//  ViewController.m
//  JmlNewProject
//
//  Created by 闫继祥 on 2019/7/11.
//  Copyright © 2019 闫继祥. All rights reserved.
//

#import "RootViewController.h"
#import "CustomNavViewController.h"
#import "HomeViewController.h"
#import "TwoMainViewController.h"
#import "ThreeMainViewController.h"
#import "MineViewController.h"
@interface RootViewController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = yWhiteColor;

    
  
    //底部tabbar背景色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
   
    
    HomeViewController *first = [[HomeViewController alloc]init];
    CustomNavViewController *firstNavi = [[CustomNavViewController alloc]initWithRootViewController:first];
    firstNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"foot1"] tag:1000];
    firstNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"foot1_curr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    TwoMainViewController *two = [[TwoMainViewController alloc]init];
    UINavigationController *twoNavi = [[UINavigationController alloc]initWithRootViewController:two];
    twoNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"本地商家" image:[UIImage imageNamed:@"foot2"] tag:2000];
    twoNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"foot2_curr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    ThreeMainViewController *three = [[ThreeMainViewController alloc]init];
    CustomNavViewController *threeNavi = [[CustomNavViewController alloc]initWithRootViewController:three];
    threeNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"社区" image:[UIImage imageNamed:@"foot3"] tag:2000];
    threeNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"foot3_curr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    MessageViewController *score = [[MessageViewController alloc]init];
    //    CustomNavViewController *scoreNavi = [[CustomNavViewController alloc]initWithRootViewController:score];
    //    scoreNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"foot3"] tag:2000];
    //    scoreNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"foot3_curr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MineViewController *four = [[MineViewController alloc]init];
    CustomNavViewController *fourNavi = [[CustomNavViewController alloc]initWithRootViewController:four];
    fourNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"foot4"] tag:3000];
    fourNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"foot4_curr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[firstNavi,twoNavi,threeNavi, fourNavi];
    //修改选中状态tabbar的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
}
//tabbar的点击方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //    NSLog(@"--tabbaritem.title--%@",viewController.tabBarItem.title);
    //    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"logi"];
    return YES;
    
}

@end

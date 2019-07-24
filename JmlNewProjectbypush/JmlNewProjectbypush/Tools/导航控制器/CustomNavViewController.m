//
//  CustomNavViewController.m


#import "CustomNavViewController.h"

@interface CustomNavViewController ()
@property(nonatomic,strong) id popDelegate;
@end

@implementation CustomNavViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //将系统的代理保存（在view 加载在完毕就赋值）
    self.popDelegate =self.interactivePopGestureRecognizer.delegate;
    
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    // 导航栏背景颜色
    [[UINavigationBar appearance] setBarTintColor:MainColor];
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (@available(iOS 11.0, *)) {
        //关键适配
        UIImage *backButtonImage = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationBar.backIndicatorImage = backButtonImage;
        self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-SCREEN_WIDTH, -3)forBarMetrics:UIBarMetricsDefault];//UIOffsetMake(-kScreenWidth, 0)只要横向偏移，纵向偏移返回图标也会偏移
    }
    else{
        //设置返回按钮的图片
        UIImage *backButtonImage = [[UIImage imageNamed:@"返回"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        //将返回按钮的文字position设置不在屏幕上显示
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-SCREEN_WIDTH, -SCREENH_HEIGHT)forBarMetrics:UIBarMetricsDefault];
        
    }
    
  
    if (self.childViewControllers.count > 0) {
        //哥么你要想隐藏.那么必须在我push之前给我设置
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //调用父类的方法
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//    self.interactivePopGestureRecognizer.delegate = nil;
//    if (self.viewControllers.count!=0)
//    {
//            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            backBtn.frame = CGRectMake(0, 0, 64, 44);
//            [backBtn setTitle:@"" forState:UIControlStateNormal];
//            backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//            [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//            [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//            backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);//设置边距
//            UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//            viewController.navigationItem.leftBarButtonItem = btnItem;
//
////        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[self imageWithOriImageName:@"返回"] style:0 target:self action:@selector(back)];
//    }
//    [super pushViewController:viewController animated:YES];
//
//}
//-(void)back
//{
//    [self popViewControllerAnimated:YES];
//}
//
//- (UIImage *)imageWithOriImageName:(NSString *)imageName
//{
//    //传入一张图片,返回一张不被渲染的图片
//    UIImage *image = [UIImage imageNamed:imageName];
//    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}
//
//
//#pragma mark - 实现代理方法
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    NSLog(@"代理方法的实现");
//    //判断控制器是否为根控制器
//    if (self.childViewControllers.count == 1) {
//        //将保存的代理赋值回去,让系统保持原来的侧滑功能
//        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
//    }
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

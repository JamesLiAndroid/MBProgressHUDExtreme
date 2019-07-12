//
//  MBEViewController.m
//  MBProgressHUDExtreme
//
//  Created by JamesLiAndroid on 07/12/2019.
//  Copyright (c) 2019 JamesLiAndroid. All rights reserved.
//

#import "MBEViewController.h"

#import "MBProgressHUDExtreme+Extend.h"

@interface MBEViewController ()

@end

@implementation MBEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btnProgress = [[UIButton alloc] init];
    btnProgress.frame = CGRectMake(50, 120, 120, 30);
    btnProgress.backgroundColor = [UIColor blueColor];
    btnProgress.titleLabel.textColor = [UIColor whiteColor];
    [btnProgress setTitle:@"测试Progress" forState:UIControlStateNormal];
    [btnProgress addTarget:self action:@selector(btnTestProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnProgress];
}


- (void)btnTestProgress:(id)sender {
   // [[MBProgressHUDExtreme shareInstance] showSuccess:@"展示成功" toView:self.view];
    // [[ProgressExtension shareInstance] showSuccess:@"展示成功" toView:self.view];
    [[MBProgressHUDExtreme shareInstance] showError:@"展示失败!!" toView:self.view];
    //  自定义部分临时不可用
    //    [[ProgressExtension shareInstance] createHudToView:self.view title:@"提示" configHud:^(MBProgressHUD * _Nonnull hud, ProgressExtension *pe) {
    //        pe.title(@"new title");
    //        hud.contentColor = [UIColor yellowColor];
    //        pe.titleColor(UIColor.redColor);
    //        pe.bezelBackgroundColor(UIColor.greenColor);
    //        pe.hudBackgroundColor([[UIColor blueColor] colorWithAlphaComponent:0.2]);
    //    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

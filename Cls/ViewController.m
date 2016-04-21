//
//  ViewController.m
//  扇形按钮
//
//  Created by jhtxch on 16/4/20.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "ViewController.h"
#import "MainBtn.h"

@interface ViewController ()<MainBtnDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainBtn *view1 = [[MainBtn alloc] initWithFrame:CGRectMake(150, 250, 100, 100)];
    view1.subBtns = @[@"1", @"2", @"3"];
    [self.view addSubview:view1];
    view1.startAngle = M_PI * 1.2;
    view1.angle = M_PI * .8;
    view1.angle = 2 * M_PI;
    view1.delegate = self;
}

- (void)clickBtnWithIndex:(NSInteger)index
{
    NSLog(@"%li",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

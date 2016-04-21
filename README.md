# FanShapeBtn
一个扇形按钮 
添加方法 pod ‘FanShapeBtn’

#使用方法(代码说明)
头文件导入 #improt"MainBtn"
```
MainBtn *view1 = [[MainBtn alloc] initWithFrame:CGRectMake(100, 150, 200, 200)];
    view1.subBtns = @[@"0", @"1", @"2"];
    [self.view addSubview:view1];
    view1.startAngle = M_PI * 1.2;   //开始角度
    view1.angle = M_PI * .8;        //大扇形角度
    view1.delegate = self;         //设置代理
```
代理方法
```
- (void)clickBtnWithIndex:(NSInteger)index
{
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"按钮%li被点击",index] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aler show];
}
```

属性简介
```
@property(nonatomic, strong) UIColor * mainBtnColor;   //gif图红色按钮颜色
@property(nonatomic, strong) UIColor * subBtnColor;    //gif图小扇形颜色
@property(nonatomic, strong) UIColor * lineColor;     //gif图线断颜色
@property (nonatomic, strong) NSArray *subBtns;       //数组 用于显示有几个小扇形
@property (nonatomic, assign) CGFloat startAngle;     //起始角度
@property (nonatomic, assign) CGFloat angle;          //大扇形角度
@property (nonatomic, assign) id<MainBtnDelegate> delegate; //点击小扇形回调的代理
```








![fanbtn](https://github.com/GithubChinaCH/FanShapeBtn/raw/master/fanbtn.gif)

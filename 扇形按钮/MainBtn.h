//
//  MainBtn.h
//  扇形按钮
//
//  Created by jhtxch on 16/4/21.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainBtnDelegate <NSObject>

@optional
- (void)clickBtnWithIndex:(NSInteger)index;

@end


@interface MainBtn : UIView

@property(nonatomic, strong) UIColor * mainBtnColor;
@property(nonatomic, strong) UIColor * subBtnColor;
@property(nonatomic, strong) UIColor * lineColor;

@property (nonatomic, strong) NSArray *subBtns;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) id<MainBtnDelegate> delegate;


@end

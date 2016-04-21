
//
//  MainBtn.m
//  扇形按钮
//
//  Created by jhtxch on 16/4/21.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "MainBtn.h"
#import "FanBtn.h"
#import <objc/runtime.h>

#define Kcenter      CGPointMake(KselfWid / 2, KselfHlt / 2)
#define KcenterX     Kcenter.x
#define KcenterY     Kcenter.y
#define Kradius      KselfWid / 2
#define KselfHlt     self.frame.size.height
#define KselfWid     self.frame.size.width
#define KselfX       self.frame.origin.x
#define KselfY       self.frame.origin.y


@interface CAAnimation (animationName)

@property (nonatomic, copy) NSString *name;

@end

static const NSString *AnimationNameKey = @"AnimationNameKey";

@implementation CAAnimation (animationName)

- (void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, &AnimationNameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name
{
    return objc_getAssociatedObject(self, &AnimationNameKey);
}

- (id)copy
{
    CAAnimation *animation = [super copy];
    animation.name = self.name;
    return animation;
}
@end


@interface MainBtn ()<FanBtnDelegate>
{
    CAShapeLayer *_shapeLayer;
    UIImageView *_centerView;
    BOOL _isShow;
    CGFloat _eachAngle;
    NSMutableArray *_btnsAry;
}

@end

@implementation MainBtn

- (void)initShapeLayer
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, KcenterX, KcenterY);
    CGPathAddArc(path, NULL, KcenterX, KcenterY, Kradius - 1, self.startAngle, self.startAngle + self.angle, 0);
    CGPathCloseSubpath(path);
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = self.layer.bounds;
    _shapeLayer.position = Kcenter;
    _shapeLayer.path = path;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.fillColor = nil;
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.lineJoin = kCALineJoinBevel;
    _shapeLayer.strokeEnd = 0;
    [self.layer addSublayer:_shapeLayer];
    [self.layer insertSublayer:_shapeLayer below:_centerView.layer];
    
    CGPathRelease(path);
}



#pragma mark - init
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        [self initDefault];
    }
    return self;
}

- (void)initDefault
{
    _isShow = NO;
    _startAngle = M_PI;
    _angle = 2 * M_PI ;
    _subBtnColor = [UIColor yellowColor];
    _lineColor = [UIColor redColor];
    _mainBtnColor = [UIColor redColor];
    
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KselfWid / 2, KselfHlt / 2)];
    _centerView.userInteractionEnabled = YES;
    _centerView.layer.cornerRadius = KselfWid / 4;
    _centerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _centerView.layer.shadowOffset = CGSizeMake(2, 2);
    _centerView.layer.shadowOpacity = .7;
    _centerView.layer.shadowRadius = 5;
    _centerView.center = CGPointMake(KselfWid / 2, KselfHlt / 2);
    [self addSubview:_centerView];
    
    [_centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHid)]];
}
#pragma mark - init subBtn
- (void)initSubBtn
{
    if (!_btnsAry) {
        _btnsAry  = [NSMutableArray array];
        CGFloat eachAngle = self.angle / self.subBtns.count;
        for (int index = 0; index < self.subBtns.count; index ++) {
            FanBtn *btn = [[FanBtn alloc] initWithFrame:CGRectMake(0, 0, Kradius * 2, Kradius * 2)];
            btn.tag = 100 + index;
            btn.alpha = 0;
            btn.hidden = YES;
            btn.backgroundColor = [UIColor clearColor];
            btn.circleCenter = _centerView.center;
            btn.radius = Kradius;
            btn.angle = eachAngle;
            btn.delegate = self;
            btn.startAngle = self.startAngle + index * eachAngle;
            [self addSubview:btn];
            [self insertSubview:btn belowSubview:_centerView];
            [_btnsAry addObject:btn];
        }
    }
}

- (void)showSubBtnAnimation:(NSInteger )index
{
    
    FanBtn *btn = (FanBtn *)[self viewWithTag:100 + index];
    if (btn) {
        [UIView animateWithDuration:(2.0f / self.subBtns.count) animations:^{
            btn.hidden = NO;
            btn.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self showSubBtnAnimation:index + 1];
        }];
    }else{
        return;
    }
}

- (void)hidSubBtnAnimation:(NSInteger)index
{
    FanBtn *btn = (FanBtn *)[self viewWithTag:100 + index];
    if (btn) {
        [UIView animateWithDuration:(2.0f / self.subBtns.count) animations:^{
            btn.alpha = 0;
        } completion:^(BOOL finished) {
            btn.hidden = YES;
            [self hidSubBtnAnimation:index - 1];
        }];
    }else{
        return;
    }
}
#pragma mark - layout 
- (void)layoutSubviews
{
    _centerView.backgroundColor = self.mainBtnColor;
    _shapeLayer.strokeColor = self.lineColor.CGColor;
    for (FanBtn *btn in _btnsAry) {
        NSInteger index = [_btnsAry indexOfObject:btn];
        btn.lineColor = self.lineColor;
        btn.btnColor = self.subBtnColor;
        btn.text = self.subBtns[index];
    }
    [self initShapeLayer];
}

#pragma mark - show hid
- (void)showOrHid
{
    _centerView.userInteractionEnabled = NO;
    
    if (_isShow) {
        [self hidBtn];
        [self strokeEndAnimation:_shapeLayer start:NO];
        [self hidSubBtnAnimation:2];
    }else{
        [self strokeEndAnimation:_shapeLayer start:YES];
        [self showBtn];
    }
}

- (void)showBtn
{
    [self scaleDown:_centerView];
    _isShow = YES;
}

- (void)hidBtn
{
    [self scaleUp:_centerView];
    _isShow = NO;
}

#pragma mark - animation
- (void)scaleDown:(UIView *)view
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.values = @[@1, @1.1, @.5];
    animation.duration = .6;
    animation.keyTimes = @[@.1, @.3, @1];
    animation.delegate = self;
    animation.name = @"scaleDown";
    [view.layer addAnimation:animation forKey:nil];
}
- (void)scaleUp:(UIView *)view
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.values = @[@.5, @1.1, @1];
    animation.duration = .6;
    animation.keyTimes = @[@.1, @.8, @1];
    animation.delegate = self;
    animation.name = @"scaleUp";
    [view.layer addAnimation:animation forKey:nil];
}
- (void)strokeEndAnimation:(CAShapeLayer *)shapeLayer start:(BOOL)start
{
    [shapeLayer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (start) {
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.name = @"drawLine";
    }else{
        animation.fromValue = @1;
        animation.toValue = @0;
        animation.name = @"eraseLine";
    }
    animation.duration = 2.0f;// * self.angle / (2 * M_PI);
    animation.delegate = self;
    [shapeLayer addAnimation:animation forKey:nil];
}
- (void)strokeStartAnimation:(CAShapeLayer *)shapeLayer
{
    [shapeLayer removeAllAnimations];
    [CATransaction flush];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.fromValue = @0;
    animation.toValue = @1;
    shapeLayer.strokeStart = 1;
//    animation.beginTime = CACurrentMediaTime() + 2.0f * self.angle / (2 * M_PI);
    animation.duration = 2.0f;// * self.angle / (2 * M_PI);
    animation.delegate = self;
    animation.name = @"fadeLine";
    [shapeLayer addAnimation:animation forKey:nil];
    
}

#pragma mark - animation delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    if ([anim.name isEqualToString:@"drawLine"]) {
        [self initSubBtn];
        [self showSubBtnAnimation:0];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim.name isEqualToString:@"scaleDown"]) {
        _centerView.layer.transform = CATransform3DMakeScale(.5, .5, .5);
    }else if ([anim.name isEqualToString:@"scaleUp"]){
        _centerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }else if ([anim.name isEqualToString:@"drawLine"]){
        _centerView.userInteractionEnabled = YES;
    }else if ([anim.name isEqualToString:@"eraseLine"]){
        _centerView.userInteractionEnabled = YES;
    }
}
#pragma mark - fanbtn delegate
- (void)clickBtn:(FanBtn *)btn
{
    if ([self.delegate respondsToSelector:@selector(clickBtnWithIndex:)]) {
        [self.delegate clickBtnWithIndex:btn.tag - 100];
    }
}

#pragma mark - hit
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!_centerView.userInteractionEnabled) {
        return self;
    }
    NSEnumerator *enumertor =[self.subviews reverseObjectEnumerator];
    UIView *view;
    while (view = [enumertor nextObject]) {
        CGPoint hitpoint = [self convertPoint:point toView:_centerView];
        if (view == _centerView && _centerView.userInteractionEnabled && [_centerView pointInside:hitpoint withEvent:event]) {
            return _centerView;
        }
        if ([view isKindOfClass:[FanBtn class]]) {
            FanBtn *btn = (FanBtn *)view;
            if (CGPathContainsPoint(btn.path, nil, point, nil)) {
                return btn;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}


@end

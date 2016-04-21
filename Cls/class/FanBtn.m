//
//  FanBtn.m
//  扇形按钮
//
//  Created by jhtxch on 16/4/20.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "FanBtn.h"
#import <objc/runtime.h>

@interface FanBtn ()
{
    
}

@end
@implementation FanBtn

- (void)dealloc
{
    CGPathRelease(_path);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.opaque = YES;
        self.clipsToBounds = NO;
        _btnColor = [UIColor yellowColor];
        _lineColor = [UIColor redColor];
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - drawrect
- (void)drawRect:(CGRect)rect
{
    [self layoutFanShape];
    CGPoint centerPoint = [self.superview convertPoint:self.circleCenter toView:self];
    CGFloat centerX = centerPoint.x;
    CGFloat centerY = centerPoint.y;
    _path = CGPathCreateMutable();
    [self.btnColor setFill];
    [self.lineColor setStroke];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathMoveToPoint(_path, NULL, centerX, centerY);
    CGPathAddArc(_path, NULL, centerX, centerY, self.radius - 1, self.startAngle, self.startAngle + self.angle, 0);
    CGPathCloseSubpath(_path);
    CGContextAddPath(context, _path);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}
#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (CGPathContainsPoint(_path, nil, [touch locationInView:self], nil)) {
        if ([self.delegate respondsToSelector:@selector(clickBtn:)]) {
            [self.delegate clickBtn:self];
        }
    }
}

#pragma mark layout
- (void)layoutFanShape
{
    //重置frame
    CGRect frame = self.frame;
    CGFloat x = self.circleCenter.x;
    CGFloat y = self.circleCenter.y;
    CGFloat wid = self.radius;
    CGFloat hlt = self.radius;
    frame = CGRectMake(x - wid, y - hlt, wid * 2, hlt * 2);
    self.frame = frame;
}

- (void)layoutTextLabel
{
    self.textLabel.text = self.text;
    self.textLabel.frame = [self.textLabel.text boundingRectWithSize:self.frame.size
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName : self.textLabel.font}
                                      context:nil];
    self.textLabel.center = [self textLabelPoint];
    self.textLabel.transform = CGAffineTransformMakeRotation(self.startAngle + self.angle / 2  + M_PI / 2 + 2 * M_PI);
}

- (void)layoutSubviews
{
    if (!self.textLabel) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.textLabel.font = [UIFont systemFontOfSize:11];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];        
        [self layoutTextLabel];
    }
    
    
}

- (CGPoint)textLabelPoint
{
    CGFloat angle = [self positiveAngelWith:(self.startAngle + self.angle / 2)];
    CGFloat offsetX = cos(angle) * .7 * self.radius;
    CGFloat offsetY = sin(angle) * .7 * self.radius;
    CGPoint point = CGPointMake(self.circleCenter.x + offsetX, self.circleCenter.y + offsetY);
    return point;
}
#pragma mark - other
//将坐标转换为0～2PI
- (CGFloat)positiveAngelWith:(CGFloat)angle
{
    CGFloat num = fabs(angle / M_PI);
    NSInteger count = num;
    count = count / 2;
    if (angle > 0) {
        angle = angle - 2 * M_PI * count;
    }else{
        angle = angle + (count + 1) * 2 * M_PI;
    }
    return angle;
}


@end

//
//  UIImageView+Hexagon.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/6.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "UIImageView+Hexagon.h"

@implementation UIImageView (Hexagon)

- (void)cutHexagonWithImage:(UIImage *)image{
    CGRect rect = self.bounds;
    CALayer *hexagonLayer = [CALayer layer];
    hexagonLayer.frame = CGRectMake(4.0, 4.0, rect.size.width - 8.0, rect.size.height - 8.0);
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.path = [self getHexPathWithWidth:self.frame.size.width - 8.0];
    hexagonLayer.mask = shapeLayer;
    hexagonLayer.contents = (__bridge id _Nullable)image.CGImage;
    CALayer *backgroundLayer = [[CALayer alloc] init];
    backgroundLayer.frame = rect;
    CAShapeLayer *backgroundShapeLayer = [[CAShapeLayer alloc] init];
    backgroundShapeLayer.lineWidth = 1.0;
    backgroundShapeLayer.path = [self getHexPathWithWidth:self.frame.size.width];
    backgroundLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"white"].CGImage);
    backgroundLayer.mask = backgroundShapeLayer;
    CALayer *completeLayer = [CALayer layer];
    completeLayer.frame = rect;
    [completeLayer addSublayer:backgroundLayer];
    [completeLayer addSublayer:hexagonLayer];
    completeLayer.shadowOpacity = 0.3;
    completeLayer.shadowPath = [self getHexPathWithWidth:rect.size.width];
    completeLayer.shadowColor = [UIColor blackColor].CGColor;
    completeLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    [self.layer addSublayer:completeLayer];
}

- (CGPathRef)getHexPathWithWidth:(CGFloat) width{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:CGPointMake(width / 2, 0.0)];
    [path addLineToPoint:CGPointMake(width / 2 * 0.91 + width / 2, width / 4)];
    [path addLineToPoint:CGPointMake(width / 2 * 0.91 + width / 2, width * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, width)];
    [path addLineToPoint:CGPointMake(width / 2 - width / 2 * 0.91, width * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2 - width / 2 * 0.91, width / 4)];
    [path closePath];
    
    return path.CGPath;
}


@end

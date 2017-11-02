/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint rectOrigin;
@property CGSize rectSize;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat rectHeight;
@property CGFloat rectWidth;

@property CGFloat rectTop;
@property CGFloat rectLeft;

@property CGFloat rectBottom;
@property CGFloat rectRight;


/**  控件中心点的x轴坐标*/
@property (assign, nonatomic) CGFloat centerX;
/**  控件中心点的y轴坐标*/
@property (assign, nonatomic) CGFloat centerY;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;
@end
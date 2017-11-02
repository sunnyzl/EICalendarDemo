//
//  DSToast.m
//  DSToast
//
//  Created by LS on 8/18/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import "DSToast.h"
//#import "Utils.h"

@interface DSToast ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) DSToastMaskType maskType;

@end

static CFTimeInterval const kDefaultForwardAnimationDuration = 0.5;
static CFTimeInterval const kDefaultBackwardAnimationDuration = 0.5;
static CFTimeInterval const kDefaultWaitAnimationDuration = 1.0;

static CGFloat const kDefaultTopMargin = 50.0;
static CGFloat const kDefaultBottomMargin = 50.0;
static CGFloat const kDefaultBottomUpperMargin = 120.f;
static CGFloat const kDefalultTextInset = 15.f;

@implementation DSToast

+ (instancetype)toastWithText:(NSString *)text
{
    DSToast *toast = [[DSToast alloc] initWithText:text];
    [toast showInWindow];
    return toast;
}

+ (instancetype)toastWithText:(NSString *)text alignment:(NSTextAlignment)textAlignment showType:(DSToastShowType)showType {
    DSToast *toast = [[DSToast alloc] initWithText:text];
    [toast showInWindowWithAlignment:textAlignment showType:showType];
    return toast;
}

+ (instancetype)toastWithText:(NSString *)text alignment:(NSTextAlignment)textAlignment showType:(DSToastShowType)showType maskType:(DSToastMaskType)maskType {
    DSToast *toast = [[DSToast alloc] initWithText:text];
    [toast showInWindowWithAlignment:textAlignment showType:showType maskType:maskType];
    return toast;
}

- (instancetype)initWithText:(NSString *)text
{
    self = [self initWithFrame:CGRectZero];
    if(self)
    {
        self.text = text;
        [self sizeToFit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.forwardAnimationDuration = kDefaultForwardAnimationDuration;
        self.backwardAnimationDuration = kDefaultBackwardAnimationDuration;
        self.textInsets = UIEdgeInsetsMake(kDefalultTextInset, kDefalultTextInset, kDefalultTextInset, kDefalultTextInset);
        self.maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds])*0.9;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14.0];
    }
    
    return self;
}

#pragma mark - Show Method

- (void)showInWindow {
    [self showInWindowWithAlignment:NSTextAlignmentCenter showType:DSToastShowTypeBottomUpper];
}

- (void)showInWindowWithAlignment:(NSTextAlignment)textAlignment showType:(DSToastShowType)type {
    [self showInWindowWithAlignment:textAlignment showType:type maskType:DSToastMaskTypeClearMask];
}

- (void)showInWindowWithAlignment:(NSTextAlignment)textAlignment showType:(DSToastShowType)type maskType:(DSToastMaskType)maskType {
    [self addAnimationGroup];
    CGPoint point = [self keyWindow].center;
    self.textAlignment = textAlignment;
    switch (type) {
        case DSToastShowTypeTop: {
            point.y = kDefaultTopMargin;
            break;
        }
        case DSToastShowTypeCenter: {
            
            break;
        }
        case DSToastShowTypeBottomUpper: {
            point.y = CGRectGetHeight([self keyWindow].bounds) - kDefaultBottomUpperMargin;
            break;
        }
        case DSToastShowTypeBottom: {
            point.y = CGRectGetHeight([self keyWindow].bounds) - kDefaultBottomMargin;
            break;
        }
    }
    self.center = point;
    self.maskType = maskType;
    switch (maskType) {
        case DSToastMaskTypeNone: {
            [[self keyWindow] addSubview:self];
            break;
        }
        case DSToastMaskTypeClearMask: {
            [self.coverView addSubview:self];
            break;
        }
    }
}

- (UIWindow *)keyWindow {
    NSArray *windowSubViews = [[[[UIApplication sharedApplication] windows] lastObject] subviews];
    if (windowSubViews.count > 0) {
        for (UIView *keyboard in windowSubViews) {
            if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) || ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) || ([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)){
                
                return [[UIApplication sharedApplication] windows].lastObject;
            }
        }
        
    }
    return [UIApplication sharedApplication].keyWindow;

}

- (UIView *)coverView {
    if (nil == _coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor clearColor];
        _coverView.frame = [self keyWindow].bounds;
        [[self keyWindow] addSubview:_coverView];
    }
    return _coverView;
}

#pragma mark - Animation

- (void)addAnimationGroup
{
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = self.forwardAnimationDuration;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    CABasicAnimation *backwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    backwardAnimation.duration = self.backwardAnimationDuration;
    backwardAnimation.beginTime = forwardAnimation.duration + kDefaultWaitAnimationDuration;
    backwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.15f :0.5f :-0.7f];
    backwardAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    backwardAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[forwardAnimation,backwardAnimation];
    animationGroup.duration = forwardAnimation.duration + backwardAnimation.duration + kDefaultWaitAnimationDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
    {
        switch (self.maskType) {
            case DSToastMaskTypeNone: {
                [self removeFromSuperview];
                break;
            }
            case DSToastMaskTypeClearMask: {
                [self.coverView removeFromSuperview];
                break;
            }
        }
    }
}

#pragma mark - Text Configurate
- (void)sizeToFit
{
    [super sizeToFit];
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(self.bounds) + self.textInsets.left + self.textInsets.right;
    frame.size.width = width > self.maxWidth ? width : self.maxWidth;
    frame.size.height = CGRectGetHeight(self.bounds) + self.textInsets.top + self.textInsets.bottom;
    self.frame = frame;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
   bounds.size = [self.text boundingRectWithSize:CGSizeMake(self.maxWidth - self.textInsets.left - self.textInsets.right,
                                               CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    return bounds;
}

@end

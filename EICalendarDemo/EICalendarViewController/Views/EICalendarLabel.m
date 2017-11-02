//
//  EICalendarLabel.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/29.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarLabel.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EICalendarLabel ()
@property (assign, nonatomic) BOOL isFirstIncome;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation EICalendarLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isFirstIncome = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setupContentLabelConstrains];
    }
    return self;
}

- (void)setupContentLabelConstrains {
    @weakify(self);
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];
}

- (void)setCornerBackgroundColor:(UIColor *)cornerBackgroundColor {
    _cornerBackgroundColor = cornerBackgroundColor;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    [self.cornerBackgroundColor setFill];
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.contentLabel.text = _text;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.contentLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.contentLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.contentLabel.textAlignment = textAlignment;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}


@end

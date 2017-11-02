//
//  EICalendarRangeCellCoverView.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/25.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarRangeCellCoverView.h"
#import "UIColor+CMOHex.h"

@interface EICalendarRangeCellCoverView ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UIView *coverView;

@property (assign, nonatomic) BOOL isNeedLayout;

@end

@implementation EICalendarRangeCellCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.coverView];
    }
    return self;
}

- (void)setCoverViewType:(EICalendarRangeCellCoverViewType)coverViewType {
    _coverViewType = coverViewType;
    self.isNeedLayout = YES;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    if (self.isNeedLayout) {
        switch (self.coverViewType) {
            case EICalendarRangeCellCoverViewTypeLeft:
                rect = CGRectMake(rect.size.width / 2.f, rect.origin.y, rect.size.width / 2.f, rect.size.height);
                break;
            case EICalendarRangeCellCoverViewTypeMid:
                break;
            case EICalendarRangeCellCoverViewTypeRight:
                rect = CGRectMake(0, rect.origin.y, rect.size.width / 2.f, rect.size.height);
                break;
        }
        self.coverView.frame = rect;
    }
    
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [UIView new];
        _coverView.backgroundColor = kRGBColorFromHex(90D8E0);
    }
    return _coverView;
}


@end

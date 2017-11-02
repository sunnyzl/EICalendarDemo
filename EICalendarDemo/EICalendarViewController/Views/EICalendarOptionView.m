//
//  EICalendarOptionView.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/28.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarOptionView.h"
#import "EICalendarOptionButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static CGFloat const EICalendarOptionLeftRightPadding = 14.f;
static CGFloat const EICalendarOptionTopBottomPadding = 6.f;
static CGFloat const EICalendarOptionPaddingBetweenTwoButton = 7.f;

@interface EICalendarOptionView ()

@property (assign, nonatomic) BOOL isFirstIncome;

@end

@implementation EICalendarOptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.isFirstIncome = YES;
    [self setupBtnWithTitle:@"今日" type:EICalendarOptionViewButtonTypeToday];
    [self setupBtnWithTitle:@"本周" type:EICalendarOptionViewButtonTypeThisWeek];
    [self setupBtnWithTitle:@"本月" type:EICalendarOptionViewButtonTypeThisMonth];
    [self setupBtnWithTitle:@"上周" type:EICalendarOptionViewButtonTypePreWeek];
    [self setupBtnWithTitle:@"上月" type:EICalendarOptionViewButtonTypePreMonth];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isFirstIncome) {
        UIButton *firstBtn = nil;
        CGFloat btnWidth = (self.bounds.size.width - EICalendarOptionLeftRightPadding * 2 - EICalendarOptionPaddingBetweenTwoButton * (self.subviews.count - 1)) / self.subviews.count;
        for (NSInteger index = 0; index < self.subviews.count; index++) {
            UIButton *button = self.subviews[index];
            @weakify(self);
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(self).offset(EICalendarOptionTopBottomPadding);
                make.bottom.equalTo(self).offset(-EICalendarOptionTopBottomPadding);
                make.width.mas_equalTo(btnWidth);
            }];
            if (firstBtn == nil) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self);
                    make.left.equalTo(self).offset(EICalendarOptionLeftRightPadding);
                }];
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(firstBtn.mas_right).offset(EICalendarOptionPaddingBetweenTwoButton);
                }];
            }
            if (index != (self.subviews.count - 1)) {
                firstBtn = button;
            }
        }
        self.isFirstIncome = NO;
    }
}

- (UIButton *)setupBtnWithTitle:(NSString *)title type:(EICalendarOptionViewButtonType)type
{
    EICalendarOptionButton *btn = [EICalendarOptionButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(optionView:didClickButton:)]) {
        //        NSUInteger index = (NSUInteger)(btn.x / btn.width);
        [self.delegate optionView:self didClickButton:btn.tag];
    }
}


@end

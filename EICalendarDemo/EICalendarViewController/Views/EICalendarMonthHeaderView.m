//
//  EICalendarMonthHeaderView.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/25.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarMonthHeaderView.h"
#import "EICalendarViewFlowLayout.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "UIColor+CMOHex.h"


static CGFloat const  EICalendarHeaderTextSize = 15.f;

@interface EICalendarMonthHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) EICalendarViewFlowLayout *flowLayout;
@property (assign, nonatomic) NSInteger weekdaySerialNumber;
@property (assign, nonatomic) BOOL isNeedLayout;
@property (assign, nonatomic) BOOL isFirstIncome;

@end

@implementation EICalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isFirstIncome = YES;
    }
    return self;
}

- (void)setupFirstDayOfMonth:(NSDate *)date calendar:(NSCalendar *)calendar {
    
    NSDateFormatter *headerDateFormatter = [[NSDateFormatter alloc] init];
    headerDateFormatter.calendar = calendar;
    headerDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"L" options:0 locale:calendar.locale];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:date];
    self.weekdaySerialNumber = components.weekday;
    
    if (self.flowLayout == nil) {
        self.flowLayout = [[EICalendarViewFlowLayout alloc] initWithDaysPerWeek:[calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length];
    }
    NSString *monthSerial = [[headerDateFormatter stringFromDate:date] uppercaseString];
    self.titleLabel.text = monthSerial;
    NSString *todayOfMonth = [[headerDateFormatter stringFromDate:[NSDate date]] uppercaseString];
    if ([todayOfMonth isEqualToString:monthSerial]) {
        self.titleLabel.textColor = self.todayOfMonthTextColor;
    } else {
        self.titleLabel.textColor = self.textColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    if (self.isNeedLayout) {
    @weakify(self);
    if (self.isFirstIncome) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(self.flowLayout.itemWidthAndHeight);
            make.left.mas_equalTo((self.weekdaySerialNumber - 1) * self.flowLayout.itemWidthAndHeight + self.flowLayout.leftRightPadding);
        }];
        self.isFirstIncome = NO;
        //    }
    } else {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo((self.weekdaySerialNumber - 1) * self.flowLayout.itemWidthAndHeight + EICalendarFlowLayoutInsetLeftRight + self.flowLayout.leftRightPadding);
        }];
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = self.textColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = self.textFont;
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

#pragma mark - Colors

- (UIColor *)textColor
{
    if(_textColor == nil) {
        _textColor = [[[self class] appearance] textColor];
    }
    
    if(_textColor != nil) {
        return _textColor;
    }
    
    return kRGBColorFromHex(222222);
}

- (UIColor *)todayOfMonthTextColor {
    if (_todayOfMonthTextColor == nil) {
        _todayOfMonthTextColor = [[[self class] appearance] todayOfMonthTextColor];
    }
    if (_todayOfMonthTextColor) {
        return _todayOfMonthTextColor;
    }
    return kRGBColorFromHex(FFB400);
}

- (UIFont *)textFont
{
    if(_textFont == nil) {
        _textFont = [[[self class] appearance] textFont];
    }
    
    if(_textFont != nil) {
        return _textFont;
    }
    
    return [UIFont systemFontOfSize:EICalendarHeaderTextSize];
}


@end

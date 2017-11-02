//
//  EICalendarWeekdayHeaderView.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/25.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const EICalendarWeekdayHeaderSize;
UIKIT_EXTERN CGFloat const EICalendarWeekdayHeaderHeight;

typedef NS_ENUM(NSInteger, EICalendarViewWeekdayTextType) {
    EICalendarViewWeekdayTextTypeVeryShort = 0,
    EICalendarViewWeekdayTextTypeShort,
    EICalendarViewWeekdayTextTypeStandAlone
};

@interface EICalendarWeekdayHeaderView : UIView

/**
 利用calendar进行初始化

 @param calendar 日历calendar
 @param textType textType
 @return EICalendarWeekdayHeaderView
 */
- (instancetype)initWithCalendar:(NSCalendar *)calendar weekdayTextType:(EICalendarViewWeekdayTextType)textType;


/**
 设置字体颜色
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;


/**
 设置字体大小
 */
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;


/**
 设置背景颜色
 */
@property (nonatomic, strong) UIColor *headerBackgroundColor UI_APPEARANCE_SELECTOR;

@end

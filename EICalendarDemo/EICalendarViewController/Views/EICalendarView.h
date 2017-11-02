//
//  EICalendarView.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/21.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EICalendarWeekdayHeaderView.h"

UIKIT_EXTERN NSCalendarUnit const EICalendarUnitYMD;

@interface EICalendarView : UIView


@property (nonatomic, strong, readonly) NSCalendar *calendar;

/**
 日历开始的日期，若不设置，默认为当天
 */
@property (strong, nonatomic) NSDate *firstDate;

/**
 日历结束的日期
 */
@property (strong, nonatomic) NSDate *lastDate;
////  默认选择范围时
///**
// 当前选中的开始日期
// */
//@property (strong, nonatomic) NSDate *startDate;
//
///**
// 当前选中的结束日期
// */
//@property (strong, nonatomic) NSDate *endDate;

/**
 当前选中的开始日期
 */
@property (strong, readonly, nonatomic) NSDate *startDate;

/**
 当前选中的结束日期
 */
@property (strong, readonly, nonatomic) NSDate *endDate;

/**
 滚动页面时浮动显示年份和月份
 */
@property (nonatomic, strong) UIColor *overlayTextColor;

- (instancetype)initWithCalendar:(NSCalendar *)calendar;

- (instancetype)initWithCalendar:(NSCalendar *)calendar weekdayTextType:(EICalendarViewWeekdayTextType)weekdayTextType;

@end



//
//  EICalendarMonthHeaderView.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/25.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EICalendarMonthHeaderView : UICollectionReusableView

/**
 头部月份的字体颜色
 */
@property (strong, nonatomic) UIColor *textColor UI_APPEARANCE_SELECTOR;

/**
 今日对应月份的字体颜色
 */
@property (strong, nonatomic) UIColor *todayOfMonthTextColor UI_APPEARANCE_SELECTOR;

/**
 头部月份的字体大小
 */
@property (strong, nonatomic) UIFont *textFont UI_APPEARANCE_SELECTOR;

/**
 设置该月第一天的日期，和所属日历

 @param date 该月第一天的日期
 @param calendar 所属日历
 */
- (void)setupFirstDayOfMonth:(NSDate *)date calendar:(NSCalendar *)calendar;

@end

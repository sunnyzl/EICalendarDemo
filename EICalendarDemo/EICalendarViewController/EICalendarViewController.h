//
//  EICalendarViewController.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/21.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EICalendarViewController;

@protocol EICalendarViewControllerDelegate <NSObject>
@optional
- (void)calendarViewController:(EICalendarViewController *)viewController calendar:(NSCalendar *)calendar startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)calendarViewController:(EICalendarViewController *)viewController calendar:(NSCalendar *)calendar startDateString:(NSString *)startDateString endDateString:(NSString *)endDateString;
@end

@interface EICalendarViewController : UIViewController

@property (weak, nonatomic) id <EICalendarViewControllerDelegate> delegate;

@end

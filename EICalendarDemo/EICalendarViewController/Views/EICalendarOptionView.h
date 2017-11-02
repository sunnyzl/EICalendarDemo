//
//  EICalendarOptionView.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/28.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EICalendarOptionViewButtonType) {
    EICalendarOptionViewButtonTypeToday,
    EICalendarOptionViewButtonTypeThisWeek,
    EICalendarOptionViewButtonTypeThisMonth,
    EICalendarOptionViewButtonTypePreWeek,
    EICalendarOptionViewButtonTypePreMonth
};
@class EICalendarOptionView;

@protocol EICalendarOptionViewDelegate <NSObject>

@optional
- (void)optionView:(EICalendarOptionView *)optionView didClickButton:(EICalendarOptionViewButtonType)buttonType;
@end

@interface EICalendarOptionView : UIView


@property (nonatomic, weak) id <EICalendarOptionViewDelegate> delegate;

@end

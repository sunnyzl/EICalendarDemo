//
//  EICalendarLabel.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/29.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EICalendarLabel : UIView

@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) UIColor *cornerBackgroundColor;

@end

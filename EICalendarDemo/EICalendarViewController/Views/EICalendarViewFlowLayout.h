//
//  EICalendarViewFlowLayout.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/21.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN CGFloat const EICalendarFlowLayoutMinInterItemSpacing;
UIKIT_EXTERN CGFloat const EICalendarFlowLayoutMinLineSpacing;
UIKIT_EXTERN CGFloat const EICalendarFlowLayoutInsetTop;
UIKIT_EXTERN CGFloat const EICalendarFlowLayoutInsetLeftRight;
UIKIT_EXTERN CGFloat const EICalendarFlowLayoutInsetBottom;
UIKIT_EXTERN CGFloat const EICalendarFlowLayoutHeaderHeight;


@interface EICalendarViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat leftRightPadding;
@property (assign, nonatomic) CGFloat itemWidthAndHeight;

- (instancetype)initWithDaysPerWeek:(NSInteger)daysPerWeek;

@end

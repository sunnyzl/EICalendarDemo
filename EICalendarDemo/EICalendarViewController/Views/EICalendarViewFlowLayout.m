//
//  EICalendarViewFlowLayout.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/21.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarViewFlowLayout.h"

#define SCREENWIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT               [UIScreen mainScreen].bounds.size.height


CGFloat const EICalendarFlowLayoutMinInterItemSpacing = 0.f;
CGFloat const EICalendarFlowLayoutMinLineSpacing = 0.f;
CGFloat const EICalendarFlowLayoutInsetTop = 5.f;
CGFloat const EICalendarFlowLayoutInsetLeftRight = 5.f;
CGFloat const EICalendarFlowLayoutInsetBottom = 5.f;
CGFloat const EICalendarFlowLayoutHeaderHeight = 30.f;

@implementation EICalendarViewFlowLayout


- (instancetype)initWithDaysPerWeek:(NSInteger)daysPerWeek {
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        NSInteger padding = (NSInteger)(SCREENWIDTH - 2 * EICalendarFlowLayoutInsetLeftRight) % daysPerWeek;
        CGFloat leftRightPadding = (CGFloat)padding / 2.f;
        self.leftRightPadding = leftRightPadding + EICalendarFlowLayoutInsetLeftRight;
        CGFloat cellWH = (SCREENWIDTH - 2 * EICalendarFlowLayoutInsetLeftRight - padding) / (CGFloat)daysPerWeek;
        self.itemWidthAndHeight = cellWH;
        self.itemSize = CGSizeMake(cellWH , cellWH);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(EICalendarFlowLayoutInsetTop,
                                             EICalendarFlowLayoutInsetLeftRight + leftRightPadding,
                                             EICalendarFlowLayoutInsetBottom,
                                             EICalendarFlowLayoutInsetLeftRight + leftRightPadding);
        self.headerReferenceSize = CGSizeMake(0, EICalendarFlowLayoutHeaderHeight);
    }
    return self;
}


@end

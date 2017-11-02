//
//  EICalendarEnum.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/27.
//  Copyright © 2016年 cmos. All rights reserved.
//

#ifndef EICalendarEnum_h
#define EICalendarEnum_h

typedef NS_ENUM(NSInteger, EICalendarRangeCellType) {
    EICalendarRangeCellTypeNone,
    EICalendarRangeCellTypeDisabled,
    EICalendarRangeCellTypeNormal,
    EICalendarRangeCellTypeToday
};

typedef NS_ENUM(NSInteger, EICalendarRangeCellSelectedState) {
    EICalendarRangeCellSelectedStateNone,
    EICalendarRangeCellSelectedStateStart,
    EICalendarRangeCellSelectedStateStartWithEnd,
    EICalendarRangeCellSelectedStateMid,
    EICalendarRangeCellSelectedStateEnd,
    EICalendarRangeCellSelectedStateEndEqualStart,
};

typedef NS_ENUM(NSInteger, EICalendarRangeCellTipsState) {
    EICalendarRangeCellTipsStateNone,
    EICalendarRangeCellTipsStateShow
};

typedef NS_ENUM(NSInteger, EICalendarRangeCellCoverViewType) {
    EICalendarRangeCellCoverViewTypeLeft    = 1 << 1,
    EICalendarRangeCellCoverViewTypeMid     = 1 << 2,
    EICalendarRangeCellCoverViewTypeRight   = 1 << 3
};
#endif /* EICalendarEnum_h */

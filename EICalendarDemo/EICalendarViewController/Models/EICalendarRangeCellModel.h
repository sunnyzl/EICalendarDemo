//
//  EICalendarRangeCellModel.h
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/26.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EICalendarEnum.h"

@interface EICalendarRangeCellModel : NSObject

@property (assign, nonatomic) EICalendarRangeCellType cellType;
@property (assign, nonatomic) EICalendarRangeCellSelectedState cellSelectedState;
@property (copy, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSDate *cellDayOfIndexPath;


@end

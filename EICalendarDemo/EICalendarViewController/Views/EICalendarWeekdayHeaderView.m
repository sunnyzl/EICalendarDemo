//
//  EICalendarWeekdayHeaderView.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/25.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarWeekdayHeaderView.h"
#import "EICalendarViewFlowLayout.h"
#import <Masonry/Masonry.h>
#import "UIColor+CMOHex.h"

CGFloat const EICalendarWeekdayHeaderSize = 15.f;
CGFloat const EICalendarWeekdayHeaderHeight = 30.f;

@implementation EICalendarWeekdayHeaderView

- (instancetype)initWithCalendar:(NSCalendar *)calendar weekdayTextType:(EICalendarViewWeekdayTextType)textType {
    if (self = [super init]) {
        self.backgroundColor = self.headerBackgroundColor;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = calendar;
        
        NSArray *weekdaySymbols = [self symbolArrayWithDateFormatter:dateFormatter textType:textType];
        
        NSMutableArray *adjustedSymbols = [NSMutableArray arrayWithArray:weekdaySymbols];
        for (NSInteger index = 0; index < (1 - calendar.firstWeekday + weekdaySymbols.count); index++) {
            NSString *lastObject = [adjustedSymbols lastObject];
            [adjustedSymbols removeLastObject];
            [adjustedSymbols insertObject:lastObject atIndex:0];
        }
        if (adjustedSymbols.count == 0) {
            return self;
        }
        
        
        EICalendarViewFlowLayout *layout = [[EICalendarViewFlowLayout alloc] initWithDaysPerWeek:[calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length];
//        UILabel *firstLabel = nil;
        for (NSInteger index = 0; index < adjustedSymbols.count; index ++) {
            UILabel *weekdaySymbolLabel = [[UILabel alloc] init];
            weekdaySymbolLabel.font = self.textFont;
            weekdaySymbolLabel.text = [adjustedSymbols[index] uppercaseString];
            weekdaySymbolLabel.textColor = self.textColor;
            weekdaySymbolLabel.textAlignment = NSTextAlignmentCenter;
            weekdaySymbolLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:weekdaySymbolLabel];
            
            [weekdaySymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.mas_equalTo(layout.leftRightPadding + layout.itemWidthAndHeight * index);
                make.width.mas_equalTo(layout.itemWidthAndHeight);
            }];
        }
    }
    return self;
}

- (NSArray *)symbolArrayWithDateFormatter:(NSDateFormatter *)dateFormatter textType:(EICalendarViewWeekdayTextType)textType {
    switch (textType) {
        case EICalendarViewWeekdayTextTypeVeryShort:
            return [dateFormatter veryShortWeekdaySymbols];
            break;
        case EICalendarViewWeekdayTextTypeShort:
            return [dateFormatter shortWeekdaySymbols];
            break;
        case EICalendarViewWeekdayTextTypeStandAlone:
            return [dateFormatter standaloneWeekdaySymbols];
            break;
    }
}

- (UIColor *)textColor
{
    if(_textColor == nil) {
        _textColor = [[[self class] appearance] textColor];
    }
    
    if(_textColor != nil) {
        return _textColor;
    }
    
    return [UIColor blackColor];
}

- (UIFont *)textFont
{
    if(_textFont == nil) {
        _textFont = [[[self class] appearance] textFont];
    }
    
    if(_textFont != nil) {
        return _textFont;
    }
    
    return [UIFont systemFontOfSize:EICalendarWeekdayHeaderSize];
}

- (UIColor *)headerBackgroundColor
{
    if(_headerBackgroundColor == nil) {
        _headerBackgroundColor = [[[self class] appearance] headerBackgroundColor];
    }
    
    if(_headerBackgroundColor != nil) {
        return _headerBackgroundColor;
    }
    
    return kRGBColorFromHex(D9F2F3);
}



@end

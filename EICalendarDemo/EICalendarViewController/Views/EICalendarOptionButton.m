//
//  EICalendarOptionButton.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/28.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarOptionButton.h"
#import "UIColor+CMOHex.h"

@implementation EICalendarOptionButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layer.borderColor = [kRGBColorFromHex(02C1CD) CGColor];
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    [self setTitleColor:kRGBColorFromHex(02C1CD) forState:UIControlStateNormal];
}


@end

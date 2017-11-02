//
//  UIView+CMOExtention.m
//  ElectronicInvoice
//
//  Created by zhaoliang on 16/8/30.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import "UIView+CMOExtention.h"

@implementation UIView (CMOViewStatus)


- (void)cmo_viewEnabled:(BOOL)enabled colorWithAlphaComponent:(CGFloat)alpha {
    self.userInteractionEnabled = enabled;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:alpha];
}
@end

@implementation UIButton (CMOButtonStatus)


- (void)cmo_buttonEnabled:(BOOL)enabled colorWithAlphaComponent:(CGFloat)alpha{
//    self.enabled = enabled;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:alpha];
    [self setTitleColor:[self.currentTitleColor colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
}
@end

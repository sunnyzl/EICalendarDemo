//
//  UIView+CMOExtention.h
//  ElectronicInvoice
//
//  Created by zhaoliang on 16/8/30.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CMOViewStatus)

- (void)cmo_viewEnabled:(BOOL)enabled colorWithAlphaComponent:(CGFloat)alpha;

@end

@interface UIButton (CMOButtonStatus)

- (void)cmo_buttonEnabled:(BOOL)enabled colorWithAlphaComponent:(CGFloat)alpha;

@end

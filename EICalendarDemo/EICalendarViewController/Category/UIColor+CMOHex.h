//
//  UIColor+CMOHex.h
//  ElectronicInvoice
//
//  Created by zhaoliang on 16/8/22.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRGBColorFromHex(rgbValue)  RGBColorFromHex(@((#rgbValue)))
#define kRGBColorFromHexAndAlpha(rgbValue, alphaValue) RGBColorFromHexAndAlpha(@((#rgbValue)), (alphaValue))

@interface UIColor (CMOHex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

static inline UIColor *RGBColorFromHex(NSString *rgbValue) {
    return [UIColor colorWithHexString:rgbValue];
}

static inline UIColor *RGBColorFromHexAndAlpha(NSString *rgbValue, CGFloat alphaValue) {
    return [UIColor colorWithHexString:rgbValue alpha:alphaValue];
}

static inline UIColor *kRGBAColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

static inline UIColor *kRGBColor(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.f];
}

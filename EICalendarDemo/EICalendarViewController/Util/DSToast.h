//
//  DSToast.h
//  DSToast
//
//  Created by LS on 8/18/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSToastShowType)
{
    DSToastShowTypeTop,
    DSToastShowTypeCenter,
    DSToastShowTypeBottomUpper, //  底部偏上位置
    DSToastShowTypeBottom
};

typedef NS_ENUM(NSInteger, DSToastMaskType) {
    DSToastMaskTypeNone,
    DSToastMaskTypeClearMask
};

@interface DSToast : UILabel

@property (nonatomic, assign) CFTimeInterval forwardAnimationDuration;
@property (nonatomic, assign) CFTimeInterval backwardAnimationDuration;
@property (nonatomic, assign) UIEdgeInsets   textInsets;
@property (nonatomic, assign) CGFloat        maxWidth;

+ (instancetype)toastWithText:(NSString *)text;
+ (instancetype)toastWithText:(NSString *)text
                    alignment:(NSTextAlignment)textAlignment
                     showType:(DSToastShowType)showType;
+ (instancetype)toastWithText:(NSString *)text
                    alignment:(NSTextAlignment)textAlignment
                     showType:(DSToastShowType)showType
                     maskType:(DSToastMaskType)maskType;
- (instancetype)initWithText:(NSString *)text;
- (void)showInWindow; // 默认为DSToastShowTypeBottomUpper 遮罩为DSToastMaskTypeClearMask 文字居中
- (void)showInWindowWithAlignment:(NSTextAlignment)textAlignment
                         showType:(DSToastShowType)type; // 默认遮罩为DSToastMaskTypeClearMask
- (void)showInWindowWithAlignment:(NSTextAlignment)textAlignment
                         showType:(DSToastShowType)type
                         maskType:(DSToastMaskType)maskType;

@end

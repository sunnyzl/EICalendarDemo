//
//  EICalendarRangeCell.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/24.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarRangeCell.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EICalendarRangeCellModel.h"
#import "EICalendarLabel.h"

#import "EICalendarRangeCellCoverView.h"
#import "UIView+CMOExtention.h"
#import "UIViewExt.h"
#import "UIColor+CMOHex.h"

static CGFloat const EICalendarRangeCellContentPadding = 10.f;
static CGFloat const EICalendarRangeCellDividerHeight = 1.f;

@interface EICalendarRangeCell ()

@property (strong, nonatomic) EICalendarLabel *dateLabel;
@property (strong, nonatomic) EICalendarRangeCellCoverView *coverView;
@property (strong, nonatomic) UIView *dividerView;

@property (strong, nonatomic) EICalendarLabel *tipsLabel;

@property (assign, nonatomic) BOOL isFirstIncome;

@end

@implementation EICalendarRangeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.isFirstIncome = YES;
    [self setDividerViewConstraints];
    [self setCoverVIewConstraints];
    [self setDateLabelConstraints];
    [self setTipsLabelConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cornerRadius = (self.bounds.size.width - EICalendarRangeCellContentPadding * 2) * .5f;
    self.dateLabel.cornerRadius = cornerRadius;
}


- (void)setDividerViewConstraints {
    @weakify(self);
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(EICalendarRangeCellDividerHeight);
    }];
}

- (void)setCoverVIewConstraints {
    @weakify(self);
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView).offset(EICalendarRangeCellContentPadding);
        make.bottom.equalTo(self.contentView).offset(-EICalendarRangeCellContentPadding);
        make.left.right.equalTo(self.contentView);
    }];
}

- (void)setTipsLabelConstraints {
    @weakify(self);
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView).offset(-15.f);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(20.f);
        make.width.mas_equalTo(55.f);
    }];
}

- (void)setDateLabelConstraints {
    @weakify(self);
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.right.equalTo(self.contentView).offset(-EICalendarRangeCellContentPadding);
        make.top.left.equalTo(self.contentView).offset(EICalendarRangeCellContentPadding);
    }];
}

- (void)setCellModel:(EICalendarRangeCellModel *)cellModel {
    _cellModel = cellModel;
    self.dateLabel.text = cellModel.dateStr;
    switch (cellModel.cellType) {
        case EICalendarRangeCellTypeNone:
            self.dividerView.hidden = YES;
            self.userInteractionEnabled = NO;
            self.dateLabel.cornerBackgroundColor = [UIColor clearColor];
            break;
        case EICalendarRangeCellTypeDisabled:
            self.dividerView.hidden = NO;
            self.userInteractionEnabled = NO;
            self.dateLabel.cornerBackgroundColor = [UIColor clearColor];
            break;
        case EICalendarRangeCellTypeNormal:
            self.dividerView.hidden = NO;
            self.userInteractionEnabled = YES;
            self.dateLabel.cornerBackgroundColor = [UIColor clearColor];
            break;
        case EICalendarRangeCellTypeToday:
            self.dividerView.hidden = NO;
            self.userInteractionEnabled = YES;
            self.dateLabel.cornerBackgroundColor = kRGBColorFromHex(FFB400);
            break;
    }
    
    switch (cellModel.cellSelectedState) {
        case EICalendarRangeCellSelectedStateNone:
            self.coverView.hidden = YES;
            self.tipsLabel.hidden = YES;
            if (cellModel.cellType == EICalendarRangeCellTypeToday) {
                self.dateLabel.textColor = [UIColor whiteColor];
            } else if (cellModel.cellType == EICalendarRangeCellTypeDisabled) {
                self.dateLabel.textColor = kRGBColorFromHex(999999);
            } else {
                self.dateLabel.textColor = [UIColor blackColor];
            }
            break;
        case EICalendarRangeCellSelectedStateStart:
            self.coverView.hidden = YES;
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"起始时间";
            self.dateLabel.cornerBackgroundColor = kRGBColorFromHex(05CBD8);
            self.dateLabel.textColor = [UIColor whiteColor];
            
            break;
        case EICalendarRangeCellSelectedStateStartWithEnd:
            self.coverView.hidden = NO;
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"起始时间";
            self.coverView.coverViewType = EICalendarRangeCellCoverViewTypeLeft;
            self.dateLabel.cornerBackgroundColor = kRGBColorFromHex(05CBD8);
            self.dateLabel.textColor = kRGBColorFromHex(CFF2F4);
            break;
        case EICalendarRangeCellSelectedStateMid:
            self.coverView.hidden = NO;
            self.tipsLabel.hidden = YES;
            self.coverView.coverViewType = EICalendarRangeCellCoverViewTypeMid;
            self.dateLabel.cornerBackgroundColor = [UIColor clearColor];
            self.dateLabel.textColor = [UIColor whiteColor];
            break;
        case EICalendarRangeCellSelectedStateEnd:
            self.coverView.hidden = NO;
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"结束时间";
            [self.superview bringSubviewToFront:self];
            self.coverView.coverViewType = EICalendarRangeCellCoverViewTypeRight;
            self.dateLabel.cornerBackgroundColor = kRGBColorFromHex(05CBD8);
            self.dateLabel.textColor = [UIColor whiteColor];
            break;
        case EICalendarRangeCellSelectedStateEndEqualStart:
            self.coverView.hidden = YES;
            self.tipsLabel.hidden = NO;
            [self.superview bringSubviewToFront:self];
            self.tipsLabel.text = [self tipsWithDate:cellModel.cellDayOfIndexPath];
            self.dateLabel.cornerBackgroundColor = kRGBColorFromHex(05CBD8);
            self.dateLabel.textColor = [UIColor whiteColor];
            break;
    }
}

- (NSString *)tipsWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM月dd日";
    return [dateFormatter stringFromDate:date];
}

- (EICalendarRangeCellCoverView *)coverView {
    if (_coverView == nil) {
        _coverView = [[EICalendarRangeCellCoverView alloc] init];
        _coverView.hidden = YES;
        [self.contentView addSubview:_coverView];
    }
    return _coverView;
}

- (EICalendarLabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [EICalendarLabel new];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.cornerBackgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:15.f];
        _dateLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (EICalendarLabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [EICalendarLabel new];
        _tipsLabel.hidden = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.cornerBackgroundColor = [UIColor blackColor];
        _tipsLabel.alpha = .5f;
        _tipsLabel.userInteractionEnabled = NO;
        _tipsLabel.font = [UIFont systemFontOfSize:12.f];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.cornerRadius = 5.f;
//        _tipsLabel.layer.cornerRadius = 5.f;
//        _tipsLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

- (UIView *)dividerView {
    if (_dividerView == nil) {
        _dividerView = [UIView new];
        _dividerView.hidden = NO;
        _dividerView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
        [self.contentView addSubview:_dividerView];
    }
    return _dividerView;
}


@end

//
//  EICalendarView.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/21.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarView.h"
#import "EICalendarViewFlowLayout.h"
#import "EICalendarRangeCell.h"
#import "EICalendarMonthHeaderView.h"
#import "EICalendarRangeCellModel.h"
#import "UIColor+CMOHex.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "DSToast.h"


static CGFloat const EICalendarOverlaySize = 14.0f;
static NSTimeInterval const EICalendarOverLayViewAnimationDuration = .25f;


static NSString *const EICalendarViewCellIdentifier = @"com.smrz.InvoiceApp.cell.identifier";
static NSString *const EICalendarViewHeaderIdentifier = @"com.smrz.InvoiceApp.header.identifier";
NSCalendarUnit const EICalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

@interface EICalendarView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *overlayView;

@property (strong, nonatomic) NSDateFormatter *headerDateFormatter;

@property (assign, nonatomic) NSInteger daysPerWeek;

@property (strong, nonatomic) EICalendarWeekdayHeaderView *weekdayHeaderView;

@property (assign, nonatomic) BOOL test;

@property (assign, nonatomic) BOOL isFirstIncome;
/**
 当前选中的开始日期
 */
@property (strong, nonatomic) NSDate *startDate;

/**
 当前选中的结束日期
 */
@property (strong, nonatomic) NSDate *endDate;

/**
 firstDate对应月份的第一天的日期
 */
@property (strong, nonatomic) NSDate *firstDayOfMonth;

/**
 lastDate对应月份的最后一天的日期
 */
@property (strong, nonatomic) NSDate *lastDayOfMonth;

@property (assign, nonatomic) EICalendarViewWeekdayTextType weekdayTextType;
@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) NSArray *groupArray;

@end


@implementation EICalendarView

@synthesize firstDate = _firstDate;
@synthesize lastDate = _lastDate;

#pragma mark -- Instance Methods

- (instancetype)initWithCalendar:(NSCalendar *)calendar weekdayTextType:(EICalendarViewWeekdayTextType)weekdayTextType{
    self = [super init];
    if (self) {
        [self initializeWithCalendar:calendar weekdayTextType:weekdayTextType];
    }
    return self;
}

- (instancetype)initWithCalendar:(NSCalendar *)calendar {
    return [self initWithCalendar:calendar weekdayTextType:EICalendarViewWeekdayTextTypeVeryShort];
}

- (instancetype)init {
    return [self initWithCalendar:[NSCalendar currentCalendar] weekdayTextType: EICalendarViewWeekdayTextTypeVeryShort];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeWithCalendar:[NSCalendar currentCalendar] weekdayTextType:EICalendarViewWeekdayTextTypeVeryShort];
    }
    return self;
}

- (void)initializeWithCalendar:(NSCalendar *)calendar weekdayTextType:(EICalendarViewWeekdayTextType)weekdayTextType {
    self.test = NO;
    self.backgroundColor = kRGBColorFromHex(E7F9F9);
    self.daysPerWeek = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length;
    self.isFirstIncome = YES;
    self.weekdayTextType = weekdayTextType;
    self.calendar = calendar;
    [self setupWeekdayHeaderViewConstraints];
    [self setupCollectionConstraints];
    [self setupOverLayViewConstraints];
}

- (void)setupWeekdayHeaderViewConstraints {
    @weakify(self);
    [self.weekdayHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(EICalendarWeekdayHeaderHeight);
    }];
}

- (void)setupOverLayViewConstraints {
    @weakify(self);
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.weekdayHeaderView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(EICalendarWeekdayHeaderHeight);
    }];
}

- (void)setupCollectionConstraints {
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.weekdayHeaderView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groupArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.groupArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EICalendarRangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EICalendarViewCellIdentifier forIndexPath:indexPath];
    EICalendarRangeCellModel *cellModel = self.groupArray[indexPath.section][indexPath.item];
    if (self.startDate) {
        if ([self.startDate isEqualToDate:cellModel.cellDayOfIndexPath]) {
            cellModel.cellSelectedState = EICalendarRangeCellSelectedStateStart;
        }
        if (self.endDate) {
            if ([self date:cellModel.cellDayOfIndexPath isBetweenDate:self.startDate andEndDate:self.endDate]) {
                if ((cellModel.cellType != EICalendarRangeCellTypeNone)) {
                    cellModel.cellSelectedState = EICalendarRangeCellSelectedStateMid;
                }
            } else {
                cellModel.cellSelectedState = EICalendarRangeCellSelectedStateNone;
            }
            if ([cellModel.cellDayOfIndexPath isEqual:self.startDate] && cellModel.cellType != EICalendarRangeCellTypeNone && ![self.startDate isEqualToDate:self.endDate]) {
                cellModel.cellSelectedState = EICalendarRangeCellSelectedStateStartWithEnd;
            }
            if ([cellModel.cellDayOfIndexPath isEqualToDate:self.endDate] && cellModel.cellType != EICalendarRangeCellTypeNone) {
                if ([self.endDate isEqualToDate:self.startDate]) {
                    cellModel.cellSelectedState = EICalendarRangeCellSelectedStateEndEqualStart;
                } else {
                    cellModel.cellSelectedState = EICalendarRangeCellSelectedStateEnd;
                }
            }
            
        } else {
            if ([cellModel.cellDayOfIndexPath isEqualToDate:self.startDate] && cellModel.cellType != EICalendarRangeCellTypeNone) {
                cellModel.cellSelectedState = EICalendarRangeCellSelectedStateStart;
            } else {
                cellModel.cellSelectedState = EICalendarRangeCellSelectedStateNone;
            }
        }
    } else {
        cellModel.cellSelectedState = EICalendarRangeCellSelectedStateNone;
    }
    cell.cellModel = cellModel;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        EICalendarMonthHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EICalendarViewHeaderIdentifier forIndexPath:indexPath];
        NSDate *firstDayOfMonth = [self firstOfMonthForSection:indexPath.section];
        [headerView setupFirstDayOfMonth:firstDayOfMonth calendar:self.calendar];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EICalendarRangeCellModel *cellModel = self.groupArray[indexPath.section][indexPath.item];
    if (self.startDate == nil) {
        self.startDate = cellModel.cellDayOfIndexPath;
        
        [collectionView reloadData];
    } else if (self.endDate == nil) {
        if ([self.startDate compare:cellModel.cellDayOfIndexPath] != NSOrderedDescending) {
            NSDateComponents *components = [self.calendar components:EICalendarUnitYMD fromDate:self.startDate];
//            NSLog(@"%ld", components.day);
            NSInteger recidusDaysCountOfCurrentMonth = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.startDate].length - components.day;
            NSInteger daysCountOfNextMonth = [self daysCountOfNextMonthWithStateDate:self.startDate];
            components.day += recidusDaysCountOfCurrentMonth + daysCountOfNextMonth;
            
            NSDate *date = [self.calendar dateFromComponents:components];
            
            if ([date compare:cellModel.cellDayOfIndexPath] != NSOrderedAscending) {
                self.endDate = cellModel.cellDayOfIndexPath;
                
                [collectionView reloadData];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DSToast toastWithText:@"时间跨度不能超过两个自然月\n请重新选择"];
                    
                });
                self.startDate = nil;
                self.endDate = nil;
                [collectionView reloadData];
            }
        } else {
            self.endDate = nil;
            self.startDate = cellModel.cellDayOfIndexPath;
            [collectionView reloadData];
        }
    } else {
        self.endDate = nil;
        self.startDate = cellModel.cellDayOfIndexPath;
        [collectionView reloadData];
    }
}

- (NSInteger)daysCountOfNextMonthWithStateDate:(NSDate *)date {
    
    NSDateComponents *components = [self.calendar components:EICalendarUnitYMD fromDate:date];
    components.day = 1;
    components.month +=1;
    NSDate *nextMonthDate = [self.calendar dateFromComponents:components];
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nextMonthDate].length;
}

- (BOOL)date:(NSDate *)date isBetweenDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    if ([date compare:startDate] != NSOrderedDescending) {
        return NO;
    }
    if ([date compare:endDate] != NSOrderedAscending) {
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //We only display the overlay view if there is a vertical velocity
    if (fabs(velocity.y) > 0.0f) {
        if (self.overlayView.alpha < 1.0) {
            [UIView animateWithDuration:EICalendarOverLayViewAnimationDuration animations:^{
                [self.overlayView setAlpha:1.0];
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSTimeInterval delay = (decelerate) ? 1.5 : 0.0;
    [self performSelector:@selector(hideOverlayView) withObject:nil afterDelay:delay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Update Content of the Overlay View
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    //indexPaths is not sorted
    NSArray *sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSIndexPath *firstIndexPath = [sortedIndexPaths firstObject];
    
    self.overlayView.text = [self.headerDateFormatter stringFromDate:[self firstOfMonthForSection:firstIndexPath.section]];
}

- (void)hideOverlayView
{
    [UIView animateWithDuration:EICalendarOverLayViewAnimationDuration animations:^{
        [self.overlayView setAlpha:0.0];
    }];
}


#pragma mark --
#pragma mark -- OverLayView

- (UILabel *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [UILabel new];
        _overlayView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:.9f];
        _overlayView.font = [UIFont boldSystemFontOfSize:EICalendarOverlaySize];
        _overlayView.textColor = self.overlayTextColor;
        _overlayView.alpha = 0.f;
        _overlayView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_overlayView];
        __AVAILABILITY_INTERNAL_REGULAR
    }
    return _overlayView;
}

#pragma mark -- WeekdayHeaderView


- (EICalendarWeekdayHeaderView *)weekdayHeaderView {
    if (_weekdayHeaderView == nil) {
        _weekdayHeaderView = [[EICalendarWeekdayHeaderView alloc] initWithCalendar:self.calendar weekdayTextType:self.weekdayTextType];
        [self addSubview:_weekdayHeaderView];
    }
    return _weekdayHeaderView;
}



#pragma mark -- Calendar Calculation

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[EICalendarViewFlowLayout alloc] initWithDaysPerWeek:self.daysPerWeek]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[EICalendarRangeCell class] forCellWithReuseIdentifier:EICalendarViewCellIdentifier];
        [_collectionView registerClass:[EICalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EICalendarViewHeaderIdentifier];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark -- CollectionView / Calendar Methods

/**
 每个section对应的月份第一天的日期

 @param section0 firstDate的月份为第一个月份，以此类推
 @return 每个section对应的月份第一天的日期
 */
- (NSDate *)firstOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;
    return [self.calendar dateByAddingComponents:offset toDate:self.firstDayOfMonth options:0];
}

- (NSCalendarUnit)weekCalendarUnitDependingOniOSVersion {
    
    //  isDateInToday仅适用于8.0以及以上版本
    //isDateInToday is a new (awesome) method available on iOS8 only.
    if ([self.calendar respondsToSelector:@selector(isDateInToday:)]) {
        return NSCalendarUnitWeekOfMonth;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return NSWeekCalendarUnit;
#pragma clang diagnostic pop
    }
}

/**
 根据传入的date和unitFlags返回的时间为通过unitFlags过滤后的时间

 @param date 传入的date
 @param unitFlags 返回哪些日期组件，如年月日
 @return 过滤后的date
 */
- (NSDate *)date:(NSDate *)date toComponents:(NSUInteger)unitFlags
{
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:date];
    return [self.calendar dateFromComponents:components];
}

- (BOOL)isTodayDate:(NSDate *)date
{
    return [self compareDate:date withReferenceDate:[NSDate date]] == NSOrderedSame;
}

- (BOOL)isGreaterThanToday:(NSDate *)date {
    return [self compareDate:date withReferenceDate:[NSDate date]] == NSOrderedDescending;
}


/**
 比较date与referenceDate是否是一天

 @param date date
 @param referenceDate referenceDate
 @return yesOrNo
 */
- (NSComparisonResult)compareDate:(NSDate *)date withReferenceDate:(NSDate *)referenceDate
{
    NSDate *clampedDate = [self date:date toComponents:EICalendarUnitYMD];
    NSDate *refDate = [self date:referenceDate toComponents:EICalendarUnitYMD];
    
    return [clampedDate compare:refDate];
}

/**
 当前item对应的日期

 @param indexPath 传入cell的indexPath
 @return 当前indexPath对应的日期
 */
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    //  section对应的月份的第一天
    NSDate *firstDayOfMonth = [self firstOfMonthForSection:indexPath.section];
    //  firstDayOfMonth对应的是周几，默认为1:周日,2:周一......7周6
    NSUInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstDayOfMonth] weekday];
    //  可以算出周几对应的正确序号
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : self.daysPerWeek;
    NSDateComponents *dateComponents = [NSDateComponents new];
    //  当前item对应的是：在section对应月份第一天加上多少天是现在item的日期
    dateComponents.day = indexPath.item - startOffset;
    return [self.calendar dateByAddingComponents:dateComponents toDate:firstDayOfMonth options:0];
}

#pragma mark -- Calculate Date

- (NSInteger)numberOfCellInSection:(NSInteger)section {
    NSDate *firstDayOfSectionMonth = [self firstOfMonthForSection:section];
    NSCalendarUnit weekCalendarUnit = [self weekCalendarUnitDependingOniOSVersion];
    
    NSRange rangeOfWeek = [self.calendar rangeOfUnit:weekCalendarUnit inUnit:NSCalendarUnitMonth forDate:firstDayOfSectionMonth];
    //  每个月有几周
    NSInteger weekOfThisMonth = rangeOfWeek.length;
    return weekOfThisMonth * self.daysPerWeek;
}

#pragma mark -- Accessor

- (NSDateFormatter *)headerDateFormatter;
{
    if (_headerDateFormatter == nil) {
        _headerDateFormatter = [[NSDateFormatter alloc] init];
        _headerDateFormatter.calendar = self.calendar;
        _headerDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy LLLL" options:0 locale:self.calendar.locale];
    }
    return _headerDateFormatter;
}

- (void)setOverlayTextColor:(UIColor *)overlayTextColor
{
    _overlayTextColor = overlayTextColor;
    self.overlayView.textColor = overlayTextColor;
}

- (NSDate *)firstDate {
    if (_firstDate == nil) {
        NSDateComponents *components = [self.calendar components:EICalendarUnitYMD fromDate:[NSDate date]];
        components.day = 1;
        //  只返回firstDate的年月日
        _firstDate = [self.calendar dateFromComponents:components];
    }
    return _firstDate;
}

- (void)setFirstDate:(NSDate *)firstDate {
    //  只返回年月日
    _firstDate = [self date:firstDate toComponents:EICalendarUnitYMD];
}

- (NSDate *)lastDate {
    if (_lastDate == nil) {
        NSDateComponents *offSetComponents = [NSDateComponents new];
        offSetComponents.year = 1;
        offSetComponents.day = -1;
        //  默认为一年后的昨天
        _lastDate = [self.calendar dateByAddingComponents:offSetComponents toDate:self.firstDayOfMonth options:0];
    }
    return _lastDate;
}

//- (void)setStartDate:(NSDate *)startDate {
//    NSDateComponents *startDateComponents = [self.calendar components:EICalendarUnitYMD fromDate:startDate];
//    _startDate = [self.calendar dateFromComponents:startDateComponents];
//}
//
//- (void)setEndDate:(NSDate *)endDate {
//    NSDateComponents *endDateComponents = [self.calendar components:EICalendarUnitYMD fromDate:endDate];
//    _endDate = [self.calendar dateFromComponents:endDateComponents];
//}

- (void)setLastDate:(NSDate *)lastDate {
    _lastDate = [self date:lastDate toComponents:EICalendarUnitYMD];
}

- (NSDate *)firstDayOfMonth
{
    if (_firstDayOfMonth == nil) {
        //  根据firstDate（开始的日期）获取年月日组件，如firstDate为2016.11.24
        NSDateComponents *components = [self.calendar components:EICalendarUnitYMD
                                                        fromDate:self.firstDate];
        //  修改组件为第一天
        components.day = 1;
        //  入firstDate为2016.11.24，则firstDayOfMonth为2016.11.1
        _firstDayOfMonth = [self.calendar dateFromComponents:components];
    }
    
    return _firstDayOfMonth;
}

- (NSDate *)lastDayOfMonth {
    if (_lastDayOfMonth == nil) {
        NSDateComponents *components = [self.calendar components:EICalendarUnitYMD
                                                        fromDate:self.lastDate];
        components.month++;
        components.day = 0;
        _lastDayOfMonth = [self.calendar dateFromComponents:components];
    }
    return _lastDayOfMonth;
}

#pragma mark -- Model Source

- (NSArray *)groupArray {
    if (_groupArray == nil) {
        NSMutableArray *mutArr = [@[] mutableCopy];
        NSInteger sectionCount = [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDayOfMonth toDate:self.lastDayOfMonth options:0].month + 1;
        for (NSInteger index = 0; index < sectionCount; index++) {
            NSMutableArray *contentMutArr = [@[] mutableCopy];
            NSInteger cellCountPerSection = [self numberOfCellInSection:index];
            for (NSInteger item = 0; item < cellCountPerSection; item++) {
                //  section对应的月份的第一天
                EICalendarRangeCellModel *cellModel = [[EICalendarRangeCellModel alloc] init];
                NSDate *firstDayOfSectionMonth = [self firstOfMonthForSection:index];
                //  当前indexPath section item对应的日期
                NSDate *cellDayOfIndexPath = [self dateForCellAtIndexPath:[NSIndexPath indexPathForItem:item inSection:index]];
                cellModel.cellDayOfIndexPath = cellDayOfIndexPath;
                NSDateComponents *firstDayOfSectionMonthDateComponents = [self.calendar components:EICalendarUnitYMD fromDate:firstDayOfSectionMonth];
                NSDateComponents *cellDayOfIndexPathDateComponents = [self.calendar components:EICalendarUnitYMD fromDate:cellDayOfIndexPath];
                if (firstDayOfSectionMonthDateComponents.month == cellDayOfIndexPathDateComponents.month) {
                    if ([self isTodayDate:cellDayOfIndexPath]) {
                        cellModel.cellType = EICalendarRangeCellTypeToday;
                    } else if ([self isGreaterThanToday:cellDayOfIndexPath]) {
                        cellModel.cellType = EICalendarRangeCellTypeDisabled;
                    } else {
                        cellModel.cellType = EICalendarRangeCellTypeNormal;
                    }
                    
                    cellModel.dateStr = [NSString stringWithFormat:@"%ld", cellDayOfIndexPathDateComponents.day];
                } else {
                    cellModel.dateStr = nil;
                    cellModel.cellType = EICalendarRangeCellTypeNone;
                }
                cellModel.cellSelectedState = EICalendarRangeCellSelectedStateNone;
                [contentMutArr addObject:cellModel];
            }
            [mutArr addObject:contentMutArr];
        }
        _groupArray = [NSArray arrayWithArray:mutArr];
    }
    return _groupArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isFirstIncome) {
        NSInteger section = self.groupArray.count - 1;
        NSInteger item = [self.groupArray[section] count] - 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        self.isFirstIncome = NO;
    }
}

@end

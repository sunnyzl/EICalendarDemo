//
//  ViewController.m
//  EICalendarDemo
//
//  Created by zhao on 2016/11/23.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "EICalendarViewFlowLayout.h"

typedef NS_OPTIONS(NSInteger, EITestOption) {
    EITestOptionOne = 0,
    EITestOptionTwo = 1,
    EITestOptionThree = 1 << 1
};

static NSCalendarUnit const EICalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *layerView;

@property (strong, nonatomic) UICollectionView *collection;

@end

@implementation ViewController
/*
 
 NSCalendarUnitEra                = kCFCalendarUnitEra,
 NSCalendarUnitYear               = kCFCalendarUnitYear,
 NSCalendarUnitMonth              = kCFCalendarUnitMonth,
 NSCalendarUnitDay                = kCFCalendarUnitDay,
 NSCalendarUnitHour               = kCFCalendarUnitHour,
 NSCalendarUnitMinute             = kCFCalendarUnitMinute,
 NSCalendarUnitSecond             = kCFCalendarUnitSecond,
 NSCalendarUnitWeekday            = kCFCalendarUnitWeekday,
 NSCalendarUnitWeekdayOrdinal     = kCFCalendarUnitWeekdayOrdinal,
 NSCalendarUnitQuarter            NS_ENUM_AVAILABLE(10_6, 4_0) = kCFCalendarUnitQuarter,
 NSCalendarUnitWeekOfMonth        NS_ENUM_AVAILABLE(10_7, 5_0) = kCFCalendarUnitWeekOfMonth,
 NSCalendarUnitWeekOfYear         NS_ENUM_AVAILABLE(10_7, 5_0) = kCFCalendarUnitWeekOfYear,
 NSCalendarUnitYearForWeekOfYear  NS_ENUM_AVAILABLE(10_7, 5_0) = kCFCalendarUnitYearForWeekOfYear,
 NSCalendarUnitNanosecond         NS_ENUM_AVAILABLE(10_7, 5_0) = (1 << 15),
 NSCalendarUnitCalendar           NS_ENUM_AVAILABLE(10_7, 4_0) = (1 << 20),
 NSCalendarUnitTimeZone           NS_ENUM_AVAILABLE(10_7, 4_0) = (1 << 21),
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self calendarDuaring];
//    [self calendarBase];
//    [self calendarTest];
//    [self test];
//    [self campDateTest];
//    [self dateTest20170101];
    //define path parameters
//    EITestOption option = EITestOptionOne | EITestOptionTwo;
//    if ((option & EITestOptionOne) == EITestOptionOne) {
//        NSLog(@"one");
//    }
//    if ((option & EITestOptionTwo) == EITestOptionTwo) {
//        NSLog(@"two");
//    }
//    
//    if ((option & EITestOptionThree) == EITestOptionThree) {
//        NSLog(@"three");
//    }
//    
//    CGRect rect = CGRectMake(50, 50, 100, 100);
//    CGSize radii = CGSizeMake(50, 50);
//    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
//    //create path
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
//    CAShapeLayer *sharpLayer = [CAShapeLayer layer];
//    sharpLayer.path = path.CGPath;
//    sharpLayer.contentsScale = [UIScreen mainScreen].scale;
//    sharpLayer.fillColor = [UIColor cyanColor].CGColor;
//    [self.layerView.layer addSublayer:sharpLayer];
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[EICalendarViewFlowLayout alloc] init]];
    self.collection.frame = self.view.bounds;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:self.collection];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 20;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)calendarBase {
//    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *greCalendar = [NSCalendar currentCalendar];
    //    通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitQuarter fromDate:[NSDate date]];
//    dateComponents
    NSLog(@"year(年份): %ld", dateComponents.year);
    NSLog(@"quarter(季度):%ld", dateComponents.quarter);
    NSLog(@"month(月份):%ld", dateComponents.month);
    NSLog(@"day(日期):%ld", dateComponents.day);
    NSLog(@"hour(小时):%ld", dateComponents.hour);
    NSLog(@"minute(分钟):%ld", dateComponents.minute);
    NSLog(@"second(秒):%ld", dateComponents.second);
    
    NSLog(@"weekdayOridinal:%ld, weekday:%ld, weekOfMonth:%ld, weekOfYear:%ld, yearForWeekOfYear:%ld", dateComponents.weekdayOrdinal, dateComponents.weekday, dateComponents.weekOfMonth, dateComponents.weekOfYear, dateComponents.yearForWeekOfYear);
//    dateComponents.day = 1;
    NSLog(@"当前月份有几天:%ld", [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length);
    NSLog(@"本月有几周:%ld", [greCalendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length);
          //    当前时间对应的月份中有几周（前面说到的firstWeekday会影响到这个结果）)
    
//    NSLog(@"%ld", [greCalendar firstWeekday]);
}

- (void)calendarTest {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[NSDate date]];
    //    components.day = 22;
//    NSDate *firstDate = [calendar dateFromComponents:components];
//    
//    NSDateComponents *components1 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:firstDate];
    components.day = 2;
//    NSDate *firstDateMonth = [calendar dateFromComponents:components];
    NSLog(@"%ld----", components.weekday);
}

- (void)calendarDuaring {
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //    定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:6];
    [dateComponentsForDate setMonth:5];
    [dateComponentsForDate setYear:2004];
    //    根据设置的dateComponentsForDate获取历法中与之对应的时间点
    //    这里的时分秒会使用NSDateComponents中规定的默认数值，一般为0或1。
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    
    
    
    
    //    定义一个NSDateComponents对象，设置一个时间段
    NSDateComponents *dateComponentsAsTimeQantum = [[NSDateComponents alloc] init];
//    [dateComponentsForDate setDay:6];
    dateComponentsAsTimeQantum.month = -6;
    
    //    在当前历法下，获取6天后的时间点
    NSDate *dateFromDateComponentsAsTimeQantum = [greCalendar dateByAddingComponents:dateComponentsAsTimeQantum toDate:[NSDate date] options:0];
    NSLog(@"时间点:%@, 6天后的时间:%@", dateFromDateComponentsForDate, dateFromDateComponentsAsTimeQantum);
}

- (void)test {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    components.day = 1;
    NSLog(@"%ld, %ld, %ld", components.year, components.month, components.day);
    NSDate *date = [calendar dateFromComponents:components];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSLog(@"%@", localeDate);
    
    NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:localeDate];
    
//    NSLog(@"%ld", comp.weekday);
    NSLog(@"%ld", [calendar components:NSCalendarUnitWeekday fromDate:localeDate].weekday);
    
    NSLog(@"%ld", comp.weekday - calendar.firstWeekday);
    
    NSDateComponents *rangComp = [NSDateComponents new];
    rangComp.day = -2;
    
    NSLog(@"%@", [calendar dateByAddingComponents:rangComp toDate:localeDate options:0]);
}

- (void)campDateTest {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:currentDate];
    NSDate *localeDate = [currentDate dateByAddingTimeInterval:interval];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:currentDate];
    NSDate *campDate = [calendar dateFromComponents:components];
    NSInteger interval1 = [zone secondsFromGMTForDate:campDate];
    NSDate *camplocaleDate = [campDate dateByAddingTimeInterval:interval1];
    
    NSDateComponents *com = [NSDateComponents new];
    com.year = 1;
    com.day = -1;
    
    NSDate *lastDate = [calendar dateByAddingComponents:com toDate:localeDate options:0];
    NSInteger lastInterval = [zone secondsFromGMTForDate:lastDate];
    NSDate *localLastDate = [lastDate dateByAddingTimeInterval:lastInterval];

    NSLog(@"%@, %@, %@", localeDate, camplocaleDate, localLastDate);
}

- (void)dateTest20170101 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offSetComp = [NSDateComponents new];
    offSetComp.month = 2;
    NSDate *twoMonthLater = [calendar dateByAddingComponents:offSetComp toDate:[NSDate date] options:0];
    
    NSDateComponents *comp = [calendar components:EICalendarUnitYMD fromDate:twoMonthLater];
    comp.day = 3;
    NSDate *firstDate = [calendar dateFromComponents:comp];
    
    NSLog(@"%@", firstDate);
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:firstDate];
    NSLog(@"%ld", range.length);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

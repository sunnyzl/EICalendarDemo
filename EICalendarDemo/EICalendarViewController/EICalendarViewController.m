//
//  EICalendarViewController.m
//  ElectronicInvoice
//
//  Created by zhao on 2016/11/21.
//  Copyright © 2016年 cmos. All rights reserved.
//

#import "EICalendarViewController.h"
#import "EICalendarView.h"
#import "UIView+CMOExtention.h"
#import "EICalendarOptionView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface EICalendarViewController ()
<
EICalendarOptionViewDelegate
>

@property (weak, nonatomic) IBOutlet EICalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet EICalendarOptionView *optionView;

@end

@implementation EICalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optionView.delegate = self;
    self.calendarView.lastDate = [NSDate date];
    NSDateComponents *offsetComponents = [NSDateComponents new];
    offsetComponents.month = -5;
    self.calendarView.firstDate = [self.calendarView.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bindData];
}

- (void)bindData {
    @weakify(self);
    //  确认键何时可用
    [RACObserve(self.calendarView, endDate) subscribeNext:^(NSDate *endDate) {
        @strongify(self);
        if (endDate) {
            [self.confirmButton cmo_buttonEnabled:YES colorWithAlphaComponent:1.f];
        } else {
            [self.confirmButton cmo_buttonEnabled:NO colorWithAlphaComponent:.4f];
        }
    }];
    
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([self.delegate respondsToSelector:@selector(calendarViewController:calendar:startDate:endDate:)]) {
             [self.delegate calendarViewController:self calendar:self.calendarView.calendar startDate:self.calendarView.startDate endDate:self.calendarView.endDate];
         }
         if ([self.delegate respondsToSelector:@selector(calendarViewController:calendar:startDateString:endDateString:)]) {
             [self.delegate calendarViewController:self calendar:self.calendarView.calendar startDateString:[self dateStringFromeDate:self.calendarView.startDate] endDateString:[self dateStringFromeDate:self.calendarView.endDate]];
         }
//         [self.navigationController popViewControllerAnimated:YES];
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
//         [self.navigationController popViewControllerAnimated:YES];
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}

#pragma mark -- EICalendarOptionViewDelegate

- (void)optionView:(EICalendarOptionView *)optionView didClickButton:(EICalendarOptionViewButtonType)buttonType {
    NSDate *startDate = nil;
    NSDate *endDate = nil;
    switch (buttonType) {
        case EICalendarOptionViewButtonTypeToday:{
            startDate = [NSDate date];
            endDate = startDate;
            break;
        }
        case EICalendarOptionViewButtonTypeThisWeek:{
            endDate = [NSDate date];
            NSDateComponents *components = [NSDateComponents new];
            NSDateComponents *weekComponents = [self.calendarView.calendar components:NSCalendarUnitWeekday fromDate:endDate];
            if (weekComponents.weekday == 1) {
                components.day = 2 - 7 - weekComponents.weekday;
            } else {
                components.day = 2 - weekComponents.weekday;
                
            }
            startDate = [self.calendarView.calendar dateByAddingComponents:components toDate:endDate options:0];
            break;
        }
        case EICalendarOptionViewButtonTypePreWeek:{
            NSDate *currentDate = [NSDate date];
            NSDateComponents *components = [NSDateComponents new];
            NSDateComponents *weekComponents = [self.calendarView.calendar components:NSCalendarUnitWeekday fromDate:currentDate];
            if (weekComponents.weekday == 1) {
                components.day -= 2 * 7 + weekComponents.weekday - 2;
                startDate = [self.calendarView.calendar dateByAddingComponents:components toDate:currentDate options:0];
                
            } else {
                components.day -= 7 + weekComponents.weekday - 2;
                startDate = [self.calendarView.calendar dateByAddingComponents:components toDate:currentDate options:0];
            }
            components.day += 6;
            endDate = [self.calendarView.calendar dateByAddingComponents:components toDate:currentDate options:0];
            break;
        }
        case EICalendarOptionViewButtonTypeThisMonth:{
            endDate = [NSDate date];
            NSDateComponents *firstDayOfThisMonthComponents = [self.calendarView.calendar components:EICalendarUnitYMD fromDate:endDate];
            firstDayOfThisMonthComponents.day = 1;
            startDate = [self.calendarView.calendar dateFromComponents:firstDayOfThisMonthComponents];
            break;
        }
        case EICalendarOptionViewButtonTypePreMonth:{
            NSDateComponents *firstDayOfPreMonthComponents = [self.calendarView.calendar components:EICalendarUnitYMD fromDate:[NSDate date]];
            firstDayOfPreMonthComponents.month -= 1;
            firstDayOfPreMonthComponents.day = 1;
            startDate = [self.calendarView.calendar dateFromComponents:firstDayOfPreMonthComponents];
            NSInteger countOfPreMonth = [self.calendarView.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:startDate].length;
            
            NSDateComponents *endDateOffsetComponents = [NSDateComponents new];
            endDateOffsetComponents.day = countOfPreMonth - 1;
            endDate = [self.calendarView.calendar dateByAddingComponents:endDateOffsetComponents toDate:startDate options:0];
            break;
        }
    }
    if ([self.delegate respondsToSelector:@selector(calendarViewController:calendar:startDate:endDate:)]) {
        [self.delegate calendarViewController:self calendar:self.calendarView.calendar startDate:startDate endDate:endDate];
    }
    if ([self.delegate respondsToSelector:@selector(calendarViewController:calendar:startDateString:endDateString:)]) {
        [self.delegate calendarViewController:self calendar:self.calendarView.calendar startDateString:[self dateStringFromeDate:startDate] endDateString:[self dateStringFromeDate:endDate]];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)dateStringFromeDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    return [dateFormatter stringFromDate:date];
}

- (void)dealloc {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  WordbookManager.m
//  RLDictionary
//
//  Created by younggi.lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "WordbookManager.h"
#import "WordDataManager.h"

@interface WordbookManager ()

@property (nonatomic, strong) WordDataManager *wordDataManager;
@property (nonatomic, strong) NSMutableArray <Wordbook> *wordbooks;
@property (nonatomic, assign) WordbookManagerGroupingType groupingType;

@end

@implementation WordbookManager

SYNTHESIZE_SINGLETON_FOR_CLASS(WordbookManager, sharedInstance);

- (instancetype)init {
    if(self = [super init]) {
        self.wordDataManager = [WordDataManager savedObject];
        self.wordbooks = [NSMutableArray <Wordbook> array];
    }
    return self;
}

- (void)reload {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSDateComponents *differenceComponents = [self differenceComponentsFromDate:fromDate toDate:toDate];
    
    if(self.groupingType == WordbookManagerGroupingTypeByDay) {
        [differenceComponents day];
    }
    else if(self.groupingType == WordbookManagerGroupingTypeByWeek) {
        [differenceComponents weekOfMonth];
    }
    
}

- (BOOL)isGroupedByDateRange:(NSRange)range {
    return NO;
}

- (NSDateComponents *)differenceComponentsFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate {
    NSDate *fromRangeDate;
    NSDate *toRangeDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromRangeDate interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toRangeDate interval:NULL forDate:toDate];
    return [calendar components:NSCalendarUnitDay fromDate:fromRangeDate toDate:toRangeDate options:0];
}

@end

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
@property (nonatomic, assign) WordbookManagerGroupingType groupingType;

@end

@implementation WordbookManager

SYNTHESIZE_SINGLETON_FOR_CLASS(WordbookManager, sharedInstance);

- (instancetype)init {
    if(self = [super init]) {
        self.wordDataManager = [WordDataManager savedObject];
        self.wordbooks = [NSMutableArray <Wordbook> array];
//        self.groupingType = WordbookManagerGroupingTypeByWeek;
    }
    return self;
}

- (void)reload {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"path: %@",path);
    
    NSDate *fromDate;
    NSDate *toDate = [NSDate date];
    NSInteger comparativeValue = 0;
    NSInteger diffrence = 0;
    Wordbook *wordbook = [[Wordbook alloc] init];
    
    for(Word *word in self.wordDataManager.words) {
        
        fromDate = word.createdDate;
        diffrence = [self differencesByGroupingType:self.groupingType fromDate:fromDate toDate:toDate];
        if(diffrence == -1) continue;
        NSLog(@"%@ diffrence: %ld",word.string, diffrence);
        
        if([self shouldInsertWordkWithComparativeValue:comparativeValue diffrence:diffrence]) {
            wordbook.createdDate = fromDate;
            [wordbook.words addObject:word];
        }
        else {
            [self.wordbooks addObject:wordbook];
            wordbook = [[Wordbook alloc] init];
            wordbook.createdDate = fromDate;
            [wordbook.words addObject:word];
        }
        
        if([[self.wordDataManager.words lastObject] isEqual:word]) {
            [self.wordbooks addObject:wordbook];
        }
    }
    NSLog(@"Wordbooks\n%@",[self.wordbooks description]);
}

- (BOOL)shouldInsertWordkWithComparativeValue:(NSInteger)comparativeValue diffrence:(NSInteger)diffrence {
    return comparativeValue == diffrence;
}

- (NSInteger)differencesByGroupingType:(WordbookManagerGroupingType)type fromDate:fromDate toDate:toDate {
    
    NSDateComponents *differenceComponents = [self differenceComponentsFromDate:fromDate toDate:toDate];
    
    if(type == WordbookManagerGroupingTypeByDay) return [differenceComponents day];
    else if(type == WordbookManagerGroupingTypeByWeek) return ([differenceComponents day] / 7);
    else return -1;
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

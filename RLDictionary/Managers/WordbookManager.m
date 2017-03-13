//
//  WordbookManager.m
//  RLDictionary
//
//  Created by Ryan Lee on 21/02/2017.
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
    }
    return self;
}

- (void)notifyWordbookDidChanged:(NSString *)wordString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wordbookDidChangedNotification" object:wordString];
    });
}

- (BOOL)wordbookArrangeType {
    NSString *key = @"WordbookManagerGroupingType";
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)reload {
    
    [self.wordDataManager reload];
    
    self.wordbooks = [NSMutableArray <Wordbook> array];
    self.groupingType = self.wordbookArrangeType ? WordbookManagerGroupingTypeByWeek : WordbookManagerGroupingTypeByDay;
    
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
            if(!wordbook.createdDate) {
                wordbook.createdDate = fromDate;
            }
            [wordbook.words addObject:word];
        }
        else {
            comparativeValue = diffrence;
            if(wordbook.words.count > 0) {
                [self.wordbooks addObject:wordbook];
            }
            wordbook = [[Wordbook alloc] init];
            wordbook.createdDate = fromDate;
            [wordbook.words addObject:word];
        }
        
        if([[self.wordDataManager.words lastObject] isEqual:word]) {
            [self.wordbooks addObject:wordbook];
        }
    }
    [self notifyWordbookDidChanged:nil];
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

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler {
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIReferenceLibraryViewController* libraryViewController;
        NSError *error;
        
        if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:term]) {
            
            if(self.shouldAddWordWhenItSearching) {
                [self.wordDataManager addWithString:term];
                [self reload];
            }
            libraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:term];
        }
        else {
            error = [NSError errorWithDomain:@"해당 단어가 정의된 사전을 찾을 수 없습니다." code:-1001 userInfo:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            if(completionHandler) completionHandler(libraryViewController, error);
        });
    });
}

- (void)resetAll {
    [self.wordDataManager resetAll];
    [self reload];
}

- (BOOL)hasReadWithString:(NSString *)string {
    return [self.wordDataManager hasReadWithString:string];
}

- (void)setHasRead:(BOOL)hasRead withString:(NSString *)string {
    [self.wordDataManager setHasRead:hasRead withString:string];
}

- (void)deleteWithString:(NSString *)word {
    [self.wordDataManager deleteWithString:word];
    [self reload];
}

- (BOOL)shouldAddWordWhenItSearching {
    return YES;
}

@end

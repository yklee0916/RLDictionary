//
//  WordDataHandler.m
//  Podic
//
//  Created by Andrew Lee on 21/02/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "WordDataHandler.h"
#import "WordDataManager.h"

@interface WordDataHandler ()

@property (nonatomic, strong) WordDataManager *wordDataManager;
@property (nonatomic, assign) WordbookManagerGroupingType groupingType;

@end

@implementation WordDataHandler

SYNTHESIZE_SINGLETON_FOR_CLASS(WordDataHandler, sharedInstance);

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
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"path: %@",path);
    
    NSDate *fromDate;
    NSDate *toDate = [NSDate date];
    NSInteger comparativeValue = 0;
    NSInteger diffrence = 0;
    Wordbook *wordbook = [[Wordbook alloc] init];
    
    for(Word *word in self.wordDataManager.words) {
        
        fromDate = word.createdDate;
        diffrence = [self differencesByGroupingType:self.groupingType fromDate:fromDate toDate:toDate];
        if(diffrence == -1) continue;
//        NSLog(@"%@ diffrence: %d",word.string, (int)diffrence);
        
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

- (void)resetAll {
    [self.wordDataManager resetAll];
    [self reload];
}

- (Word *)wordAtString:(NSString *)string {
    return [self.wordDataManager.words wordAtString:string];
}

- (void)addWord:(Word *)word {
    [self.wordDataManager addWord:word];
    [self reload];
}

- (void)addWordWithString:(NSString *)string {
    Word *word = [[Word alloc] initWithString:string];
    [self addWord:word];
}

- (void)deleteWord:(Word *)word {
    [self.wordDataManager deleteWord:word];
    [self reload];
}

- (void)deleteWordFromString:(NSString *)string {
    Word *word = [self wordAtString:string];
    [self deleteWord:word];
}

- (void)updateWord:(Word *)word {
    [self.wordDataManager updateWord:word];
    [self reload];
}

- (BOOL)shouldInsertWordkWithComparativeValue:(NSInteger)comparativeValue diffrence:(NSInteger)diffrence {
    return comparativeValue == diffrence;
}

- (NSInteger)differencesByGroupingType:(WordbookManagerGroupingType)type fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
//NSDateComponents *differenceComponents = [self differenceComponentsFromDate:fromDate toDate:toDate];
  
    NSDate *fromRangeDate;
    NSDate *toRangeDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSCalendarUnit unit = NSCalendarUnitDay;
    if(type == WordbookManagerGroupingTypeByDay) unit = NSCalendarUnitDay;
    else if(type == WordbookManagerGroupingTypeByWeek) unit = NSCalendarUnitWeekOfYear;
    
    [calendar rangeOfUnit:unit startDate:&fromRangeDate interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:unit startDate:&toRangeDate interval:NULL forDate:toDate];
    NSDateComponents *differenceComponents = [calendar components:unit fromDate:fromRangeDate toDate:toRangeDate options:0];
    
    if(type == WordbookManagerGroupingTypeByDay) return [differenceComponents day];
    else if(type == WordbookManagerGroupingTypeByWeek) return ([differenceComponents weekOfYear]);
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
                [self.wordDataManager addWordWithString:term];
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

- (BOOL)shouldAddWordWhenItSearching {
    return YES;
}

@end

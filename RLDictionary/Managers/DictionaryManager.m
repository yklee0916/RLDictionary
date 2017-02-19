//
//  DictionaryManager.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "DictionaryManager.h"

@interface DictionaryManager ()

@property (nonatomic, strong) NSMutableArray <NSString *> *wordbook;
@property (nonatomic, strong) NSMutableArray <NSString *> *recentHistory;

@end

@implementation DictionaryManager

- (instancetype)init {
    if([super init]) {
        self.wordbook = [NSMutableArray array];
        self.recentHistory = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)wordbookCount {
    return self.wordbook.count;
}

- (NSString *)wordAtIndexFromWordbook:(NSUInteger)index {
    return self.wordbookCount <= index ? nil : [self.wordbook objectAtIndex:index];
}

- (BOOL)shouldAddWordToWorkbook {
    return YES;
}

- (BOOL)addWordToWordbook:(NSString *)word {
    
    if(!word) return NO;
    if([self.wordbook containsObject:word]) return NO;
    
    [self.wordbook insertObject:word atIndex:0];
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wordbookDidChangedNotification" object:word];
    return YES;
}

- (BOOL)deleteWordToWordbook:(NSString *)word {
    if(!word) return NO;
    if(![self.wordbook containsObject:word]) return NO;
    
    [self.wordbook removeObject:word];
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wordbookDidChangedNotification" object:word];
    return YES;
}

+ (instancetype)savedObject {
    NSString *key = NSStringFromClass([DictionaryManager class]);
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSError *error;
    if(!jsonString) return [[DictionaryManager alloc] init];
    return [[DictionaryManager alloc] initWithString:jsonString error:&error];
}

+ (void)resetWordbook {
    NSString *key = NSStringFromClass([DictionaryManager class]);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)save {
    NSString *jsonString = [self toJSONString];
    NSString *key = NSStringFromClass([DictionaryManager class]);
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler {
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIReferenceLibraryViewController* libraryViewController;
        NSError *error;
        
        if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:term]) {
            
            if(self.shouldAddWordToWorkbook) {
                [self addWordToWordbook:term];
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

@end

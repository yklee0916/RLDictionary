//
//  WordDataManager.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "WordDataManager.h"

@interface WordDataManager ()

@end

@implementation WordDataManager








//-----------------------------------------------------------------------------------------------------------------------------

- (instancetype)init {
    if([super init]) {
        self.words = [NSMutableArray <Word> array];
    }
    return self;
}

- (NSUInteger)count {
    return self.words.count;
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    return [self.words stringAtIndex:index];
}

- (BOOL)shouldAddWordWhenItSearching {
    return YES;
}

- (void)addWithString:(NSString *)string {
    
    [self.words addObjectByString:string];
    [self save];
    [self notifywordsDidChanged:string];
}

- (void)deleteWithString:(NSString *)string {
    [self.words removeObjectByString:string];
    [self save];
    [self notifywordsDidChanged:string];
}

- (void)notifywordsDidChanged:(NSString *)wordString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wordsDidChangedNotification" object:wordString];
    });
}

+ (instancetype)savedObject {
    
    static WordDataManager *accessorname = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *key = NSStringFromClass([WordDataManager class]);
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        NSError *error;
        accessorname = jsonString.length > 0 ? [[WordDataManager alloc] initWithString:jsonString error:&error] : [[WordDataManager alloc] init];
    });
    return accessorname;
}

- (void)resetAll {
    [self.words removeAllObjects];
    [self save];
    [self notifywordsDidChanged:nil];
}

- (void)save {
    NSString *jsonString = [self toJSONString];
    if(jsonString.length == 0) return ;
    NSString *key = NSStringFromClass([WordDataManager class]);
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler {
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIReferenceLibraryViewController* libraryViewController;
        NSError *error;
        
        if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:term]) {
            
            if(self.shouldAddWordWhenItSearching) {
                [self addWithString:term];
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

- (NSString *)description {
    return [self toJSONString];
}

@end

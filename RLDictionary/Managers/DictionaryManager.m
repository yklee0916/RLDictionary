//
//  DictionaryManager.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "DictionaryManager.h"
#import "NSMutableArray+Wordbook.h"

@interface DictionaryManager ()

@property (nonatomic, strong) NSMutableArray <Word> *wordbook;

@end

@implementation DictionaryManager

- (instancetype)init {
    if([super init]) {
        self.wordbook = [NSMutableArray <Word> array];
    }
    return self;
}

- (NSUInteger)wordbookCount {
    return self.wordbook.count;
}

- (NSString *)wordStringAtIndex:(NSUInteger)index {
    return [self.wordbook stringAtIndex:index];
}

- (BOOL)shouldAddWordWhenItSearching {
    return YES;
}

- (void)addWordString:(NSString *)string {
    
    [self.wordbook addObjectByString:string];
    [self save];
    [self notifyWordbookDidChanged:string];
}

- (void)deleteWordString:(NSString *)string {
    [self.wordbook removeObjectByString:string];
    [self save];
    [self notifyWordbookDidChanged:string];
}

- (void)notifyWordbookDidChanged:(NSString *)wordString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wordbookDidChangedNotification" object:wordString];
    });
}

+ (instancetype)savedObject {
    
    static DictionaryManager *accessorname = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *key = NSStringFromClass([DictionaryManager class]);
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        NSError *error;
        accessorname = jsonString.length > 0 ? [[DictionaryManager alloc] initWithString:jsonString error:&error] : [[DictionaryManager alloc] init];
    });
    return accessorname;
}

- (void)resetWordbook {
    NSString *key = NSStringFromClass([DictionaryManager class]);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.wordbook removeAllObjects];
}

- (void)save {
    NSString *jsonString = [self toJSONString];
    if(jsonString.length == 0) return ;
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
            
            if(self.shouldAddWordWhenItSearching) {
                [self addWordString:term];
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

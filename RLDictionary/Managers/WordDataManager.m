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

- (void)addWithString:(NSString *)string {
    
    [self.words addObjectByString:string];
    [self save];
}

- (Word *)wordAtString:(NSString *)string {
    return [self.words wordAtString:string];
}

- (BOOL)hasReadWithString:(NSString *)string {
    Word *word = [self.words wordAtString:string];
    return word.hasRead;
}

- (void)setHasRead:(BOOL)hasRead withString:(NSString *)string {
    Word *word = [self.words wordAtString:string];
    word.hasRead = hasRead;
    [self save];
}

- (void)deleteWithString:(NSString *)string {
    [self.words removeObjectByString:string];
    [self save];
}

+ (instancetype)savedObject {
    
    static WordDataManager *accessorname = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *key = NSStringFromClass([WordDataManager class]);
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
        NSError *error;
        accessorname = jsonString.length > 0 ? [[WordDataManager alloc] initWithString:jsonString error:&error] : [[WordDataManager alloc] init];
    });
    return accessorname;
}

- (void)resetAll {
    [self.words removeAllObjects];
    [self save];
}

- (void)save {
    NSString *jsonString = [self toJSONString];
    if(jsonString.length == 0) return ;
    NSString *key = NSStringFromClass([WordDataManager class]);
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)description {
    return [self toJSONString];
}

@end

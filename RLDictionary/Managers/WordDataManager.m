//
//  WordDataManager.m
//  RLDictionary
//
//  Created by Ryan Lee on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "WordDataManager.h"
#import "WordDataDBHelper.h"

@interface WordDataManager ()

@property (nonatomic, strong) WordDataDBHelper *wordDataDBHelper;

@end

@implementation WordDataManager

- (instancetype)init {
    if([super init]) {
        self.wordDataDBHelper = [WordDataDBHelper sharedInstance];
        self.words = self.wordDataDBHelper.words;
    }
    return self;
}

- (void)reload {
    [self.words removeAllObjects];
    self.words = self.wordDataDBHelper.words;
}

- (void)resetAll {
    [self.words removeAllObjects];
    [self.wordDataDBHelper deleteAll];
}

- (Word *)wordAtString:(NSString *)string {
    return [self.words wordAtString:string];
}

- (void)addWord:(Word *)word {
    [self.words addObjectByString:word.string];
    [self.wordDataDBHelper addWord:word];
}

- (void)addWordWithString:(NSString *)string {
    Word *word = [[Word alloc] initWithString:string];
    [self addWord:word];
}

- (void)deleteWord:(Word *)word {
    [self.words removeObjectByString:word.string];
    [self.wordDataDBHelper deleteWord:word];
}

- (void)deleteWordFromString:(NSString *)string {
    Word *word = [self.words wordAtString:string];
    [self deleteWord:word];
}

- (void)updateWord:(Word *)word {
    [self hideWordIfNeeded:word];
    [self.wordDataDBHelper updateWord:word];
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    return [self.words stringAtIndex:index];
}

- (NSUInteger)count {
    return self.words.count;
}

- (void)hideWordIfNeeded:(Word *)word {
    if(!word) return ;
    if(!word.hasRead) return;
    
    NSString *key = @"WordbookHideReadWords";
    BOOL hasRead = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if(!hasRead) return ;
    [self.words removeObjectByString:word.string];
}

+ (instancetype)savedObject {
    
    static WordDataManager *accessorname = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accessorname = [[WordDataManager alloc] init];
    });
    
    return accessorname;
}

- (NSString *)description {
    return [self toJSONString];
}

@end

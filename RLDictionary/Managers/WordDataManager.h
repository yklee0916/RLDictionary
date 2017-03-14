//
//  WordDataManager.h
//  RLDictionary
//
//  Created by Ryan Lee on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "NSMutableArray+Word.h"

@interface WordDataManager : JSONModel

@property (nonatomic, strong) NSMutableArray <Word> *words;

+ (instancetype)savedObject;

- (NSUInteger)count;
- (NSString *)stringAtIndex:(NSUInteger)index;

- (BOOL)hasReadWithString:(NSString *)word;
- (void)setHasRead:(BOOL)hasRead withString:(NSString *)word;
- (void)addWithString:(NSString *)string;
- (void)deleteWithString:(NSString *)string;

- (void)reload;
- (void)resetAll;

- (Word *)wordAtString:(NSString *)string;

- (void)addWord:(Word *)word;
- (void)addWordWithString:(NSString *)string;

- (void)deleteWord:(Word *)word;
- (void)deleteWordFromString:(NSString *)string;

- (void)updateWord:(Word *)word;

@end

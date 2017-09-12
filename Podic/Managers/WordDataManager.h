//
//  WordDataManager.h
//  Podic
//
//  Created by Andrew Lee on 19/02/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "NSMutableArray+Word.h"

@interface WordDataManager : JSONModel

@property (nonatomic, strong) NSMutableArray <Word> *words;

+ (instancetype)savedObject;

- (NSUInteger)count;
- (NSString *)stringAtIndex:(NSUInteger)index;

- (void)reload;
- (void)resetAll;

- (Word *)wordAtString:(NSString *)string;

- (void)addWord:(Word *)word;
- (void)addWordWithString:(NSString *)string;

- (void)deleteWord:(Word *)word;
- (void)deleteWordFromString:(NSString *)string;

- (void)updateWord:(Word *)word;

@end

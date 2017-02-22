//
//  WordDataManager.h
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
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

- (void)addWithString:(NSString *)word;
- (void)deleteWithString:(NSString *)word;

- (void)resetAll;

@end

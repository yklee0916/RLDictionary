//
//  WordDataDBHelper.h
//  Podic
//
//  Created by younggi.lee on 15/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface WordDataDBHelper : NSObject

+ (WordDataDBHelper *)sharedInstance;

- (NSMutableArray <Word> *)words;

- (void)addWord:(Word *)word;

- (void)updateWord:(Word *)word;

- (void)deleteWord:(Word *)word;

- (void)deleteAll;

@end

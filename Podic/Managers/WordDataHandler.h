//
//  WordDataHandler.h
//  RLDictionary
//
//  Created by Ryan Lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wordbook.h"

typedef NS_ENUM(NSUInteger, WordbookManagerGroupingType) {
    WordbookManagerGroupingTypeByDay,
    WordbookManagerGroupingTypeByWeek
};

@interface WordDataHandler : NSObject

@property (nonatomic, strong) NSMutableArray <Wordbook> *wordbooks;

+ (WordDataHandler *)sharedInstance;

- (void)reload;
- (void)resetAll;

- (Word *)wordAtString:(NSString *)string;

- (void)addWord:(Word *)word;
- (void)addWordWithString:(NSString *)string;

- (void)deleteWord:(Word *)word;
- (void)deleteWordFromString:(NSString *)string;

- (void)updateWord:(Word *)word;

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler;

@end

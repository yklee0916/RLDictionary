//
//  WordbookManager.h
//  RLDictionary
//
//  Created by younggi.lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wordbook.h"

typedef NS_ENUM(NSUInteger, WordbookManagerGroupingType) {
    WordbookManagerGroupingTypeByDay,
    WordbookManagerGroupingTypeByWeek
};

@interface WordbookManager : NSObject

@property (nonatomic, strong) NSMutableArray <Wordbook> *wordbooks;

+ (WordbookManager *)sharedInstance;

- (void)reload;

- (void)deleteWithString:(NSString *)word;
- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler;

@end

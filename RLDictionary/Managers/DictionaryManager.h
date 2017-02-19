//
//  DictionaryManager.h
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface DictionaryManager : JSONModel

+ (instancetype)savedObject;
- (void)save;

- (NSUInteger)wordbookCount;
- (NSString *)wordAtIndexFromWordbook:(NSUInteger)index;
- (BOOL)addWordToWordbook:(NSString *)word;
- (BOOL)deleteWordToWordbook:(NSString *)word;

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler;

@end

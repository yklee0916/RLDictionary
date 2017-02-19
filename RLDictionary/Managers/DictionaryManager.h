//
//  DictionaryManager.h
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryManager : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> *wordbook;
@property (nonatomic, strong) NSMutableArray <NSString *> *recentHistory;

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term completionHandler:(void (^)(UIReferenceLibraryViewController *libarayViewController, NSError *error))completionHandler;

@end

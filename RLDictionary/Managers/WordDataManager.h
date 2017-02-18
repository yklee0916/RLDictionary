//
//  WordDataManager.h
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface WordDataManager : NSObject

- (NSUInteger)count;
- (Word *)wordAtIndex:(NSUInteger)index;
- (void)addWordString:(NSString *)wordString;
- (void)addWord:(Word *)word;

@end

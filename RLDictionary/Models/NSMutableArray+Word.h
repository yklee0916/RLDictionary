//
//  NSMutableArray+Word.h
//  RLDictionary
//
//  Created by younggi.lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface NSMutableArray (Word)

- (BOOL)containsString:(NSString *)string;

- (Word *)addObjectByString:(NSString *)string;
- (void)removeObjectByString:(NSString *)string;

- (Word *)wordAtString:(NSString *)string;
- (NSUInteger)indexOfString:(NSString *)string;
- (NSString *)stringAtIndex:(NSUInteger)index;
- (NSDate *)createdDateAtIndex:(NSUInteger)index;

@end

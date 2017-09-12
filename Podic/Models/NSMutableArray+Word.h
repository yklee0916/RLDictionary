//
//  NSMutableArray+Word.h
//  Podic
//
//  Created by Andrew Lee on 21/02/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
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

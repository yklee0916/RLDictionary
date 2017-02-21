//
//  NSMutableArray+Word.m
//  RLDictionary
//
//  Created by younggi.lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "NSMutableArray+Word.h"

@implementation NSMutableArray (Word)

- (BOOL)containsString:(NSString *)string {
    NSUInteger index = [self indexOfString:string];
    return index != NSNotFound;
}

- (void)addObjectByString:(NSString *)string {
    if([self containsString:string]) return;
    Word *word = [[Word alloc] initWithString:string];
    if(word) {
        [self insertObject:word atIndex:0];
    }
}

- (void)removeObjectByString:(NSString *)string {
    NSUInteger index = [self indexOfString:string];
    if(index != NSNotFound) {
        [self removeObjectAtIndex:index];
    }
}

- (NSUInteger)indexOfString:(NSString *)string {
    if(!string) return NSNotFound;
    for(Word *word in self) {
        if([word.string isEqualToString:string]) {
            return [self indexOfObject:word];
        }
    }
    return NSNotFound;
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    return self.count > index ? ((Word *)[self objectAtIndex:index]).string : nil;
}

- (NSDate *)createdDateAtIndex:(NSUInteger)index {
    return self.count > index ? ((Word *)[self objectAtIndex:index]).createdDate : nil;
}

@end

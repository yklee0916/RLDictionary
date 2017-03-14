//
//  NSMutableArray+Word.m
//  RLDictionary
//
//  Created by Ryan Lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "NSMutableArray+Word.h"

@implementation NSMutableArray (Word)

- (BOOL)containsString:(NSString *)string {
    NSUInteger index = [self indexOfString:string];
    return index != NSNotFound;
}

- (Word *)addObjectByString:(NSString *)string {
    if([self containsString:string]) return nil;
    Word *word = [[Word alloc] initWithString:string];
    if(word) {
        [self insertObject:word atIndex:0];
    }
    return word;
}

- (void)addObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)removeObjectByString:(NSString *)string {
    NSUInteger index = [self indexOfString:string];
    if(index != NSNotFound) {
        [self removeObjectAtIndex:index];
    }
}

- (Word *)wordAtString:(NSString *)string {
    if(string.isEmpty) return nil;
    for(Word *word in self) {
        if([word.string isEqualToString:string]) {
            return word;
        }
    }
    return nil;
}

- (NSUInteger)indexOfString:(NSString *)string {
    if(string.isEmpty) return NSNotFound;
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

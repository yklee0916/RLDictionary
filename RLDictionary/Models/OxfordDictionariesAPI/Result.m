//
//  Result.m
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "Result.h"

@implementation Result

- (LexicalEntry *)lexicalEntryAtIndex:(NSUInteger)index {
    return ((LexicalEntry *)[self.lexicalEntries objectAtIndex:index]);
}

@end

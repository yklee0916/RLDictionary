//
//  LexicalEntry.m
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "LexicalEntry.h"

@implementation LexicalEntry

- (Entry *)entryAtIndex:(NSUInteger)index {
    return ((Entry *)[self.entries objectAtIndex:index]);
}

@end

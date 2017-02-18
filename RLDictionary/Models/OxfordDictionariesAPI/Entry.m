//
//  Entry.m
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "Entry.h"

@implementation Entry

- (Sense *)senseAtIndex:(NSUInteger)index {
    return ((Sense *)[self.senses objectAtIndex:index]);
}

@end

//
//  Sense.m
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "Sense.h"

@implementation Sense

- (NSString *)definition {
    return [self.definitions firstObject];
}

- (NSString *)exampleAtIndex:(NSUInteger)index {
    return ((Example *)[self.examples objectAtIndex:index]).text;
}

@end

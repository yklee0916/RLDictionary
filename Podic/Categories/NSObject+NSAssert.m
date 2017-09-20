//
//  NSObject+NSAssert.m
//  Podic
//
//  Created by Andrew Lee on 13/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "NSObject+NSAssert.h"

@implementation NSString (NSAssert)

- (BOOL)isEmpty {
    return (self.length == 0);
}

@end

@implementation NSArray (NSAssert)

- (BOOL)isEmpty {
    return (self.count == 0);
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if(self.count <= index) return nil;
    return [self objectAtIndex:index];
}

@end

@implementation NSDictionary (NSAssert)

- (BOOL)isEmpty {
    return (self.count == 0);
}

@end

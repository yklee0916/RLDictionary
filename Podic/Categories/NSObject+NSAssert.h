//
//  NSObject+NSAssert.h
//  Podic
//
//  Created by Andrew Lee on 13/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSAssert)

- (BOOL)isEmpty;

@end

@interface NSArray (NSAssert)

#define objectAtIndex(index) safeObjectAtIndex(index);

- (BOOL)isEmpty;
- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSDictionary (NSAssert)

- (BOOL)isEmpty;

@end

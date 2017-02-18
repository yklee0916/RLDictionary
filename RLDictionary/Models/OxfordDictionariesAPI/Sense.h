//
//  Sense.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Example.h"

@protocol Sense
@end

@interface Sense : JSONModel

@property (nonatomic, strong) NSArray <NSString *> *definitions;
@property (nonatomic, strong) NSArray <Example, Optional> *examples;

- (NSString *)definition;
- (NSString *)exampleAtIndex:(NSUInteger)index;

@end

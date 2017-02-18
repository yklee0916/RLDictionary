//
//  OxfordDictionariesResponse.m
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "OxfordDictionariesResponse.h"

@implementation OxfordDictionariesResponse

- (Result *)resultAtIndex:(NSUInteger)index {
    if(self.results.count <= index) return nil;
    return ((Result *)[self.results objectAtIndex:index]);
}

@end

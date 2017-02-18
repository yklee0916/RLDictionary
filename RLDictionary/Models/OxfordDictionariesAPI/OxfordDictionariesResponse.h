//
//  OxfordDictionariesResponse.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Result.h"

@protocol OxfordDictionariesResponse
@end

@interface OxfordDictionariesResponse : JSONModel

@property (nonatomic, strong) NSArray <Result> *results;
@property (nonatomic, strong) NSDictionary *metadata;

- (Result *)resultAtIndex:(NSUInteger)index;

@end

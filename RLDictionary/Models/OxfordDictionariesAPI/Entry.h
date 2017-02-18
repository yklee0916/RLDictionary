//
//  Entry.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "GrammaticalFeature.h"
#import "Sense.h"

@protocol Entry
@end

@interface Entry : JSONModel

@property (nonatomic, strong) NSArray <GrammaticalFeature> *grammaticalFeatures;
@property (nonatomic, strong) NSArray <Sense> *senses;

- (Sense *)senseAtIndex:(NSUInteger)index;

@end

//
//  WNWord.h
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "WNDefinition.h"

@protocol WordDO
@end

@interface WNWord : JSONModel

@property (nonatomic, strong) NSString *word;
@property (nonatomic, assign) NSInteger wordId;
@property (nonatomic, strong) NSArray <WNDefinition> *definitions;

@end

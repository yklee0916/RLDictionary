//
//  WNDefinition.h
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "WNExample.h"

@protocol WNDefinition
@end

@interface WNDefinition : JSONModel

@property (nonatomic, strong) NSString *definition;
@property (nonatomic, assign) NSInteger defId;
@property (nonatomic, assign) NSInteger partOfSpeech;
@property (nonatomic, strong) NSArray <WNExample> *examples;

@end

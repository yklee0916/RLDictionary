//
//  WNExample.h
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol WNExample
@end

@interface WNExample : JSONModel

@property (nonatomic, strong) NSString *example;
@property (nonatomic, assign) NSInteger egId;

@end

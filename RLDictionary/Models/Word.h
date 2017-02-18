//
//  Word.h
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

@property NSString *string;
@property BOOL hasLearned;

- (instancetype)initWithString:(NSString *)string;

@end

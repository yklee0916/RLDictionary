//
//  Word.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "Word.h"

@implementation Word

- (instancetype)initWithString:(NSString *)string {
    Word *word = [self init];
    word.string = [string lowercaseString];
    return word;
}

@end

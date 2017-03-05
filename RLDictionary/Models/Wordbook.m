//
//  Wordbook.m
//  RLDictionary
//
//  Created by Ryan Lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "Wordbook.h"

@implementation Wordbook

- (instancetype)init {
    if(self = [super init]) {
        self.words = [NSMutableArray <Word> array];
    }
    return self;
}

- (NSString *)description {
    return [self toJSONString];
}

@end

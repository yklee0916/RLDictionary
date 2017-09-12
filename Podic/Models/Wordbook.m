//
//  Wordbook.m
//  Podic
//
//  Created by Andrew Lee on 21/02/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
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

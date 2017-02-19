//
//  DictionaryManager.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "DictionaryManager.h"

@implementation DictionaryManager

- (instancetype)init {
    if([super init]) {
        self.wordbook = [NSMutableArray array];
        self.recentHistory = [NSMutableArray array];
    }
    return self;
}

@end

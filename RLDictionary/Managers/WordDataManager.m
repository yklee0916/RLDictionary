//
//  WordDataManager.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "WordDataManager.h"

@interface WordDataManager ()

@property NSMutableArray <Word *> *words;

@end

@implementation WordDataManager

- (instancetype)init {
    if(self = [super init]) {
        self.words = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)count {
    return self.words.count;
}

- (Word *)wordAtIndex:(NSUInteger)index {
    return [self.words objectAtIndex:index];
}

- (void)addWordString:(NSString *)wordString {
    Word *word = [[Word alloc] initWithString:wordString];
    [self addWord:word];
}

- (void)addWord:(Word *)word {
    [self.words addObject:word];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WordDataDidChangedNotification" object:word];
}

@end

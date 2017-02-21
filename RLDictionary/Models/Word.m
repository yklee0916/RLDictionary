//
//  Word.m
//  RLDictionary
//
//  Created by younggi.lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "Word.h"

@implementation Word

- (instancetype)initWithString:(NSString *)string {
    if(!string) return nil;
    if(self = [super init]) {
        self.string = string;
        self.createdDate = [NSDate date];
    }
    return self;
}

@end

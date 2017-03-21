//
//  Wordbook.h
//  RLDictionary
//
//  Created by Ryan Lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@protocol Wordbook
@end

@interface Wordbook : JSONModel

@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSMutableArray <Word> *words;

@end

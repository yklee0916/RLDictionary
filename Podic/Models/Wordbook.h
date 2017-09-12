//
//  Wordbook.h
//  Podic
//
//  Created by Andrew Lee on 21/02/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@protocol Wordbook
@end

@interface Wordbook : JSONModel

@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSMutableArray <Word> *words;

@end

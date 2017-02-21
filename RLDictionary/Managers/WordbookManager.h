//
//  WordbookManager.h
//  RLDictionary
//
//  Created by younggi.lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wordbook.h"

typedef NS_ENUM(NSUInteger, WordbookManagerGroupingType) {
    WordbookManagerGroupingTypeByDay,
    WordbookManagerGroupingTypeByWeek
};

@interface WordbookManager : NSObject

+ (WordbookManager *)sharedInstance;

- (void)reload;

@end

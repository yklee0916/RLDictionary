//
//  LexicalEntry.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Entry.h"

@protocol LexicalEntry
@end

@interface LexicalEntry : JSONModel

@property (nonatomic, strong) NSArray <Entry> *entries;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *lexicalCategory;

- (Entry *)entryAtIndex:(NSUInteger)index;

@end

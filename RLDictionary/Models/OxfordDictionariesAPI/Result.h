//
//  Result.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LexicalEntry.h"

@protocol Result
@end

@interface Result : JSONModel

@property (nonatomic, strong) NSArray <LexicalEntry> *lexicalEntries;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *word;

- (LexicalEntry *)lexicalEntryAtIndex:(NSUInteger)index;

@end

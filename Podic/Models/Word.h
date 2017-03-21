//
//  Word.h
//  RLDictionary
//
//  Created by Ryan Lee on 21/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "NSDate+NSDateFormatter.h"

@protocol Word
@end

@interface Word : JSONModel

@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, assign) BOOL hasRead;

- (instancetype)initWithString:(NSString *)string;

@end

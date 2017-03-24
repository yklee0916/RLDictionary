//
//  WNDBHelper.h
//  Tmap5
//
//  Created by younggi.lee on 24/03/2017.
//  Copyright © 2017 SK telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Word
@end

@protocol Definition
@end

@protocol Example
@end

@interface Word : JSONModelOptional

@property (nonatomic, strong) NSString *word;
@property (nonatomic, assign) NSInteger wordId;
@property (nonatomic, strong) NSArray <Definition> *definitions;

@end

@interface Definition : JSONModelOptional

@property (nonatomic, strong) NSString *definition;
@property (nonatomic, assign) NSInteger defId;
@property (nonatomic, assign) NSInteger partOfSpeech;
@property (nonatomic, strong) NSArray <Example> *examples;

@end

@interface Example : JSONModelOptional

@property (nonatomic, strong) NSString *example;
@property (nonatomic, assign) NSInteger egId;

@end

@interface WNDBHelper : NSObject

- (BOOL)loadWithError:(NSError **)error;
- (Word *)wordWithString:(NSString *)string;

@end

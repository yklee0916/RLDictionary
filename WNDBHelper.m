//
//  WNDBHelper.m
//  Tmap5
//
//  Created by younggi.lee on 24/03/2017.
//  Copyright © 2017 SK telecom. All rights reserved.
//

#import "WNDBHelper.h"
#import "FMDB.h"

@implementation Word

- (NSString *)description {
    return [self toJSONString];
}

@end

@implementation Definition

- (NSString *)description {
    return [self toJSONString];
}

@end

@implementation Example

- (NSString *)description {
    return [self toJSONString];
}

@end

@interface WNDBHelper ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation WNDBHelper

- (BOOL)loadWithError:(NSError **)error {
    
    if(![self openDatabase]) {
        NSError *databaseOpenError = [NSError errorWithDomain:@"database load failed" code:1001 userInfo:nil];
        if (error) *error = databaseOpenError;
        return NO;
    }
    
    return YES;
}

- (BOOL)openDatabase {
    
    @try{
        self.database = [FMDatabase databaseWithPath:self.databaseFileFullPath];
        if(![self.database open]) return NO;
    }
    @catch (NSException * e) {
    }
    return YES;
}

- (Word *)wordWithString:(NSString *)string {
    
    if(!string) return nil;
    
    Word *word = [[Word alloc] init];
    word.word = string;
    word.wordId = [self wordIdWithWord:string];
    word.definitions = [self definitionsWithWordId:word.wordId];
    
    return word;
}

// ---- words -----

- (NSInteger)wordIdWithWord:(NSString *)word {
    
    @try {
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT wordid FROM %@ WHERE word='%@'", @"words", word];
        NSInteger wordId = [self.database intForQuery:selectQuery];
        return wordId;
    }
    @catch (NSException * e) {
    }
    return -1;
}

// ---- def -----

- (NSArray <Definition> *)definitionsWithWordId:(NSInteger)wordId {
    if(wordId == -1) return nil;
    
    NSArray <NSNumber *> *defIds = [self defIdsWithWordId:wordId];
    if(defIds.count == 0) return nil;
    
    NSMutableArray <Definition> *definitions = [NSMutableArray <Definition> array];
    for(NSNumber *defId in defIds) {
        Definition *definition = [self definitionWithDefId:[defId integerValue]];
        if(!definition) continue;
        [definitions addObject:definition];
    }
    return definitions;
}

- (NSArray <NSNumber *> *)defIdsWithWordId:(NSInteger)wordId {
    if(wordId == -1) return nil;
    
    @try {
        NSMutableArray <NSNumber *> *defIds = [NSMutableArray <NSNumber *> array];
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT defid FROM %@ WHERE wordid=%d", @"dlinks", (int)wordId];
        FMResultSet *s = [self.database executeQuery:selectQuery];
        
        while ([s next]) {
            NSInteger defId = [s intForColumn:@"defid"];
            [defIds addObject:[NSNumber numberWithInteger:defId]];
        }
        
        return defIds;
    }
    @catch (NSException * e) {
    }
    return nil;
}

- (Definition *)definitionWithDefId:(NSInteger)defId {
    
    @try {
        Definition *definition = [[Definition alloc] init];
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE defid=%d", @"definitions", (int)defId];
        FMResultSet *rs = [self.database executeQuery:selectQuery];
        if ([rs next]) {
            definition.defId = defId;
            definition.definition = [rs stringForColumn:@"definition"];
            definition.partOfSpeech = [rs intForColumn:@"partofspeech"];
            definition.examples = [self examplesWithDefId:defId];
            return definition;
        }
    }
    @catch (NSException * e) {
    }
    return nil;
}

// ---- example -----

- (NSArray <Example> *)examplesWithDefId:(NSInteger)defId {
    if(defId == -1) return nil;
    
    NSArray <NSNumber *> *egIds = [self egIdsWithDefId:defId];
    if(egIds.count == 0) return nil;
    
    NSMutableArray <Example> *examples = [NSMutableArray <Example> array];
    for(NSNumber *egId in egIds) {
        Example *example = [self exampleWithEgId:[egId integerValue]];
        if(!example) continue;
        [examples addObject:example];
    }
    return examples;
}

- (NSArray <NSNumber *> *)egIdsWithDefId:(NSInteger)defId {
    if(defId == -1) return nil;
    
    @try {
        NSMutableArray <NSNumber *> *egIds = [NSMutableArray <NSNumber *> array];
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT egid FROM %@ WHERE defid=%d", @"elinks", (int)defId];
        FMResultSet *s = [self.database executeQuery:selectQuery];
        
        while ([s next]) {
            NSInteger egId = [s intForColumn:@"egid"];
            [egIds addObject:[NSNumber numberWithInteger:egId]];
        }
        
        return egIds;
    }
    @catch (NSException * e) {
    }
    return nil;
}

- (Example *)exampleWithEgId:(NSInteger)egId {
    
    @try {
        Example *example = [[Example alloc] init];
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE egid=%d", @"examples", (int)egId];
        FMResultSet *rs = [self.database executeQuery:selectQuery];
        if ([rs next]) {
            example.egId = egId;
            example.example = [rs stringForColumn:@"example"];
            return example;
        }
    }
    @catch (NSException * e) {
    }
    return nil;
}

- (NSString *)databaseFilePath {
    
    return [NSBundle mainBundle].resourcePath;
}

- (NSString *)databaseFileName {
    
    return @"170319.WN3.1.db";
}

- (NSString *)databaseFileFullPath {
    
    return [self.databaseFilePath stringByAppendingPathComponent:self.databaseFileName];
}

@end

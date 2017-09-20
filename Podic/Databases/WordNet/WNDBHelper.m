//
//  WNDBHelper.m
//  Tmap5
//
//  Created by younggi.lee on 24/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "WNDBHelper.h"
#import "FMDB.h"

@interface WNDBHelper ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation WNDBHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(WNDBHelper, sharedInstance);

#pragma mark - public methods

- (WNWord *)wordWithString:(NSString *)string {
    
    if(!string) return nil;
    
    WNWord *word = [[WNWord alloc] init];
    word.word = string;
    word.wordId = [self wordIdWithWord:string];
    word.definitions = [self orderedDefinitionsWithWordId:word.wordId];
    
    return word;
}

#pragma mark - private methods

- (instancetype)init {
    
    if(self = [super init]) {
        NSError *error;
        [self openDatabaseWithError:&error];
    }
    return self;
}

- (void)dealloc {
    
    [self closeDatabse];
}

- (void)openDatabaseWithError:(NSError **)error {
    
    if(![self openDatabase]) {
        if (error) *error = [[ErrorHandler sharedInstance] errorWithCode:ERROR_WNDATABASE_OPEN];
    }
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

- (BOOL)closeDatabse {
    
    @try{
        if(![self.database close]) return NO;
        self.database = nil;
    }
    @catch (NSException * e) {
    }
    return YES;
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

# pragma mark - <WNWord>

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

# pragma mark - <WNDefinition>

- (NSArray <WNDefinition> *)definitionsWithWordId:(NSInteger)wordId {
    if(wordId == -1) return nil;
    
    NSArray <NSNumber *> *defIds = [self defIdsWithWordId:wordId];
    if(defIds.count == 0) return nil;
    
    NSMutableArray <WNDefinition> *definitions = [NSMutableArray <WNDefinition> array];
    for(NSNumber *defId in defIds) {
        WNDefinition *definition = [self definitionWithDefId:[defId integerValue]];
        if(!definition) continue;
        [definitions addObject:definition];
    }
    return definitions;
}


- (NSArray <WNDefinition> *)orderedDefinitionsWithWordId:(NSInteger)wordId {
    
    NSArray <WNDefinition> *definitions = [self definitionsWithWordId:wordId];
    if(definitions.count == 0) return nil;
    
    NSMutableArray <WNDefinition> *orderedDefinitions = [NSMutableArray <WNDefinition> array];
    
    NSInteger partOfSpeech = 0;
    while(definitions.count != orderedDefinitions.count) {
        
        for(WNDefinition *definition in definitions) {
            if(partOfSpeech != definition.partOfSpeech) continue;
            [orderedDefinitions addObject:definition];
            
        }
        partOfSpeech ++;
    }
    return orderedDefinitions;
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

- (WNDefinition *)definitionWithDefId:(NSInteger)defId {
    
    @try {
        WNDefinition *definition = [[WNDefinition alloc] init];
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

# pragma mark - <WNExample>

- (NSArray <WNExample> *)examplesWithDefId:(NSInteger)defId {
    if(defId == -1) return nil;
    
    NSArray <NSNumber *> *egIds = [self egIdsWithDefId:defId];
    if(egIds.count == 0) return nil;
    
    NSMutableArray <WNExample> *examples = [NSMutableArray <WNExample> array];
    for(NSNumber *egId in egIds) {
        WNExample *example = [self exampleWithEgId:[egId integerValue]];
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

- (WNExample *)exampleWithEgId:(NSInteger)egId {
    
    @try {
        WNExample *example = [[WNExample alloc] init];
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

@end

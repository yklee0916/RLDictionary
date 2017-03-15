//
//  WordDataDBHelper.m
//  RLDictionary
//
//  Created by younggi.lee on 15/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "WordDataDBHelper.h"
#import "FMDB.h"

@interface WordDataDBHelper ()

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray <Word> *words;

@end

@implementation WordDataDBHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(WordDataDBHelper, sharedInstance);

- (instancetype)init {
    if([super init]) {
        self.words = [NSMutableArray <Word> array];
        [self copyToDocumentData];
        [self openDatabase];
    }
    return self;
}

- (NSMutableArray<Word> *)words {
    NSString *key = @"WordbookHideReadWords";
    BOOL hasRead = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    if(hasRead) {
        return [self select];
    }
    else {
        return [self selectWithHasBeenRead:NO];
    }
}

- (void)copyToDocumentData {
    NSError *error;
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.backpupFileURL.absoluteString]) return ;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:self.databaseFileURL.absoluteString]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.databaseFileURL.absoluteString error:&error];
    }
    [[NSFileManager defaultManager] moveItemAtPath:self.backpupFileURL.absoluteString toPath:self.databaseFileURL.absoluteString error:&error];
}

- (NSURL *)backpupFileURL {
    NSMutableString *filePath = [NSMutableString string];
    [filePath appendString:[NSFileManager pathForDocumentDirectory]];
    [filePath appendString:NFFILE_SEPERATOR];
    [filePath appendString:self.databaseFileName];
    return [NSURL URLWithString:filePath];
}

- (NSString *)databaseFileName {
    return @"podic_words.db";
}

- (NSString *)tableName {
    return @"words";
}

- (NSURL *)databaseFileURL {
    NSMutableString *filePath = [NSMutableString string];
    [filePath appendString:[NSFileManager pathForCachesDirectory]];
    [filePath appendString:NFFILE_SEPERATOR];
    [filePath appendString:[[NSBundle mainBundle] bundleIdentifier]];
    [filePath appendString:NFFILE_SEPERATOR];
    [filePath appendString:self.databaseFileName];
    return [NSURL URLWithString:filePath];
}

- (BOOL)openDatabase {
    NSURL *fileURL = self.databaseFileURL;
    return [self openDatabaseWithURL:fileURL];
}

- (BOOL)openDatabaseWithURL:(NSURL *)filePath {
    NSString *filePathString = filePath.absoluteString;
    if(!filePathString) return NO;
    
    @try{
        self.database = [FMDatabase databaseWithPath:filePathString];
        if(![self.database open]) return NO;
        
        [self createTable];
    }
    @catch (NSException * e) {
        return NO;
    }
    return YES;
}

- (void)createTable {
    NSString *sql = @"create table words ( text varchar(100) primary key, createdDate varchar(50), hasRead int )";
    [self.database executeUpdate:sql];
}

- (NSMutableArray<Word> *)select {
    
    NSMutableArray<Word> *words = [NSMutableArray<Word> array];
    
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY createdDate DESC", @"words"];
    FMResultSet *s = [self.database executeQuery:selectQuery];
    
    while ([s next]) {
        NSString *text = [s stringForColumn:@"text"];
        NSString *dateString = [s stringForColumn:@"createdDate"];
        NSUInteger hasRead = [s intForColumn:@"hasRead"];
        
        Word *word = [[Word alloc] init];
        word.string = text;
        word.createdDate = [NSDate dateFromString:dateString];
        word.hasRead = [[NSNumber numberWithInteger:hasRead] boolValue];
        
        if(word) {
            [words addObject:word];
        }
    }
    
    return words;
}

- (NSMutableArray<Word> *)selectWithHasBeenRead:(BOOL)hasRead {
    
    NSMutableArray<Word> *words = [NSMutableArray<Word> array];
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE hasRead=%d ORDER BY createdDate DESC", @"words", hasRead];
    FMResultSet *s = [self.database executeQuery:selectQuery];
    
    while ([s next]) {
        NSString *text = [s stringForColumn:@"text"];
        NSString *dateString = [s stringForColumn:@"createdDate"];
        NSUInteger hasRead = [s intForColumn:@"hasRead"];
        
        Word *word = [[Word alloc] init];
        word.string = text;
        word.createdDate = [NSDate dateFromString:dateString];
        word.hasRead = [[NSNumber numberWithInteger:hasRead] boolValue];
        
        if(word) {
            [words addObject:word];
        }
    }
    
    return words;
}

- (void)addWord:(Word *)word{
    if(!word) return ;
    
    NSString *string = word.string;
    NSString *createdDate = [word.createdDate description];
    BOOL hasRead = word.hasRead;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES ('%@', '%@', %d)", @"words", string, createdDate, hasRead];
    
    [self.database executeUpdate:sql];
}

- (void)updateWord:(Word *)word{
    if(!word) return ;
    
    NSString *string = word.string;
    NSString *createdDate = [word.createdDate description];
    BOOL hasRead = word.hasRead;
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET createdDate='%@', hasRead=%d WHERE text='%@'", @"words", createdDate, hasRead, string];
    
    [self.database executeUpdate:sql];
}

- (void)deleteWord:(Word *)word{
    if(!word) return ;
    
    NSString *string = word.string;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE text='%@'", @"words", string];
    
    [self.database executeUpdate:sql];
}

- (void)deleteAll{
    
}

@end

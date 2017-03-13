//
//  WordDataManager.m
//  RLDictionary
//
//  Created by Ryan Lee on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "WordDataManager.h"
#import "FMDB.h"

@interface WordDataManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation WordDataManager

- (instancetype)init {
    if([super init]) {
        self.words = [NSMutableArray <Word> array];
        [self copyToDocumentData];
        [self openDatabase];
    }
    return self;
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

- (void)reload {
    [self.words removeAllObjects];
    [self loadTable];
}

- (void)loadTable {
    NSString *key = @"WordbookHideReadWords";
    BOOL hasRead = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    if(hasRead) {
        [self select];
    }
    else {
        [self selectWithHasBeenRead:NO];
    }
}

- (void)select {
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
            [self.words addObject:word];
        }
    }
}

- (void)selectWithHasBeenRead:(BOOL)hasRead {
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
            [self.words addObject:word];
        }
    }
}

- (NSUInteger)count {
    return self.words.count;
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    return [self.words stringAtIndex:index];
}

- (void)addWithString:(NSString *)string {
    
    Word *word = [self.words addObjectByString:string];
    [self addWithWord:word];
}

- (void)addWithWord:(Word *)word {
    if(!word) return ;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES ('%@', '%@', %d)", @"words", word.string, [word.createdDate description], word.hasRead];
    [self.database executeUpdate:sql];
}

- (void)updateFromWord:(Word *)word {
    if(!word) return ;
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET createdDate='%@', hasRead=%d WHERE text='%@'", @"words", [word.createdDate description], word.hasRead, word.string];
    [self.database executeUpdate:sql];
}

- (void)removeWithString:(NSString *)string {
    if(string.isEmpty) return ;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE text='%@'", @"words", string];
    [self.database executeUpdate:sql];
}

- (Word *)wordAtString:(NSString *)string {
    return [self.words wordAtString:string];
}

- (BOOL)hasReadWithString:(NSString *)string {
    Word *word = [self.words wordAtString:string];
    return word.hasRead;
}

- (void)setHasRead:(BOOL)hasRead withString:(NSString *)string {
    Word *word = [self.words wordAtString:string];
    word.hasRead = hasRead;
    [self updateFromWord:word];
    [self hideWordIfNeeded:word];
}

- (void)hideWordIfNeeded:(Word *)word {
    if(!word) return ;
    
    NSString *key = @"WordbookHideReadWords";
    BOOL hasRead = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if(!hasRead) return ;
    [self.words removeObjectByString:word.string];
}

- (void)deleteWithString:(NSString *)string {
    [self.words removeObjectByString:string];
    [self removeWithString:string];
}

+ (instancetype)savedObject {
    
    static WordDataManager *accessorname = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accessorname = [[WordDataManager alloc] init];
        [accessorname loadTable];
    });
    
    return accessorname;
}

- (void)resetAll {
    
    [self.words removeAllObjects];
}

- (NSString *)description {
    return [self toJSONString];
}

@end

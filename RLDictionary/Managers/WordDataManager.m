//
//  WordDataManager.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
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
        
        [self loadDatabase];
    }
    return self;
}

- (NSString *)pathForCachesDirectory
{
    static NSString *path = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        path = [paths lastObject];
    });
    
    return path;
}

- (NSString *)databaseFileName {
    return @"podic_words.db";
}

- (BOOL)loadDatabase {
    NSMutableString *filePath = [NSMutableString string];
    [filePath appendString:[self pathForCachesDirectory]];
    [filePath appendString:@"/"];
//    [filePath appendString:@"/com.test.tmap/"];
    [filePath appendString:[self databaseFileName]];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    return [self loadDatabaseWithURL:fileURL];
}

- (BOOL)loadDatabaseWithURL:(NSURL *)filePath {
    NSString *filePathString = filePath.absoluteString;
    if(!filePathString) return NO;
    
    @try{
        self.database = [FMDatabase databaseWithPath:filePathString];
        if(![self.database open]) return NO;
        
        [self create];
    }
    @catch (NSException * e) {
    }
    return YES;
}

- (void)create {
    NSString *sql = @"create table words ( text varchar(100) primary key, createdDate varchar(50), hasRead int )";
    [self.database executeUpdate:sql];
}

- (void)select {
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ", @"words"];
    FMResultSet *s = [self.database executeQuery:selectQuery];
    
    while ([s next]) {
        NSString *text = [s stringForColumn:@"text"];
        NSString *dateString = [s stringForColumn:@"createdDate"];
        NSUInteger hasRead = [s intForColumn:@"hasRead"];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        Word *word = [[Word alloc] init];
        word.string = text;
        word.createdDate = [df dateFromString:dateString];
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
    [self save];
}

- (void)addWithWord:(Word *)word {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *createdDate = [df stringFromDate:word.createdDate];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES ('%@', '%@', %d)", @"words", word.string, createdDate, word.hasRead];
    [self.database executeUpdate:sql];
}


- (void)removeWithString:(NSString *)string {
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
    [self save];
}

- (void)deleteWithString:(NSString *)string {
    [self.words removeObjectByString:string];
    [self removeWithString:string];
    [self save];
}

+ (instancetype)savedObject {
    
    static WordDataManager *accessorname = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        accessorname = [[WordDataManager alloc] init];
        [accessorname select];
        
        
//        NSString *key = NSStringFromClass([WordDataManager class]);
//        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
//        NSLog(@"%@",jsonString);
//        NSError *error;
//        accessorname = jsonString.length > 0 ? [[WordDataManager alloc] initWithString:jsonString error:&error] : [[WordDataManager alloc] init];
    });
    return accessorname;
}

- (void)resetAll {
    [self.words removeAllObjects];
    [self save];
}

- (void)save {
    NSString *jsonString = [self toJSONString];
    if(jsonString.length == 0) return ;
    NSString *key = NSStringFromClass([WordDataManager class]);
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)description {
    return [self toJSONString];
}

@end

//
//  NSFileManager+NSSearchPath.m
//  Podic
//
//  Created by Andrew Lee on 06/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "NSFileManager+NSSearchPath.h"

@implementation NSFileManager (NSSearchPath)

+ (NSString *)pathForCachesDirectory {
    static NSString *cachesDirectoryPath = nil;
    static dispatch_once_t cachesDirectoryToken;
    dispatch_once(&cachesDirectoryToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cachesDirectoryPath = [paths lastObject];
    });
    return cachesDirectoryPath;
}

+ (NSString *)pathForDocumentDirectory {
    static NSString *documentDirectoryPath = nil;
    static dispatch_once_t documentDirectoryToken;
    dispatch_once(&documentDirectoryToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectoryPath = [paths lastObject];
    });
    return documentDirectoryPath;
}

@end

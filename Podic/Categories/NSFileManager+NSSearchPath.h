//
//  NSFileManager+NSSearchPath.h
//  Podic
//
//  Created by younggi.lee on 06/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NFFILE_SEPERATOR  @"/"

@interface NSFileManager (NSSearchPath)

+ (NSString *)pathForCachesDirectory;
+ (NSString *)pathForDocumentDirectory;

@end

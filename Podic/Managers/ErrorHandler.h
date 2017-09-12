//
//  ErrorHandler.h
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ERROR_CODE) {
    
    // error of databases
    ERROR_WNDATABASE_OPEN,
    ERROR_WNDATABASE_CLOSE,
    ERROR_WNDATABASE_EXECUTE_QUERY,
    
};

@interface ErrorHandler : NSObject

+ (ErrorHandler *)sharedInstance;

- (NSError *)errorWithCode:(ERROR_CODE)code;

@end

//
//  ErrorHandler.m
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "ErrorHandler.h"

@interface ErrorHandler ()

@property (nonatomic, strong) NSDictionary *errorDomains;

@end

@implementation ErrorHandler

#pragma mark - public methods

SYNTHESIZE_SINGLETON_FOR_CLASS(ErrorHandler, sharedInstance);

- (NSError *)errorWithCode:(ERROR_CODE)code {

    NSError *error = [NSError errorWithDomain:[self errorDomainAtCode:code] code:code userInfo:nil];
    if(DEBUG) {
        [self printError:error];
    }
    return error;
}

- (void)printError:(NSError *)error {
    NSLog(@"[ErrorHandler] error occured : (%d) %@", (int)error.code, error.domain);
}

#pragma mark - private methods

- (NSDictionary *)errorDomains {
    return @{
             @(ERROR_WNDATABASE_OPEN) : @"MCSessionStateNotConnected",
             @(ERROR_WNDATABASE_CLOSE) : @"MCSessionStateConnecting",
             @(ERROR_WNDATABASE_EXECUTE_QUERY) : @"MCSessionStateConnected",
             };
}

- (NSString *)errorDomainAtCode:(ERROR_CODE)code {
    return [self.errorDomains objectForKey:[NSNumber numberWithInt:code]];
}

@end

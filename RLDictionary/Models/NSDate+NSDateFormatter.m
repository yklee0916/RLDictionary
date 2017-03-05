//
//  NSDate+NSDateFormatter.m
//  RLDictionary
//
//  Created by Ryan Lee on 22/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#define DEFAULT_DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ssZ"

#import "NSDate+NSDateFormatter.h"

@implementation NSDate (Word)

+ (instancetype)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string dateFormat:DEFAULT_DATE_FORMAT];
}

+ (instancetype)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat{
    if(string.length == 0) return nil;
    if(dateFormat.length == 0) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateFormat];
}

- (NSString *)descriptionWithDateFormat:(NSString *)dateFormat {
    if(dateFormat.length == 0) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)description {
    return [self descriptionWithDateFormat:DEFAULT_DATE_FORMAT];
}

@end

//
//  NSDate+Word.m
//  RLDictionary
//
//  Created by younggi.lee on 22/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "NSDate+Word.h"

@implementation NSDate (Word)

- (NSString *)descriptionWithDateFormatString:(NSString *)string {
    if(string.length == 0) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:string];
    return [dateFormatter stringFromDate:self];
}

@end

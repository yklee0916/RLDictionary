//
//  NSDate+NSDateFormatter.h
//  Podic
//
//  Created by Ryan Lee on 22/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDateFormatter)

+ (instancetype)dateFromString:(NSString *)string;
+ (instancetype)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

- (NSString *)descriptionWithDateFormat:(NSString *)dateFormat;

@end

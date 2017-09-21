//
//  NSString+ColorAttribute.m
//  Podic
//
//  Created by Andrew Lee on 21/09/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "NSString+ColorAttribute.h"

@implementation NSString (ColorAttribute)

- (NSMutableAttributedString *)stringWithColor:(UIColor *)color inRange:(NSRange)range {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return mutableAttributedString;
}

@end

@implementation NSAttributedString (ColorAttribute)

- (NSMutableAttributedString *)stringWithColor:(UIColor *)color inRange:(NSRange)range {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return mutableAttributedString;
}

@end

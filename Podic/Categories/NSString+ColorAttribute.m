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
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributedString;
}

- (NSMutableAttributedString *)defaultColorAttributedString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: [[NSMutableParagraphStyle alloc] init]};
    [attributedString addAttributes:attributes range:NSMakeRange(0, self.length)];
    return attributedString;
}

@end

@implementation NSAttributedString (ColorAttribute)

- (NSMutableAttributedString *)stringWithColor:(UIColor *)color inRange:(NSRange)range {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributedString;
}

- (NSMutableAttributedString *)defaultColorAttributedString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: [[NSMutableParagraphStyle alloc] init]};
    [attributedString addAttributes:attributes range:NSMakeRange(0, self.length)];
    return attributedString;
}

@end

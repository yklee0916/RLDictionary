//
//  NSString+FormattedList.m
//  Podic
//
//  Created by Andrew Lee on 20/09/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "NSString+FormattedList.h"

@implementation NSString (FormattedList)

- (NSParagraphStyle *)bulletPointParagraphStyle {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15;
    return paragraphStyle;
}

- (NSParagraphStyle *)orderedNumberParagraphStyle {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20;
    return paragraphStyle;
}

- (NSMutableAttributedString *)attributedStringWithBulletPoint {
    
    NSString *textWithBulletPoint = [NSString stringWithFormat:@"•  %@",self];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:self.bulletPointParagraphStyle};
    return [[NSMutableAttributedString alloc] initWithString:textWithBulletPoint attributes:attributes];
}

- (NSMutableAttributedString *)attributedStringWithOrderedNumber:(NSInteger)number {
    
    NSString *textWithOrderedNumber = [NSString stringWithFormat:@"%d.  %@",(int)number, self];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:self.orderedNumberParagraphStyle};
    return [[NSMutableAttributedString alloc] initWithString:textWithOrderedNumber attributes:attributes];
}

@end

@implementation NSAttributedString (FormattedList)

- (NSParagraphStyle *)bulletPointParagraphStyle {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15;
    return paragraphStyle;
}

- (NSParagraphStyle *)orderedNumberParagraphStyle {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20;
    return paragraphStyle;
}

- (NSMutableAttributedString *)attributedStringWithBulletPoint {
    
    NSMutableAttributedString *textWithBulletPoint = [[NSString string] attributedStringWithBulletPoint];
    [textWithBulletPoint appendAttributedString:self];
    NSRange textRange = NSMakeRange(0, textWithBulletPoint.length);
    [textWithBulletPoint addAttribute:NSParagraphStyleAttributeName value:self.bulletPointParagraphStyle range:textRange];
    return textWithBulletPoint;
}

- (NSMutableAttributedString *)attributedStringWithOrderedNumber:(NSInteger)number {
    
    NSMutableAttributedString *textWithOrderedNumber = [[NSString string] attributedStringWithOrderedNumber:number];
    [textWithOrderedNumber appendAttributedString:self];
    NSRange textRange = NSMakeRange(0, textWithOrderedNumber.length);
    [textWithOrderedNumber addAttribute:NSParagraphStyleAttributeName value:self.orderedNumberParagraphStyle range:textRange];
    return textWithOrderedNumber;
}

@end

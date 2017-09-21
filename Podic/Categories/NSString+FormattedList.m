//
//  NSString+FormattedList.m
//  Podic
//
//  Created by Andrew Lee on 20/09/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "NSString+FormattedList.h"

@implementation NSString (FormattedList)

+ (NSParagraphStyle *)bulletPointParagraphStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15;
    return paragraphStyle;
}

+ (NSParagraphStyle *)orderedNumberParagraphStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20;
    return paragraphStyle;
}

- (NSMutableAttributedString *)stringWithBulletPoint {
    NSString *textWithBulletPoint = [NSString stringWithFormat:@"•  %@",self];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: [NSString bulletPointParagraphStyle]};
    return [[NSMutableAttributedString alloc] initWithString:textWithBulletPoint attributes:attributes];
}

- (NSMutableAttributedString *)stringWithOrderedNumber:(NSInteger)number {
    NSString *textWithOrderedNumber = [NSString stringWithFormat:@"%d.  %@",(int)number, self];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: [NSString orderedNumberParagraphStyle]};
    return [[NSMutableAttributedString alloc] initWithString:textWithOrderedNumber attributes:attributes];
}

@end

@implementation NSAttributedString (FormattedList)

- (NSMutableAttributedString *)stringWithBulletPoint {
    NSMutableAttributedString *textWithBulletPoint = [[NSString string] stringWithBulletPoint];
    [textWithBulletPoint appendAttributedString:self];
    [textWithBulletPoint addAttribute:NSParagraphStyleAttributeName value:[NSString bulletPointParagraphStyle] range:NSMakeRange(0, textWithBulletPoint.length)];
    return textWithBulletPoint;
}

- (NSMutableAttributedString *)stringWithOrderedNumber:(NSInteger)number {
    NSMutableAttributedString *textWithOrderedNumber = [[NSString string] stringWithOrderedNumber:number];
    [textWithOrderedNumber appendAttributedString:self];
    [textWithOrderedNumber addAttribute:NSParagraphStyleAttributeName value:[NSString orderedNumberParagraphStyle] range:NSMakeRange(0, textWithOrderedNumber.length)];
    return textWithOrderedNumber;
}

@end

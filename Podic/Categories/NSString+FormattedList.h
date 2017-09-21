//
//  NSString+FormattedList.h
//  Podic
//
//  Created by Andrew Lee on 20/09/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormattedList)

+ (NSParagraphStyle *)bulletPointParagraphStyle;
+ (NSParagraphStyle *)orderedNumberParagraphStyle;

- (NSMutableAttributedString *)stringWithBulletPoint;
- (NSMutableAttributedString *)stringWithOrderedNumber:(NSInteger)number;

@end

@interface NSAttributedString (FormattedList)

- (NSMutableAttributedString *)stringWithBulletPoint;
- (NSMutableAttributedString *)stringWithOrderedNumber:(NSInteger)number;

@end


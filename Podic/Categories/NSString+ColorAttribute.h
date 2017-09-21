//
//  NSString+ColorAttribute.h
//  Podic
//
//  Created by Andrew Lee on 21/09/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ColorAttribute)

- (NSMutableAttributedString *)stringWithColor:(UIColor *)color inRange:(NSRange)range;

@end

@interface NSAttributedString (ColorAttribute)

- (NSMutableAttributedString *)stringWithColor:(UIColor *)color inRange:(NSRange)range;

@end

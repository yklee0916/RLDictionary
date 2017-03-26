//
//  UILabel+BulletPoint.m
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "UILabel+BulletPoint.h"

@implementation UILabel (BulletPoint)

- (void)setTextWithBulletPoint:(NSString *)text {

    NSString *textWithBulletPoint = [NSString stringWithFormat:@"•  %@",text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15;
    
    self.attributedText = [[NSAttributedString alloc] initWithString:textWithBulletPoint attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
}


- (void)setText:(NSString *)text withBulletNumber:(NSInteger)number {
    
    NSString *textWithBulletPoint = [NSString stringWithFormat:@"%d. %@",(int)number, text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20;
    
    self.attributedText = [[NSAttributedString alloc] initWithString:textWithBulletPoint attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
}
@end

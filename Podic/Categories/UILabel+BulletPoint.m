//
//  UILabel+BulletPoint.m
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "UILabel+BulletPoint.h"

@implementation UILabel (BulletPoint)

- (void)setTextWithBulletPoint:(NSString *)text {

    NSString *textWithBulletPoint = [NSString stringWithFormat:@"•  %@",text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    self.attributedText = [[NSAttributedString alloc] initWithString:textWithBulletPoint attributes:attributes];
}


- (void)setText:(NSString *)text withBulletNumber:(NSInteger)number {
    
    NSString *textWithBulletPoint = [NSString stringWithFormat:@"%d.  %@",(int)number, text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 20;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    self.attributedText = [[NSAttributedString alloc] initWithString:textWithBulletPoint attributes:attributes];
}
@end

//
//  UILabel+BulletPoint.h
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (BulletPoint)

- (void)setTextWithBulletPoint:(NSString *)text;
- (void)setText:(NSString *)text withBulletNumber:(NSInteger)number;

@end

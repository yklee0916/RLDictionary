//
//  UILabel+BulletPoint.h
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (BulletPoint)

- (void)setTextWithBulletPoint:(NSString *)text;
- (void)setText:(NSString *)text withBulletNumber:(NSInteger)number;

@end

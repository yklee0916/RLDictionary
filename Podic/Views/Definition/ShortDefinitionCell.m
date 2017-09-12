//
//  ShortDefinitionCell.m
//  Podic
//
//  Created by Andrew Lee on 27/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "ShortDefinitionCell.h"

@implementation ShortDefinitionCell

- (void)setDimmed:(BOOL)dimmed {
    [self.dimmedView setHidden:!dimmed];
}

@end

//
//  DefinitionCell.m
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "DefinitionCell.h"

@implementation DefinitionCell

- (void)setDimmed:(BOOL)dimmed {
    [self.dimmedView setHidden:!dimmed];
}

@end

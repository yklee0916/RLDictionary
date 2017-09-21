//
//  ShortDefinitionCell.h
//  Podic
//
//  Created by Andrew Lee on 27/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortDefinitionCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *definitionLabel;
@property (nonatomic, assign) IBOutlet UIView *dimmedView;

- (void)setDimmed:(BOOL)dimmed;

@end

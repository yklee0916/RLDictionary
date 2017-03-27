//
//  DefinitionCell.h
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartOfSpeechView.h"
#import "UILabel+BulletPoint.h"

@interface DefinitionCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIView *partOfSpeechView;
@property (nonatomic, assign) IBOutlet UILabel *partOfSpeechLabel;
@property (nonatomic, assign) IBOutlet UILabel *definitionLabel;
@property (nonatomic, assign) IBOutlet UIView *dimmedView;

- (void)setDimmed:(BOOL)dimmed;

@end

//
//  DefinitionCell.h
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartOfSpeechView.h"

@interface DefinitionCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIView *partOfSpeechView;
@property (nonatomic, assign) IBOutlet UILabel *partOfSpeechLabel;
@property (nonatomic, assign) IBOutlet UILabel *definitionLabel;

@end

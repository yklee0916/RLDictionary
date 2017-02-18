//
//  DictionaryViewController.h
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface DictionaryTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *index;
@property (nonatomic, assign) IBOutlet UILabel *definition;

@end


@interface DictionaryViewController : UIViewController

@property Word *word;

@end

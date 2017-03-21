//
//  SettingViewController.h
//  Podic
//
//  Created by Ryan Lee on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *title;
@property (nonatomic, assign) IBOutlet UILabel *content;
@property (nonatomic, assign) IBOutlet UIButton *linkableContent;


@end

@interface SettingViewController : UIViewController

@end

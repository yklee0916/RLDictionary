//
//  SettingViewController.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "SettingViewController.h"
#import "DictionaryManager.h"

@implementation SettingTableViewCell
@end

@interface SettingViewController ()

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contents;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSArray *)contents {
    if (!_contents) {
        _contents = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"]];
    }
    return _contents;
}

- (IBAction)doneNavigationBarButtonItemAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    NSUInteger index = indexPath.row;
    NSString *key = [self.contents objectAtIndex:index];
    NSString *title = NSLocalizedString(key, nil);
    NSString *content = NSLocalizedString([key substringFromIndex:1], nil);
    [cell.title setText:title];
    [cell.content setText:content];
    
    if([key isEqualToString:@"kAppVersion"]) {
        [cell.title setText:title];
        [cell.content setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    else if([key isEqualToString:@"kResetWordbook"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"linkableCell"];
        [cell.title setText:title];
        [cell.linkableContent setTitle:content forState:UIControlStateNormal];
        [cell.linkableContent setTitle:content forState:UIControlStateHighlighted];
        [cell.linkableContent addTarget:self action:@selector(resetWordbookAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([key isEqualToString:@"kDonate"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"linkableCell"];
        [cell.title setText:title];
        [cell.linkableContent setTitle:content forState:UIControlStateNormal];
        [cell.linkableContent setTitle:content forState:UIControlStateHighlighted];
        [cell.linkableContent addTarget:self action:@selector(donateToDeveloperAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)resetWordbookAction:(id)sender {
    [[DictionaryManager savedObject] resetWordbook];
    [self.view makeToast:@"초기화 되었습니다."];
}

- (void)donateToDeveloperAction:(id)sender {
    [self.view makeToast:@"기부되었습니다."];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end

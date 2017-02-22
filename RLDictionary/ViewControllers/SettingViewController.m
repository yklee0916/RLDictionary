//
//  SettingViewController.m
//  RLDictionary
//
//  Created by Rio on 19/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "SettingViewController.h"
#import "WordbookManager.h"

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
    else if([key isEqualToString:@"kWordbookArrangeByType"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"linkableCell"];
        [cell.title setText:title];
        content = NSLocalizedString(self.wordbookArrangeType ? @"WordbookArrangeByTypeWeek" : @"WordbookArrangeByTypeDay", nil);
        [cell.linkableContent setTitle:content forState:UIControlStateNormal];
        [cell.linkableContent setTitle:content forState:UIControlStateHighlighted];
        [cell.linkableContent addTarget:self action:@selector(setWordbookArrangeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (BOOL)wordbookArrangeType {
    NSString *key = @"WordbookManagerGroupingType";
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setWordbookArrangeTypeAction:(id)sender {
    NSString *key = @"WordbookManagerGroupingType";
    BOOL byDate = [self wordbookArrangeType];
    [[NSUserDefaults standardUserDefaults] setBool:!byDate forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [[WordbookManager sharedInstance] reload];
}

- (void)resetWordbookAction:(id)sender {
    
    [self presenResetAlertViewControllerWithCompletionHandler:^(UIAlertAction *action) {
        [[WordbookManager sharedInstance] resetAll];
        [self.view makeToast:NSLocalizedString(@"SettingResetAlertResetActionToastMessage", nil)];
    }];
}

- (void)presenResetAlertViewControllerWithCompletionHandler:(void (^)(UIAlertAction *action))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SettingResetAlertTitle", nil)
                                                                             message:NSLocalizedString(@"SettingResetAlertMessage", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SettingResetAlertCancelActionTitle", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SettingResetAlertResetActionTitle", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:handler];
    [alertController addAction:resetAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)donateToDeveloperAction:(id)sender {
    [self.view makeToast:@"기부되었습니다."];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end

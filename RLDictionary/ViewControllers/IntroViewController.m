//
//  IntroViewController.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "IntroViewController.h"
#import "WordDataManager.h"
#import "WordbookManager.h"

@interface IntroViewController ()

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) WordDataManager *wordDataManager;
@property (nonatomic, strong) WordbookManager *wordbookManager;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wordDataManager = [WordDataManager savedObject];
    self.wordbookManager = [WordbookManager sharedInstance];
    [self.wordbookManager reload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wordbookDidChanged:)
                                                 name:@"wordbookDidChangedNotification"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)settingNavigationBarButtonItemAction:(id)sender {
    [self performSegueWithIdentifier: @"presentSettingSegue" sender: self];
}

- (IBAction)searchNavigationBarButtonItemAction:(id)sender {
    [self textFieldShouldReturn:self.searchTextField];
}

- (void)wordbookDidChanged:(NSString *)word {
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *keyword = textField.text;
    textField.text = nil;
    [self findDefinitionFromDictionaryForTerm:keyword];
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordDataManager.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordbookCell"];
    NSString *string = [self.wordDataManager stringAtIndex:indexPath.row];
    [cell.textLabel setText:string];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *term = [self.wordDataManager stringAtIndex:indexPath.row];
    [self findDefinitionFromDictionaryForTerm:term];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *string = [self.wordDataManager stringAtIndex:indexPath.row];
        [self.wordDataManager deleteWithString:string];
    }
}

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term {
    if(term.length == 0) return ;
    
    [self.wordDataManager findDefinitionFromDictionaryForTerm:term completionHandler:^(UIReferenceLibraryViewController *libarayViewController, NSError *error) {
        
        if(error) {
            [self.view makeToast:error.domain];
            return ;
        }
        
        if(libarayViewController) {
            [self presentViewController:libarayViewController animated:YES completion:nil];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showSettingSegue"]) {
        
    }
}

@end

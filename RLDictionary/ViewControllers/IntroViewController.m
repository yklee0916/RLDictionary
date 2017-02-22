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

@implementation WordbookHeaderCell
@end

@interface IntroViewController ()

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) WordbookManager *wordbookManager;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wordbookManager = [WordbookManager sharedInstance];
    [self.wordbookManager reload];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.wordbookManager.wordbooks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:section];
    return wordbook.words.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WordbookHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordbookHeaderCell class])];
    
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:section];
    NSString *string = [wordbook.createdDate descriptionWithDateFormatString:NSLocalizedString(@"IntroWordbookHeaderDateFormat", nil)];
    [cell.textLabel setText:string];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordbookCell"];
    
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    NSString *string = word.string;
    [cell.textLabel setText:string];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    NSString *term = word.string;
    
    [self findDefinitionFromDictionaryForTerm:term];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    NSString *string = word.string;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.wordbookManager deleteWithString:string];
    }
}

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term {
    if(term.length == 0) return ;
    
    [self.wordbookManager findDefinitionFromDictionaryForTerm:term completionHandler:^(UIReferenceLibraryViewController *viewController, NSError *error) {
        
        if(error) {
            [self.view makeToast:error.domain];
            return ;
        }
        
        if(viewController) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showSettingSegue"]) {
        
    }
}

@end

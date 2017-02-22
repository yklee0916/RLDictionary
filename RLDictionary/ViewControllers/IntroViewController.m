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
#import "WordbookHeaderView.h"
#import "WordbookTableViewCell.h"

@interface IntroViewController ()

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) WordbookManager *wordbookManager;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *identifier = NSStringFromClass([WordbookTableViewCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    self.wordbookManager = [WordbookManager sharedInstance];
    [self.wordbookManager reload];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    leftView.backgroundColor = [UIColor clearColor];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    WordbookHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"WordbookHeaderView" owner:self options:nil] firstObject];
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:section];
    NSString *string = [wordbook.createdDate descriptionWithDateFormatString:NSLocalizedString(@"IntroWordbookHeaderDateFormat", nil)];
    [header.textLabel setText:string];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordbookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordbookTableViewCell"];
    
    Wordbook *wordbook = [self.wordbookManager.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    NSString *string = word.string;
    [cell.contentLabel setText:string];
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

//
//  IntroViewController.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "IntroViewController.h"
#import "DictionaryManager.h"

@interface IntroViewController ()

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) DictionaryManager *dictionaryManager;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dictionaryManager = [DictionaryManager savedObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wordbookDidChanged:)
                                                 name:@"wordbookDidChangedNotification"
                                               object:nil];
}

- (IBAction)settingNavigationBarButtonItemAction:(id)sender {
    
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
    return self.dictionaryManager.wordbookCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordbookCell"];
    NSString *word = [self.dictionaryManager wordAtIndexFromWordbook:indexPath.row];
    [cell.textLabel setText:word];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *term = [self.dictionaryManager wordAtIndexFromWordbook:indexPath.row];
    [self findDefinitionFromDictionaryForTerm:term];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *word = [self.dictionaryManager wordAtIndexFromWordbook:indexPath.row];
        [self.dictionaryManager deleteWordToWordbook:word];
    }
}

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term {
    if(term.length == 0) return ;
    
    [self.dictionaryManager findDefinitionFromDictionaryForTerm:term completionHandler:^(UIReferenceLibraryViewController *libarayViewController, NSError *error) {
        
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
}

@end

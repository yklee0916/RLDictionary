//
//  IntroViewController.m
//  Podic
//
//  Created by Andrew Lee on 17/02/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "IntroViewController.h"
#import "WordDataManager.h"
#import "WordDataHandler.h"
#import "WordbookHeaderView.h"
#import "WordbookTableViewCell.h"
#import "WordbookHasReadCell.h"

#import "DefinitionViewController.h"

@interface IntroViewController ()

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) WordDataHandler *WordDataHandler;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *wordbookTableViewCell = NSStringFromClass([WordbookTableViewCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:wordbookTableViewCell bundle:nil] forCellReuseIdentifier:wordbookTableViewCell];
    
    NSString *wordbookHasReadCell = NSStringFromClass([WordbookHasReadCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:wordbookHasReadCell bundle:nil] forCellReuseIdentifier:wordbookHasReadCell];
    
    self.WordDataHandler = [WordDataHandler sharedInstance];
    [self.WordDataHandler reload];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    leftView.backgroundColor = [UIColor clearColor];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wordbookDidChanged:)
                                                 name:@"wordbookDidChangedNotification"
                                               object:nil];
    
    // enable back swipe gesture with custom left back bar button item
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
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
    return self.WordDataHandler.wordbooks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Wordbook *wordbook = [self.WordDataHandler.wordbooks objectAtIndex:section];
    return wordbook.words.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    WordbookHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"WordbookHeaderView" owner:self options:nil] firstObject];
    Wordbook *wordbook = [self.WordDataHandler.wordbooks objectAtIndex:section];
    NSString *string = [wordbook.createdDate descriptionWithDateFormat:NSLocalizedString(@"IntroWordbookHeaderDateFormat", DEFAULT_DATE_FORMAT)];
    [header.textLabel setText:string];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wordbook *wordbook = [self.WordDataHandler.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    
    WordbookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordbookTableViewCell"];
    
    
    if(word.hasRead) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WordbookHasReadCell"];
    }
    
    NSString *string = word.string;
    [cell.contentLabel setText:string];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Wordbook *wordbook = [self.WordDataHandler.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    NSString *term = word.string;
    
    [self findDefinitionFromDictionaryForTerm:term];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *(^imageWithView)(UIView *) = ^(UIView *view) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    };
    
    UIColor *(^getColorWithLabelText)(NSString*, UIColor*, UIColor*) = ^(NSString *text, UIColor *textColor, UIColor *bgColor) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.numberOfLines = 2;
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = textColor;
        label.backgroundColor = bgColor;
        return [UIColor colorWithPatternImage:imageWithView(label)];
    };
    
    Wordbook *wordbook = [self.WordDataHandler.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    BOOL hasRead = word.hasRead;
    NSString *string = word.string;
    NSString *readActionTitle = NSLocalizedString(hasRead ?@"IntroWordbookHideReadWordsYES" : @"IntroWordbookHideReadWordsNO", nil);
    
    UITableViewRowAction *moreAction;
    moreAction = [UITableViewRowAction
                rowActionWithStyle:UITableViewRowActionStyleNormal
                title:@"      "
                handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                    Word *word = [self.WordDataHandler wordAtString:string];
                    word.hasRead = !hasRead;
                    [self.WordDataHandler updateWord:word];
                }];
    moreAction.backgroundColor = getColorWithLabelText(readActionTitle, [UIColor whiteColor], [UIColor lightGrayColor]);
    
    
    UITableViewRowAction *deleteAction;
    deleteAction = [UITableViewRowAction
                  rowActionWithStyle:UITableViewRowActionStyleNormal
                  title:@"      "
                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                        
                        tableView.editing = NO;
                        [self.WordDataHandler deleteWordFromString:string];
                  }];
    NSString *deleteActionTitle = NSLocalizedString(@"IntroWordbookDeleteRow", nil);
    deleteAction.backgroundColor = getColorWithLabelText(deleteActionTitle, [UIColor whiteColor], [UIColor redColor]);
    
    
    return @[deleteAction, moreAction];
    
//    return [deleteRowAction, moreRowAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wordbook *wordbook = [self.WordDataHandler.wordbooks objectAtIndex:indexPath.section];
    Word *word = [wordbook.words objectAtIndex:indexPath.row];
    NSString *string = word.string;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.WordDataHandler deleteWordFromString:string];
    }
}

- (BOOL)isHidden {
    NSString *key = @"DatabaseType";
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)findDefinitionFromDictionaryForTerm:(NSString *)term {
    if(term.length == 0) return ;
    
    [self.WordDataHandler addWordWithString:term];
    
    if(self.isHidden) {
        [self.WordDataHandler findDefinitionFromDictionaryForTerm:term completionHandler:^(UIReferenceLibraryViewController *viewController, NSError *error) {
            
            if(error) {
                [self.view makeToast:error.domain];
                return ;
            }
            
            if(viewController) {
                [self presentViewController:viewController animated:YES completion:nil];
            }
        }];
    }
    else {
        [self performSegueWithIdentifier:@"showDefinitionSegue" sender:term];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showSettingSegue"]) {
        
    }
    else if([segue.identifier isEqualToString:@"showDefinitionSegue"]) {
        
        DefinitionViewController * vc = segue.destinationViewController;
        vc.title = sender;
        vc.wordString = sender;
    }
}

@end

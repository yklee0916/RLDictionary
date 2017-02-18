//
//  IntroViewController.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "IntroViewController.h"
#import "WordDataManager.h"
#import "DictionaryViewController.h"

@interface IntroViewController () <UIViewControllerPreviewingDelegate>

@property IBOutlet UITableView *wordbookTableView;
@property (nonatomic) WordDataManager *wordDataManager;
@property id forceTouchPreviewingContext;


@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wordDataManager = [[WordDataManager alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wordDataDidChanged:)
                                                 name:@"WordDataDidChangedNotification"
                                               object:nil];
    
    UIBarButtonItem *addWordButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWordButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = addWordButtonItem;
    
    [self testWords];
}

- (void)addWordButtonItemAction:(id)sender {
    
}

- (void)wordDataDidChanged:(Word *)word {
    [self.wordbookTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordDataManager.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordbookTableViewCell"];
    
    NSUInteger index = indexPath.row;
    Word *word = [self.wordDataManager wordAtIndex:index];
    [cell.textLabel setText:word.string];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier: @"showDictionarySegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDictionarySegue"]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSUInteger index = indexPath.row;
        Word *word = [self.wordDataManager wordAtIndex:index];
        
        DictionaryViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.word = word;
    }
}

- (void)testWords {
    [self.wordDataManager addWordString:@"lead"];
    [self.wordDataManager addWordString:@"wordbook"];
}

@end

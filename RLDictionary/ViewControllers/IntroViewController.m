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
@property WordDataManager *wordDataManager;
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
    
    [self testWords];
    
//    if ([self isForceTouchAvailable]) {
//        self.forceTouchPreviewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//    }
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

//- (BOOL)isForceTouchAvailable {
//    BOOL isForceTouchAvailable = NO;
//    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
//        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
//    }
//    return isForceTouchAvailable;
//}
//
//- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location{
//    
//    if ([self.presentedViewController isKindOfClass:[DictionaryViewController class]]) return nil;
//    
//    CGPoint cellPostion = [self.wordbookTableView convertPoint:location fromView:self.view];
//    NSIndexPath *path = [self.wordbookTableView indexPathForRowAtPoint:cellPostion];
//    if (!path) return nil;
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    DictionaryViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"DictionaryViewController"];
//    
//    NSUInteger index = path.row;
//    Word *word = [self.wordDataManager wordAtIndex:index];
//    previewController.word = word;
//    
////    UITableViewCell *tableCell = [self.wordbookTableView cellForRowAtIndexPath:path];
//    //        previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:self.wordbookTableView];
//    return previewController;
//    
//}
//
//- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
//     [self presentViewController:viewControllerToCommit animated:YES completion:nil];
//}
//
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) {
//        if (!self.forceTouchPreviewingContext) {
//            self.forceTouchPreviewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        }
//    } else {
//        if (self.forceTouchPreviewingContext) {
//            [self unregisterForPreviewingWithContext:self.forceTouchPreviewingContext];
//            self.forceTouchPreviewingContext = nil;
//        }
//    }
//}

@end

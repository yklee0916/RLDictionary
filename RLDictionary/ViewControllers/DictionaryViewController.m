//
//  DictionaryViewController.m
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "DictionaryViewController.h"
#import "RecourseDictionaryManager.h"

@implementation DictionaryTableViewCell
@end

@interface DictionaryViewController ()

@property (nonatomic, strong) RecourseDictionaryManager *recourseDictionaryManager;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@end

@implementation DictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recourseDictionaryManager = [[RecourseDictionaryManager alloc] init];
    
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 25;
    
    NSString *wordString = self.word.string;
     [self.recourseDictionaryManager requestRecourseDictionaryWithString:wordString completionHandler:^(OxfordDictionariesResponse *response, NSError *error) {
         [self.tableView reloadData];
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.recourseDictionaryManager.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recourseDictionaryManager exampleCountAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"definitionCell"];
    NSString *definition = [self.recourseDictionaryManager senseAtIndex:section].definition;
    [cell.index setText:[NSString stringWithFormat:@"%ld.",++section]];
    [cell.definition setText:definition];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exampleCell"];
    NSUInteger definitionIndex = indexPath.section;
    NSUInteger exampleIndex = indexPath.row;
    
    NSString *definition = [[self.recourseDictionaryManager senseAtIndex:definitionIndex] exampleAtIndex:exampleIndex];
    [cell.index setText:[NSString stringWithFormat:@"ex>"]];
    [cell.definition setText:definition];
    return cell;
}

@end

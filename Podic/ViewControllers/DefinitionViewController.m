//
//  DefinitionViewController.m
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "DefinitionViewController.h"
#import "WordCell.h"
#import "DefinitionCell.h"
#import "ExampleCell.h"
#import "WNDBHelper.h"
#import "ShortDefinitionCell.h"

@interface DefinitionViewController ()

@property (nonatomic, strong) WNWord *word;
@property (nonatomic, assign) IBOutlet UITableView *tableView;

@end

@implementation DefinitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *wordCell = NSStringFromClass([WordCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:wordCell bundle:nil] forCellReuseIdentifier:wordCell];
    
    NSString *definitionCell = NSStringFromClass([DefinitionCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:definitionCell bundle:nil] forCellReuseIdentifier:definitionCell];
    
    NSString *shortDefinitionCell = NSStringFromClass([ShortDefinitionCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:shortDefinitionCell bundle:nil] forCellReuseIdentifier:shortDefinitionCell];
    
    
    NSString *exampleCell = NSStringFromClass([ExampleCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:exampleCell bundle:nil] forCellReuseIdentifier:exampleCell];
    
    if(self.wordString) {
        self.word = [[WNDBHelper sharedInstance] wordWithString:self.wordString];
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.word.definitions.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) return 0;
    
    WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
    return definition.examples.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.0;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        
        WordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordCell class])];
        [cell.wordLabel setText:self.word.word];
        return cell;
    }
    
    if([self shouldShowPartOfSpeech:section]) {
        
        DefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DefinitionCell class])];
        WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
        [cell.partOfSpeechLabel setText:[self partOfSpeechByType:definition.partOfSpeech]];
        [cell.definitionLabel setText:definition.definition withBulletNumber:section];
        return cell;
    }
    else {
        ShortDefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShortDefinitionCell class])];
        WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
        [cell.definitionLabel setText:definition.definition withBulletNumber:section];
        return cell;
    }
    return nil;
}

- (BOOL)shouldShowPartOfSpeech:(NSInteger)section {
    if(section-1 == 0) return YES;
    WNDefinition *pre = [self.word.definitions objectAtIndex:section-2];
    WNDefinition *def = [self.word.definitions objectAtIndex:section-1];
    return pre.partOfSpeech != def.partOfSpeech;
}

- (NSString *)partOfSpeechByType:(NSInteger)type {
    switch(type) {
        case 0:
            return @"Noun";
        case 1:
            return @"Verb";
        case 2:
            return @"Adj";
        case 3:
            return @"Adv";
        default:
            return @"";
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    ExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExampleCell class])];
//    [cell.exampleLabel setText:@""];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExampleCell class])];
    WNDefinition *definition = [self.word.definitions objectAtIndex:indexPath.section - 1];
    WNExample *example = [definition.examples objectAtIndex:indexPath.row];
    [cell.exampleLabel setTextWithBulletPoint:example.example];
    return cell;
}
@end

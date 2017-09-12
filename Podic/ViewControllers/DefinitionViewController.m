//
//  DefinitionViewController.m
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "DefinitionViewController.h"
#import "WordCell.h"
#import "DefinitionCell.h"
#import "ExampleCell.h"
#import "WNDBHelper.h"
#import "ShortDefinitionCell.h"
#import "AVSpeechSynthesizer+AVSpeechUtterance.h"

@import GoogleMobileAds;

@interface DefinitionViewController () <AVSpeechSynthesizerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WNWord *word;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet GADBannerView *bannerView;
@property (nonatomic, strong) WordCell *wordCell;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (nonatomic, strong) NSIndexPath *speechingIndexPath;

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
    
    self.bannerView.adUnitID = @"ca-app-pub-2336447731794699/1581475965";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(self.speechSynthesizer.isSpeaking) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.speechingIndexPath = nil;
        self.speechSynthesizer = nil;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section >= self.word.definitions.count) return 25.0;
    return CGFLOAT_MIN;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)speakerButtonAction:(id)sender {
    BOOL selected = self.wordCell.speakerButton.selected;
    [self.wordCell.speakerButton setSelected:!selected];
    [self.tableView setAllowsSelection:!selected];
    [self.tableView reloadData];
    
    if(!self.wordCell.speakerButton.selected) {
        if(self.speechSynthesizer.isSpeaking) {
            [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            self.speechingIndexPath = nil;
            self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
            self.speechSynthesizer.delegate = self;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        if(!self.wordCell) {
            self.wordCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordCell class])];
            [self.wordCell.speakerButton addTarget:self action:@selector(speakerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectHeaderAtIndexPath:)];
            gesture.delegate = self;
            [self.wordCell.wordLabel addGestureRecognizer:gesture];
        }
        
        [self.wordCell.wordLabel setText:self.word.word];
        return self.wordCell;
    }
    
    if([self shouldShowPartOfSpeech:section]) {
        
        DefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DefinitionCell class])];
        WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
        [cell.partOfSpeechLabel setText:[self partOfSpeechByType:definition.partOfSpeech]];
        [cell.definitionLabel setText:definition.definition withBulletNumber:section];
        [cell setDimmed:self.wordCell.speakerButton.selected];
        
        return cell;
    }
    else {
        ShortDefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShortDefinitionCell class])];
        WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
        [cell.definitionLabel setText:definition.definition withBulletNumber:section];
        [cell setDimmed:self.wordCell.speakerButton.selected];
        
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didSelectHeaderAtIndexPath:(UITapGestureRecognizer *)gesture {
    
    [self.speechSynthesizer speakWithString:self.wordCell.wordLabel.text];
    [self.tableView setAllowsSelection:NO];
    [self.wordCell setBackgroundColor:[UIColor whiteColor]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    
    [self.wordCell setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if(!self.tableView.allowsSelection) return NO;
    
    [self.wordCell setBackgroundColor:[UIColor lightGrayColor]];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    WNDefinition *definition = [self.word.definitions objectAtIndex:indexPath.section - 1];
    WNExample *example = [definition.examples objectAtIndex:indexPath.row];
    [self.speechSynthesizer speakWithString:example.example];
    self.speechingIndexPath = indexPath;
    
    [self.tableView setAllowsSelection:NO];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
willSpeakRangeOfSpeechString:(NSRange)characterRange
                utterance:(AVSpeechUtterance *)utterance {
//    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
    
    
    
    if(self.speechingIndexPath) {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:utterance.speechString];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
        
        NSMutableAttributedString *m = [[NSMutableAttributedString alloc] initWithString:@"•  "];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.headIndent = 15;
        
        [m appendAttributedString:mutableAttributedString];
        [m addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, m.length)];
    
        ExampleCell *cell = [self.tableView cellForRowAtIndexPath:self.speechingIndexPath];
        cell.exampleLabel.attributedText = m;
    }
    else {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:utterance.speechString];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
        self.wordCell.wordLabel.attributedText = mutableAttributedString;
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
  didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    // lock for others selecting
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
 didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    if(!self.wordCell.speakerButton.selected) return ;
    
    if(self.speechingIndexPath) {
        ExampleCell *cell = [self.tableView cellForRowAtIndexPath:self.speechingIndexPath];
        [cell.exampleLabel setTextWithBulletPoint:utterance.speechString];
    }
    else {
        [self.wordCell.wordLabel setText:utterance.speechString];
    }
    
    self.speechingIndexPath = nil;
    
    if(self.wordCell.speakerButton.selected) {
        [self.tableView setAllowsSelection:YES];
    }
}
@end


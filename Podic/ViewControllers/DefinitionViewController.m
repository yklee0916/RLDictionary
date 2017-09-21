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

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet GADBannerView *bannerView;

@property (nonatomic, strong) WNWord *word;
@property (nonatomic, strong) WordCell *wordCell;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (nonatomic, strong) NSIndexPath *speechingIndexPath;

@end

@implementation DefinitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *customCellClasses = @[[WordCell class], [DefinitionCell class], [ShortDefinitionCell class], [ExampleCell class]];
    self.tableView.customCellClasses = customCellClasses;
    [self configureGADBannerView];
    
    if(self.wordString) {
        self.word = [[WNDBHelper sharedInstance] wordWithString:self.wordString];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializeSpeechSynthesizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopSpeechSynthesizerIfNeeded];
}

- (void)configureGADBannerView {
    
    self.bannerView.adUnitID = @"ca-app-pub-2336447731794699/1581475965";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)initializeSpeechSynthesizer {
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;
}

- (void)stopSpeechSynthesizerIfNeeded {
    
    if(self.speechSynthesizer.isSpeaking) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.speechingIndexPath = nil;
        self.speechSynthesizer = nil;
    }
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)speakerButtonAction:(id)sender {
    
    BOOL selected = self.wordCell.speakerButton.selected;
    self.wordCell.speakerButton.selected = !selected;
    self.tableView.allowsSelection = !selected;
    [self.tableView reloadData];
    
    if(!self.wordCell.speakerButton.selected) {
        [self stopSpeechSynthesizerIfNeeded];
        [self initializeSpeechSynthesizer];
    }
}

- (BOOL)shouldShowPartOfSpeech:(NSInteger)section {
    
    if(section - 1 == 0) {
        return YES;
    }
    
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

- (void)didSelectHeaderAtIndexPath:(UITapGestureRecognizer *)gesture {
    
    [self.speechSynthesizer speakWithString:self.wordCell.wordLabel.text];
    self.tableView.allowsSelection = NO;
    self.wordCell.backgroundColor = UIColor.whiteColor;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    
    self.wordCell.backgroundColor = UIColor.whiteColor;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if(!self.tableView.allowsSelection) {
        return NO;
    }
    
    self.wordCell.backgroundColor = UIColor.lightGrayColor;
    return YES;
}

- (void)setSpeechStringToSelectedLabel:(NSString *)speechString {
    
    NSAttributedString *attributedString = self.speechingIndexPath ? speechString.attributedStringWithBulletPoint : speechString.defaultColorAttributedString ;
    [self setSpeechAttributedStringToSelectedLabel:attributedString];
}

- (BOOL)isSelectedExampleLabel {
    return (self.speechingIndexPath);
}

- (void)setSpeechAttributedStringToSelectedLabel:(NSAttributedString *)speechAttributedString {
    
    UILabel *selectedLabel;
    
    if(self.isSelectedExampleLabel) {
        ExampleCell *cell = [self.tableView cellForRowAtIndexPath:self.speechingIndexPath];
        selectedLabel = cell.exampleLabel;
    }
    else {
        selectedLabel = self.wordCell.wordLabel;
    }
    
    selectedLabel.attributedText = speechAttributedString;
}

#pragma mark - UITableViewrDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        
        if(!self.wordCell) {
            self.wordCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordCell class])];
            [self.wordCell.speakerButton addTarget:self action:@selector(speakerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectHeaderAtIndexPath:)];
            gesture.delegate = self;
            [self.wordCell.wordLabel addGestureRecognizer:gesture];
        }
        
        self.wordCell.wordLabel.text = self.word.word;
        return self.wordCell;
    }
    
    if([self shouldShowPartOfSpeech:section]) {
        DefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DefinitionCell class])];
        WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
        [cell.partOfSpeechLabel setText:[self partOfSpeechByType:definition.partOfSpeech]];
        cell.definitionLabel.attributedText = [definition.definition attributedStringWithOrderedNumber:section];
        [cell setDimmed:self.wordCell.speakerButton.selected];
        return cell;
    }
    else {
        ShortDefinitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShortDefinitionCell class])];
        WNDefinition *definition = [self.word.definitions objectAtIndex:section-1];
        cell.definitionLabel.attributedText = [definition.definition attributedStringWithOrderedNumber:section];
        [cell setDimmed:self.wordCell.speakerButton.selected];
        return cell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExampleCell class])];
    WNDefinition *definition = [self.word.definitions objectAtIndex:indexPath.section - 1];
    WNExample *example = [definition.examples objectAtIndex:indexPath.row];
    cell.exampleLabel.attributedText = example.example.attributedStringWithBulletPoint;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.word.definitions.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 0;
    }
    
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
    return section >= self.word.definitions.count ? 25.0 : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WNDefinition *definition = [self.word.definitions objectAtIndex:indexPath.section - 1];
    WNExample *example = [definition.examples objectAtIndex:indexPath.row];
    [self.speechSynthesizer speakWithString:example.example];
    self.speechingIndexPath = indexPath;
    self.tableView.allowsSelection = NO;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    
    UIColor *speechCharacterColor = [UIColor redColor];
    NSString *speechString = utterance.speechString;
    NSMutableAttributedString *attributedString = [speechString attributedStringWithColor:speechCharacterColor inRange:characterRange];
    
    if(self.isSelectedExampleLabel) {
        attributedString = attributedString.attributedStringWithBulletPoint;
    }
    
    [self setSpeechAttributedStringToSelectedLabel:attributedString];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    if(!self.wordCell.speakerButton.selected) {
        return ;
    }
    
    NSString *speechString = utterance.speechString;
    [self setSpeechStringToSelectedLabel:speechString];
    self.speechingIndexPath = nil;
    
    if(self.wordCell.speakerButton.selected) {
        self.tableView.allowsSelection = YES;
    }
}

@end

////
////  SpeechSynthesizerManager.m
////  Podic
////
////  Created by Andrew Lee on 20/09/2017.
////  Copyright © 2017 Andrew Lee. All rights reserved.
////
//
//#import "AVSpeechSynthesizer+AVSpeechUtterance.h"
//#import "SpeechSynthesizerManager.h"
//
//@interface SpeechSynthesizerManager () <AVSpeechSynthesizerDelegate, UIGestureRecognizerDelegate>
//
//@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
//@property (nonatomic, strong) NSIndexPath *speechingIndexPath;
//
//@end
//
//@implementation SpeechSynthesizerManager
//
//SYNTHESIZE_SINGLETON_FOR_CLASS(SpeechSynthesizerManager, sharedInstance);
//
//- (instancetype)init {
//    if(self = [super init]) {
//        [self initializeSpeechSynthesizer];
//    }
//    return self;
//}
//
//- (void)initializeSpeechSynthesizer {
//    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
//    self.speechSynthesizer.delegate = self;
//}
//
//- (void)stopSpeechSynthesizerIfNeeded {
//    
//    if(self.speechSynthesizer.isSpeaking) {
//        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
//        self.speechingIndexPath = nil;
//        self.speechSynthesizer = nil;
//    }
//}
//
//#pragma mark - AVSpeechSynthesizerDelegate
//
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
//    
//    if(self.speechingIndexPath) {
//        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:utterance.speechString];
//        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
//        
//        NSMutableAttributedString *m = [[NSMutableAttributedString alloc] initWithString:@"•  "];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.headIndent = 15;
//        
//        [m appendAttributedString:mutableAttributedString];
//        [m addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, m.length)];
//        
//        ExampleCell *cell = [self.tableView cellForRowAtIndexPath:self.speechingIndexPath];
//        cell.exampleLabel.attributedText = m;
//    }
//    else {
//        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:utterance.speechString];
//        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
//        self.wordCell.wordLabel.attributedText = mutableAttributedString;
//    }
//}
//
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
//}
//
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
//    
//    if(!self.wordCell.speakerButton.selected) return ;
//    
//    if(self.speechingIndexPath) {
//        ExampleCell *cell = [self.tableView cellForRowAtIndexPath:self.speechingIndexPath];
//        [cell.exampleLabel setTextWithBulletPoint:utterance.speechString];
//    }
//    else {
//        [self.wordCell.wordLabel setText:utterance.speechString];
//    }
//    
//    self.speechingIndexPath = nil;
//    
//    if(self.wordCell.speakerButton.selected) {
//        [self.tableView setAllowsSelection:YES];
//    }
//}
//
//@end


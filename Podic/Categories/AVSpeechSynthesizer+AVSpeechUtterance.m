//
//  AVSpeechSynthesizer+AVSpeechUtterance.m
//  Podic
//
//  Created by Andrew Lee on 29/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import "AVSpeechSynthesizer+AVSpeechUtterance.h"

@implementation AVSpeechSynthesizer (AVSpeechUtterance)

- (void)speakWithString:(NSString *)string {
    if(string.length == 0) return ;
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = 0.4;
    utterance.preUtteranceDelay = 0.3f;
    utterance.postUtteranceDelay = 0.2f;
    [self speakUtterance:utterance];
}

@end

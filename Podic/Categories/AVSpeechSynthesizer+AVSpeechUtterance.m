//
//  AVSpeechSynthesizer+AVSpeechUtterance.m
//  Podic
//
//  Created by Andrew Lee on 29/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#define DEFAULT_LANGUAGE_CODE @"en-US"

#import "AVSpeechSynthesizer+AVSpeechUtterance.h"

@implementation AVSpeechSynthesizer (AVSpeechUtterance)

- (void)speakWithString:(NSString *)string {
    [self speakWithString:string languageCode:DEFAULT_LANGUAGE_CODE];
}

- (void)speakWithString:(NSString *)string languageCode:(NSString *)languageCode {
    
    if(string.length == 0) {
        return ;
    }
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:languageCode];
    utterance.rate = 0.4;
    utterance.preUtteranceDelay = 0.3f;
    utterance.postUtteranceDelay = 0.2f;
    [self speakUtterance:utterance];
}

@end

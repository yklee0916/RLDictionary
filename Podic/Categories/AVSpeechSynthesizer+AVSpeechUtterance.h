//
//  AVSpeechSynthesizer+AVSpeechUtterance.h
//  Podic
//
//  Created by Andrew Lee on 29/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@interface AVSpeechSynthesizer (AVSpeechUtterance)

- (void)speakWithString:(NSString *)string;
- (void)speakWithString:(NSString *)string languageCode:(NSString *)languageCode;

@end

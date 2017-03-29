//
//  AVSpeechSynthesizer+AVSpeechUtterance.h
//  Podic
//
//  Created by Rio on 29/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@interface AVSpeechSynthesizer (AVSpeechUtterance)

- (void)speakWithString:(NSString *)string;

@end

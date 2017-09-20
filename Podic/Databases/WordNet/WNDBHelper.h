//
//  WNDBHelper.h
//  Tmap5
//
//  Created by Andrew Lee on 24/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "WNWord.h"

@interface WNDBHelper : NSObject

+ (WNDBHelper *)sharedInstance;

- (WNWord *)wordWithString:(NSString *)string;

@end

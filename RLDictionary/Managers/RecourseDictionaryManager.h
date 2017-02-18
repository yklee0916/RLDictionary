//
//  RecourseDictionaryManager.h
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OxfordDictionariesResponse.h"

@interface RecourseDictionaryManager : NSObject

- (NSUInteger)count;
- (NSUInteger)exampleCountAtIndex:(NSUInteger)index;
- (Sense *)senseAtIndex:(NSUInteger)index;
- (void)requestRecourseDictionaryWithString:(NSString *)string completionHandler:(void (^)(OxfordDictionariesResponse *response, NSError *error))completionHandler;

@end

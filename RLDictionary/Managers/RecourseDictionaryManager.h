//
//  RecourseDictionaryManager.h
//  RLDictionary
//
//  Created by Rio on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecourseDictionaryManager : NSObject

- (void)requestRecourseDictionaryWithString:(NSString *)string completionHandler:(void (^)(NSString *resultJsonString, NSError *error))completionHandler;

@end

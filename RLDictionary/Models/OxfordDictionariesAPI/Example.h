//
//  Example.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Example
@end

@interface Example : JSONModel

@property (nonatomic, strong) NSString *text;

@end

//
//  GrammaticalFeature.h
//  RLDictionary
//
//  Created by Rio on 18/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GrammaticalFeature
@end

@interface GrammaticalFeature : JSONModel

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;

@end

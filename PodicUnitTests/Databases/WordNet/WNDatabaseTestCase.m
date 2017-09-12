//
//  WNDatabaseTestCase.m
//  Podic
//
//  Created by Andrew Lee on 26/03/2017.
//  Copyright © 2017 Andrew Lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WNDBHelper.h"

@interface WNDatabaseTestCase : XCTestCase

@property (nonatomic, strong) WNDBHelper *helper;

@end

@implementation WNDatabaseTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testWordApple {
    
    WNWord *word = [[WNDBHelper sharedInstance] wordWithString:@"apple"];
    XCTAssertNotNil(word.word);
    
    for(WNDefinition *definition in word.definitions) {
        XCTAssertNotNil(definition.definition);
    }
}

@end

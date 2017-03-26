//
//  WNDatabaseTestCase.m
//  Podic
//
//  Created by Rio on 26/03/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
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

- (void)testLoadDatabases {
    self.helper = [WNDBHelper sharedInstance];
    XCTAssertNotNil(self.helper);
}

- (void)testWordWithString {
    WNWord *word = [self.helper wordWithString:@"apple"];
    XCTAssertNotNil(word);
}

@end

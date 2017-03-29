//
//  AppDelegate.m
//  Podic
//
//  Created by Ryan Lee on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "WNDBHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // create instance to handle error
    [ErrorHandler sharedInstance];
    [WNDBHelper sharedInstance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end

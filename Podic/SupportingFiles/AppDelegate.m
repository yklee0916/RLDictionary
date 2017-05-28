//
//  AppDelegate.m
//  Podic
//
//  Created by Ryan Lee on 17/02/2017.
//  Copyright © 2017 Ryan Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "WNDBHelper.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import Firebase;

@import GoogleMobileAds;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    
    // create instance to handle error
    [ErrorHandler sharedInstance];
    [WNDBHelper sharedInstance];
    
    [FIRApp configure];
//    [GADMobileAds configureWithApplicationID:@"ca-app-pub-2336447731794699~9104742766"];
    
    
    
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

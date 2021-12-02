//
//  AppDelegate.m
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/22.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                               didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:@""]) {
        return [GIDSignIn.sharedInstance handleURL:url];
    }
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                                     openURL:url
                                                     options:options];
    return YES;
}


@end

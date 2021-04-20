//
//  AppDelegate.m
//  AdMobBidMachineSample
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "AppDelegate.h"
#import <AppNexusSDK/ANSDKSettings.h>

@import BidMachine;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    __weak typeof(self) weakSelf = self;
    [self startBidMachine:^{
        
    }];
    return YES;
}

/// Start BidMachine session, should be called before AdMob initialisation
- (void)startBidMachine:(void(^)(void))completion {
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:completion];
}

@end

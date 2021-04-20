//
//  Interstitial.m
//  BidMachineSample
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"

#import <AppNexusSDK/ANInterstitialAd.h>


#define PLACEMENT_ID    ""

@interface Interstitial ()<BDMRequestDelegate, ANInterstitialAdDelegate, ANAdDelegate>

@property (nonatomic, strong) ANInterstitialAd *interstitial;
@property (nonatomic, strong) BDMInterstitialRequest *request;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    self.request = [BDMInterstitialRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self.interstitial displayAdFromViewController:self];
}

- (void)loadAdWithParams:(NSDictionary *)params {
    self.interstitial = [[ANInterstitialAd alloc] initWithPlacementId:@PLACEMENT_ID];
    self.interstitial.delegate = self;
    [self.interstitial clearCustomKeywords];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class]) {
            [self.interstitial addCustomKeywordWithKey:key value:obj];
        }
    }];
    [self.interstitial loadAd];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self loadAdWithParams:info.customParams];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
}

- (void)requestDidExpire:(BDMRequest *)request {
    // In case request expired we can release it
    // and build some retry logic
}

#pragma mark - ANInterstitialAdDelegate

- (void)adDidReceiveAd:(nonnull id)ad {
    
}

- (void)ad:(nonnull id)ad requestFailedWithError:(nonnull NSError *)error {
    
}

@end

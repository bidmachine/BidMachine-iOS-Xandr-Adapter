//
//  BidMachineCustomInterstitial.m
//  BidMachineAdapter
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomInterstitial.h"

@import BidMachine;
@import StackFoundation;
@import BidMachine.ExternalAdapterUtils;


@interface BidMachineCustomInterstitial () <BDMInterstitialDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end


@implementation BidMachineCustomInterstitial

- (void)requestInterstitialAdWithParameter:(nullable NSString *)parameterString
                                  adUnitId:(nullable NSString *)idString
                       targetingParameters:(nullable ANTargetingParameters *)targetingParameters
{
    [self.requestController prepareRequestWithConfiguration:[BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
        builder.appendJsonConfiguration(targetingParameters.customKeywords);
    }]];
}

- (void)presentFromViewController:(nullable UIViewController *)viewController {
    if (self.interstitial.canShow) {
        [self.interstitial presentFromRootViewController:viewController];
    } else {
        [self.delegate failedToDisplayAd];
    }
}

- (BOOL)isReady {
    return [self.interstitial isLoaded];
}

#pragma mark - Lazy

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeInterstitial
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMInterstitialRequest *adRequest = (BDMInterstitialRequest *)request;
    [self.interstitial populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(BDMInterstitial *)interstitial {
    [self.delegate didLoadInterstitialAd:self];
}

- (void)interstitial:(BDMInterstitial *)interstitial failedWithError:(NSError *)error {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

- (void)interstitialWillPresent:(BDMInterstitial *)interstitial {
    [self.delegate willPresentAd];
}

- (void)interstitial:(BDMInterstitial *)interstitial failedToPresentWithError:(NSError *)error {
    [self.delegate failedToDisplayAd];
}

- (void)interstitialDidDismiss:(BDMInterstitial *)interstitial {
    [self.delegate didCloseAd];
}

- (void)interstitialRecieveUserInteraction:(BDMInterstitial *)interstitial {
    [self.delegate adWasClicked];
}

@end

//
//  BidMachineCustomEventBanner.m
//  BidMachineAdapter
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomBanner.h"

@import BidMachine;
@import StackFoundation;
@import BidMachine.ExternalAdapterUtils;


@interface BidMachineCustomBanner () <BDMBannerDelegate, BDMAdEventProducerDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end


@implementation BidMachineCustomBanner

- (void)requestBannerAdWithSize:(CGSize)size
             rootViewController:(nullable UIViewController *)rootViewController
                serverParameter:(nullable NSString *)parameterString
                       adUnitId:(nullable NSString *)idString
            targetingParameters:(nullable ANTargetingParameters *)targetingParameters
{
    self.bannerView.rootViewController = rootViewController;
    [self.requestController prepareRequestWithConfiguration:[BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
        builder.appendJsonConfiguration(targetingParameters.customKeywords);
        builder.appendAdSize(size);
    }]];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
        _bannerView.delegate = self;
        _bannerView.producerDelegate = self;
    }
    return _bannerView;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeBanner
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMBannerRequest *adRequest = (BDMBannerRequest *)request;
    [self.bannerView setFrame:(CGRect){.size = CGSizeFromBDMSize(adRequest.adSize)}];
    [self.bannerView populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(BDMBannerView *)bannerView {
    [self.delegate didLoadBannerAd:bannerView];
}

- (void)bannerView:(BDMBannerView *)bannerView failedWithError:(NSError *)error {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

- (void)bannerViewRecieveUserInteraction:(BDMBannerView *)bannerView {
    [self.delegate adWasClicked];
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    [self.delegate willLeaveApplication];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
   
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
    
}

#pragma mark - BDMAdEventProducerDelegate

// Currently noop
- (void)didProduceImpression:(id<BDMAdEventProducer>)producer {}
- (void)didProduceUserAction:(id<BDMAdEventProducer>)producer {}

@end

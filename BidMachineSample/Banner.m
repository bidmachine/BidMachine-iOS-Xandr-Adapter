//
//  Banner.m
//  BidMachineSample
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"
#import <AppNexusSDK/ANBannerAdView.h>


#define PLACEMENT_ID    ""


@interface Banner ()<BDMRequestDelegate, ANBannerAdViewDelegate>

@property (nonatomic, strong) BDMBannerRequest *request;
@property (nonatomic, strong) ANBannerAdView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    self.request = [BDMBannerRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self addBannerInContainer];
}

- (void)loadAdWithParams:(NSDictionary *)params {
    self.bannerView = [[ANBannerAdView alloc] initWithFrame:(CGRect){.size = CGSizeMake(320, 50)}
                                                placementId:@PLACEMENT_ID];
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    self.bannerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.bannerView clearCustomKeywords];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class]) {
            [self.bannerView addCustomKeywordWithKey:key value:obj];
        }
    }];
    [self.bannerView loadAd];
}

- (void)addBannerInContainer {
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.container addSubview:self.bannerView];
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

#pragma mark - ANBannerAdViewDelegate

- (void)adDidReceiveAd:(nonnull id)ad {
    
}

- (void)ad:(nonnull id)ad requestFailedWithError:(nonnull NSError *)error {
    
}

@end

//
//  BidMachineCustomInterstitial.h
//  BidMachineAdapter
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <AppNexusSDK/ANCustomAdapter.h>

@interface BidMachineCustomInterstitial : NSObject <ANCustomAdapterInterstitial>

@property (nonatomic, readwrite, weak, nullable) id<ANCustomAdapterInterstitialDelegate, ANCustomAdapterDelegate> delegate;

@end


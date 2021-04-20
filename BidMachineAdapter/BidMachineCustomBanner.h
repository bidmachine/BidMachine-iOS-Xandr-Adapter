//
//  BidMachineCustomBanner.h
//  BidMachineAdapter
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <AppNexusSDK/ANCustomAdapter.h>

@interface BidMachineCustomBanner : NSObject <ANCustomAdapterBanner>

@property (nonatomic, weak) id<ANCustomAdapterBannerDelegate, ANCustomAdapterDelegate> delegate;

@end


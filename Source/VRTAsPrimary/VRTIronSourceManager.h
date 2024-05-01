//
//  VRTIronSourceManager.h
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

#import <IronSource/IronSource.h>


//Used by IronSource Interstitial Adapter, Vrtcal as Primary
@interface VRTIronSourceManager : NSObject <ISDemandOnlyInterstitialDelegate>

+ (instancetype _Nonnull )singleton;

- (void)initIronSourceSDKWithAppKey:(NSString *_Nonnull)appKey forAdUnits:(NSSet *_Nonnull)adUnits;


//Demand-Only Interstitials
- (void)requestInterstitialAdWithDelegate:(id<ISDemandOnlyInterstitialDelegate>_Nonnull)delegate
                               instanceID:(NSString *_Nonnull)instanceID;

- (void)presentInterstitialAdFromViewController:(nonnull UIViewController *)viewController
                                     instanceID: (NSString *_Nonnull) instanceID;

@end

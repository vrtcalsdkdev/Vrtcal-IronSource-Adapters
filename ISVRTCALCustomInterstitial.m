//
//  ISVRTCALCustomInterstitial.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
#import <Foundation/Foundation.h>
#import "ISVRTCALCustomInterstitial.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>
#import "IronSource/ISAdData.h"
#import "IronSource/ISAdapterAdDelegate.h"
#import "IronSource/ISAdapterErrors.h"


//IronSource Interstitial Adapter, Vrtcal as Secondary
@interface ISVRTCALCustomInterstitial() <VRTInterstitialDelegate>
@property (weak) UIViewController *viewControllerForModalPresentation;
@property VRTInterstitial *vrtInterstitial;
@property BOOL vrtcalAdLoaded;
@property (weak) id<ISInterstitialAdDelegate> delegate;
@end


@implementation ISVRTCALCustomInterstitial

- (void)loadAdWithAdData:(nonnull ISAdData *)adData
                delegate:(nonnull id<ISInterstitialAdDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *strZoneId = adData.configuration[@"zoneid"];
    int zoneId = [strZoneId intValue];
    if (zoneId <= 0) {
        NSError *error = [VRTError errorWithCode:VRTErrorCodeInvalidParam format:@"Unusable zoneId of %i. Vrtcal ads require a Zone ID (unsigned int) to serve ads", zoneId];
        NSString *errorDescription = [error description];
        
        [self.delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal errorCode:ISAdapterErrorMissingParams errorMessage:errorDescription];
        return;
    }
    
    self.vrtInterstitial = [[VRTInterstitial alloc] init];
    self.vrtInterstitial.adDelegate = self;
    [self.vrtInterstitial loadAd:zoneId];
}

- (BOOL)isAdAvailableWithAdData:(nonnull ISAdData *)adData {
    return self.vrtcalAdLoaded;
}


- (void)showAdWithViewController:(nonnull UIViewController *)viewController adData:(nonnull ISAdData *)adData delegate:(nonnull id<ISAdapterAdDelegate>)delegate {
    self.viewControllerForModalPresentation = viewController;
    [self.vrtInterstitial showAd];
}

-(void) releaseMemory {
    self.vrtcalAdLoaded = NO;
    self.vrtInterstitial = nil;
}


#pragma mark - VRTInterstitialDelegate
- (void)vrtInterstitialAdClicked:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate adDidClick];
}

- (void)vrtInterstitialAdDidDismiss:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate adDidClose];
}

- (void)vrtInterstitialAdDidShow:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate adDidShowSucceed];
}

- (void)vrtInterstitialAdFailedToLoad:(nonnull VRTInterstitial *)vrtInterstitial error:(nonnull NSError *)error {
    [self.delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeNoFill errorCode:0 errorMessage:[error description]];
}

- (void)vrtInterstitialAdFailedToShow:(nonnull VRTInterstitial *)vrtInterstitial error:(nonnull NSError *)error {
    [self.delegate adDidFailToShowWithErrorCode:ISAdapterErrorInternal errorMessage:[error description]];
}

- (void)vrtInterstitialAdLoaded:(nonnull VRTInterstitial *)vrtInterstitial {
    self.vrtcalAdLoaded = YES;
    [self.delegate adDidLoad];
}

- (void)vrtInterstitialAdWillDismiss:(nonnull VRTInterstitial *)vrtInterstitial {
    //No ISAdapterAdDelegate analog to this
}

- (void)vrtInterstitialAdWillLeaveApplication:(nonnull VRTInterstitial *)vrtInterstitial {
    //No ISAdapterAdDelegate analog to this
}

- (void)vrtInterstitialAdWillShow:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate adDidOpen];
}

- (void)vrtInterstitialVideoCompleted:(nonnull VRTInterstitial *)vrtInterstitial {
    //No ISAdapterAdDelegate analog to this
}

- (void)vrtInterstitialVideoStarted:(nonnull VRTInterstitial *)vrtInterstitial {
    //No ISAdapterAdDelegate analog to this
}

- (nonnull UIViewController *)vrtViewControllerForModalPresentation {
    return self.viewControllerForModalPresentation;
}

@end

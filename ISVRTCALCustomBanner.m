//
//  ISVRTCALCustomBanner.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

@import Foundation;

//Header
#import "ISVRTCALCustomBanner.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>
#import "IronSource/ISAdData.h"
#import "IronSource/ISAdapterAdDelegate.h"
#import "IronSource/ISAdapterErrors.h"

//IronSource Banner Adapter, Vrtcal as Secondary
@interface ISVRTCALCustomBanner() <VRTBannerDelegate>
@property (weak) UIViewController *viewControllerForModalPresentation;
@property VRTBanner *vrtBanner;
@property BOOL vrtcalAdLoaded;
@property (weak) id<ISAdapterAdDelegate> delegate;
@end


//IronSource Banner Adapter, Vrtcal as Secondary
//This is a stub. IS Doesn't currently support mediation of their banners.
@implementation ISVRTCALCustomBanner

- (void)loadAdWithAdData:(nonnull ISAdData *)adData
                delegate:(nonnull id<ISAdapterAdDelegate>)delegate {
    
    self.delegate = delegate;
    
    int zoneId = (int)[adData getInt:@"zid"];
    if (zoneId <= 0) {
        NSError *error = [VRTError errorWithCode:VRTErrorCodeInvalidParam format:@"Unusable zoneId of %i. Vrtcal ads require a Zone ID (unsigned int) to serve ads", zoneId];
        NSString *errorDescription = [error description];
        
        [self.delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeInternal errorCode:ISAdapterErrorMissingParams errorMessage:errorDescription];
        return;
    }
    
    self.vrtBanner = [[VRTBanner alloc] init];
    self.vrtBanner.adDelegate = self;
    [self.vrtBanner loadAd:zoneId];
}

- (BOOL)isAdAvailableWithAdData:(nonnull ISAdData *)adData {
    return self.vrtcalAdLoaded;
}


- (void)showAdWithViewController:(nonnull UIViewController *)viewController adData:(nonnull ISAdData *)adData delegate:(nonnull id<ISAdapterAdDelegate>)delegate {
    self.viewControllerForModalPresentation = viewController;
}

-(void) releaseMemory {
    self.vrtcalAdLoaded = NO;
    self.vrtBanner = nil;
}


#pragma mark - VRTBannerDelegate
- (void)vrtBannerAdClicked:(nonnull VRTBanner *)vrtBanner {
    [self.delegate adDidClick];
}


- (void)vrtBannerAdFailedToLoad:(nonnull VRTBanner *)vrtBanner error:(nonnull NSError *)error {
    [self.delegate adDidFailToLoadWithErrorType:ISAdapterErrorTypeNoFill errorCode:0 errorMessage:[error description]];
}


- (void)vrtBannerAdLoaded:(nonnull VRTBanner *)vrtBanner withAdSize:(CGSize)adSize {
    [self.delegate adDidLoad];
}


- (void)vrtBannerAdWillLeaveApplication:(nonnull VRTBanner *)vrtBanner {
    //No ISAdapterAdDelegate analog to this
}


- (void)vrtBannerDidDismissModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    //[self.delegate adDidClose];
}


- (void)vrtBannerDidPresentModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    //[self.delegate adDidOpen];
}


- (void)vrtBannerVideoCompleted:(nonnull VRTBanner *)vrtBanner {
    //No ISAdapterAdDelegate analog to this
}


- (void)vrtBannerVideoStarted:(nonnull VRTBanner *)vrtBanner {
    //No ISAdapterAdDelegate analog to this
}


- (void)vrtBannerWillDismissModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    //No ISAdapterAdDelegate analog to this
}


- (void)vrtBannerWillPresentModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    //No ISAdapterAdDelegate analog to this
}

- (nonnull UIViewController *)vrtViewControllerForModalPresentation {
    return self.viewControllerForModalPresentation;
}



@end

//
//  VRTInterstitialCustomEventIronSource.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
#import "VRTInterstitialCustomEventIronSource.h"

//Dependencies
#import "VRTIronSourceManager.h"
#import <IronSource/IronSource.h>

//IronSource Interstitial Adapter, Vrtcal as Primary
@interface VRTInterstitialCustomEventIronSource() <ISInterstitialAdDelegate>
@property NSString *instanceId;
@end


@implementation VRTInterstitialCustomEventIronSource

- (void) loadInterstitialAd {
    
    @try {

        //Get and validate app ID
        NSString *appKey = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"appId"];
        if (![self stringIsGood:appKey]) {
            VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeInvalidParam format:@"IronSource appId of %@ unusable", appKey];
            [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
            return;
        }
        
        //Init IronSource if it hasn't been already
        [[VRTIronSourceManager singleton] initIronSourceSDKWithAppKey:appKey forAdUnits:[NSSet setWithObject:IS_INTERSTITIAL]];
        
        //Check if an interstitial is ready
        if ([IronSource hasInterstitial]) {
            [self.customEventLoadDelegate customEventLoaded];
            return;
        }
        
        //Request an interstitial
        [IronSource setInterstitialDelegate:self];
        [IronSource loadInterstitial];
    } @catch (NSException *exception) {
        
        NSString *description = [exception description];
        VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeUnknown format:@"Exception in loadInterstitialAd: %@", description];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
    }

}

- (void) showInterstitialAd {
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    [IronSource showInterstitialWithViewController:vc];
}



#pragma mark - ISInterstitialDelegate
- (void)didClickInterstitial {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventClicked];
}

- (void)interstitialDidClose {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error {
    VRTLogWhereAmI();
    [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
}

- (void)interstitialDidFailToShowWithError:(NSError *)error {
    //No VRT analog for this
    VRTLogWhereAmI();
}

- (void)interstitialDidLoad {
    VRTLogWhereAmI();
    [self.customEventLoadDelegate customEventLoaded];
}

- (void)interstitialDidOpen {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventWillPresentModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidShow {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeInterstitial];
}


#pragma mark - Utility
- (BOOL) stringIsGood:(NSString*)str {
    return str != nil && [str isKindOfClass:[NSString class]] && [str length] > 0;
}

@end

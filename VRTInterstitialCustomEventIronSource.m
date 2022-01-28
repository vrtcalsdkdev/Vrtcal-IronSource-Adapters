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

//IronSource Interstitial Adapter, Vrtcal as Primary
@interface VRTInterstitialCustomEventIronSource() <ISDemandOnlyInterstitialDelegate>
@property NSString *instanceId;
@end


@implementation VRTInterstitialCustomEventIronSource

- (void) loadInterstitialAd {
    
    @try {
        
        //Get and validate instance ID
        self.instanceId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"instanceId"];
        if (![self stringIsGood:self.instanceId]) {
            VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeInvalidParam format:@"IronSource instanceId of %@ unusable", self.instanceId];
            [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
            return;
        }
        
        //Get and validate app ID
        NSString *appKey = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"applicationKey"];
        if (![self stringIsGood:appKey]) {
            VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeInvalidParam format:@"IronSource appKey of %@ unusable", appKey];
            [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
            return;
        }
        
        //Init IronSource if it hasn't been already
        [[VRTIronSourceManager singleton] initIronSourceSDKWithAppKey:appKey forAdUnits:[NSSet setWithObject:IS_INTERSTITIAL]];
        
        //Request an interstitial
        [[VRTIronSourceManager singleton] requestInterstitialAdWithDelegate:self instanceID:self.instanceId];
        

    } @catch (NSException *exception) {
        
        NSString *description = [exception description];
        VRTError *vrtError = [VRTError errorWithCode:VRTErrorCodeUnknown format:@"Exception in loadInterstitialAd: %@", description];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:vrtError];
    }

}

- (void) showInterstitialAd {
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    [[VRTIronSourceManager singleton] presentInterstitialAdFromViewController:vc instanceID:self.instanceId];
}



#pragma mark - ISInterstitialDelegate
- (void)didClickInterstitial:(NSString *)instanceId {
    [self.customEventShowDelegate customEventClicked];
}

- (void)interstitialDidClose:(NSString *)instanceId {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
}

- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    //No VRT analog for this
}

- (void)interstitialDidLoad:(NSString *)instanceId {
    [self.customEventLoadDelegate customEventLoaded];
}

- (void)interstitialDidOpen:(NSString *)instanceId {
    [self.customEventShowDelegate customEventWillPresentModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidShow:(NSString *)instanceId {
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeInterstitial];
}


#pragma mark - Utility
- (BOOL) stringIsGood:(NSString*)str {
    return str != nil && [str isKindOfClass:[NSString class]] && [str length] > 0;
}

@end

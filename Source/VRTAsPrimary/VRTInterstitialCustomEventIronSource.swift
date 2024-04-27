
//
//  VRTInterstitialCustomEventIronSource.swift
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

import VrtcalSDK
import IronSource

//IronSource Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventIronSource: VRTAbstractInterstitialCustomEvent {
    static var ironSourceInitialized = false
    var levelPlayInterstitialDelegatePassthrough = LevelPlayInterstitialDelegatePassthrough()
    
    override func loadInterstitialAd() {

        guard !Self.ironSourceInitialized else {
            finishLoadingInterstitial()
            return
        }
        
        // Get and validate app ID
        guard let appKey = customEventConfig.thirdPartyAppId(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            customEventLoadDelegate?.customEventFailedToLoad(
                vrtError: VRTError(vrtErrorCode: .customEvent, message: "Could not get appKey")
            )
            return
        }
        
        // Set the mediation type
        let mediationName = "vrtcal"
        let isMediationVersion = "500"
        let vrtcalSdkVersion = VrtcalSDK.sdkVersion()
        let mediationType = "\(mediationName)\(isMediationVersion)SDK\(vrtcalSdkVersion)"
        IronSource.setMediationType(mediationType)

        // Not currently a version of this with a delegate. Perhaps Demand Only Mode doesn't require initialization?
        IronSource.initWithAppKey(
            appKey,
            adUnits: [IS_INTERSTITIAL],
            delegate: self
        )
        
        Self.ironSourceInitialized = true
    }

    override func showInterstitialAd() {
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            customEventShowDelegate?.customEventFailedToShow(vrtError: .customEventViewControllerNil)
            return
        }
        IronSource.showInterstitial(with: vc)
    }
    
    func finishLoadingInterstitial() {
        // Check if an interstitial is ready
        if IronSource.hasInterstitial() {
            customEventLoadDelegate?.customEventLoaded()
            return
        }

        // Request an interstitial
        levelPlayInterstitialDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        levelPlayInterstitialDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        IronSource.setLevelPlayInterstitialDelegate(levelPlayInterstitialDelegatePassthrough)
        IronSource.loadInterstitial()
    }
}

extension VRTInterstitialCustomEventIronSource: ISInitializationDelegate {
    func initializationDidComplete() {
        finishLoadingInterstitial()
    }
}



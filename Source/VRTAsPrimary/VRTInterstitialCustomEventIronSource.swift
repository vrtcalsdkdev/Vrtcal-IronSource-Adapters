
//
//  VRTInterstitialCustomEventIronSource.swift
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

import VrtcalSDK
import IronSource

//IronSource Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventIronSource: VRTAbstractInterstitialCustomEvent, ISInitializationDelegate {
    static var ironSourceInitialized = false
    var levelPlayInterstitialDelegatePassthrough = LevelPlayInterstitialDelegatePassthrough()
    
    override func loadInterstitialAd() {
        VRTLogInfo()
        
        // Bail if IS is already initialized
        guard !Self.ironSourceInitialized else {
            finishLoadingInterstitial()
            return
        }
        
        // Get and validate app ID
        guard let appKey = customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
            thirdPartyCustomEventKey: ThirdPartyCustomEventKey.appId,
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
        
        // Set the mediation type
        let mediationName = "vrtcal"
        let isMediationVersion = "500"
        let vrtcalSdkVersion = VrtcalSDK.sdkVersion()
        let mediationType = "\(mediationName)\(isMediationVersion)SDK\(vrtcalSdkVersion)"
        IronSource.setMediationType(mediationType)

        IronSource.initWithAppKey(
            appKey,
            adUnits: [IS_INTERSTITIAL],
            delegate: self
        )
        
        Self.ironSourceInitialized = true
    }

    override func showInterstitialAd() {
        VRTLogInfo()
        
        levelPlayInterstitialDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            customEventShowDelegate?.customEventFailedToShow(vrtError: .customEventViewControllerNil)
            return
        }
        IronSource.showInterstitial(with: vc)
    }
    
    func finishLoadingInterstitial() {
        VRTLogInfo()

        // Check if an interstitial is ready
        if IronSource.hasInterstitial() {
            VRTLogInfo("IronSource has interstitial, bailing")
            customEventLoadDelegate?.customEventLoaded()
            return
        }

        // Request an interstitial
        levelPlayInterstitialDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        levelPlayInterstitialDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        IronSource.setLevelPlayInterstitialDelegate(levelPlayInterstitialDelegatePassthrough)
        IronSource.loadInterstitial()
    }

    func initializationDidComplete() {
        VRTLogInfo()
        finishLoadingInterstitial()
    }
}



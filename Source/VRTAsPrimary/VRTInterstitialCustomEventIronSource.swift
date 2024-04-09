
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
    private var instanceId: String?
    var levelPlayInterstitialDelegatePassthrough = LevelPlayInterstitialDelegatePassthrough()
    
    override func loadInterstitialAd() {


        //Get and validate app ID
        guard let appKey = customEventConfig.thirdPartyAppId(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }

        //Init IronSource if it hasn't been already
        VRTIronSourceManager.singleton.initIronSourceSDK(
            withAppKey: appKey
        )

        //Check if an interstitial is ready
        if IronSource.hasInterstitial() {
            customEventLoadDelegate?.customEventLoaded()
            return
        }

        //Request an interstitial
        levelPlayInterstitialDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        levelPlayInterstitialDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        IronSource.setLevelPlayInterstitialDelegate(levelPlayInterstitialDelegatePassthrough)
        IronSource.loadInterstitial()

    }

    override func showInterstitialAd() {
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            customEventShowDelegate?.customEventFailedToShow(vrtError: .customEventViewControllerNil)
            return
        }
        IronSource.showInterstitial(with: vc)
    }
}

// MARK: - ISInterstitialDelegate
class LevelPlayInterstitialDelegatePassthrough: NSObject, LevelPlayInterstitialDelegate {

    weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    
    func didClick(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func didClose(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.interstitial)
    }

    func didFailToLoadWithError(_ error: (any Error)!) {
        VRTLogInfo()
        
        let vrtError = VRTError(
            vrtErrorCode: .customEvent,
            error: error
        )
        
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    func didFailToShowWithError(_ error: (any Error)!, andAdInfo adInfo: ISAdInfo!) {
        //No VRT analog for this
        VRTLogInfo()
    }

    func didLoad(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }

    func didOpen(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillPresentModal(.interstitial)
    }

    func didShow(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.interstitial)
    }
}

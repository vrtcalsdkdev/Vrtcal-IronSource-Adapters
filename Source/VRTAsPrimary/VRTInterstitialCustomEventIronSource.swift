
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
    var isInterstitialDelegatePassthrough = ISInterstitialDelegatePassthrough()
    
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
        isInterstitialDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        isInterstitialDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        IronSource.setInterstitialDelegate(isInterstitialDelegatePassthrough)
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
class ISInterstitialDelegatePassthrough: NSObject, ISInterstitialDelegate {

    weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    
    func didClickInterstitial() {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func interstitialDidClose() {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.interstitial)
    }

    func interstitialDidFailToLoadWithError(_ error: Error?) {
        VRTLogInfo()
        
        let vrtError = VRTError(
            vrtErrorCode: .customEvent,
            error: error
        )
        
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    func interstitialDidFailToShowWithError(_ error: Error?) {
        //No VRT analog for this
        VRTLogInfo()
    }

    func interstitialDidLoad() {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }

    func interstitialDidOpen() {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillPresentModal(.interstitial)
    }

    func interstitialDidShow() {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.interstitial)
    }
}

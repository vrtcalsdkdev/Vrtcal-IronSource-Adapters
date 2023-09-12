
//
//  VRTInterstitialCustomEventIronSource.swift
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
//IronSource Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventIronSource: VRTAbstractInterstitialCustomEvent, ISInterstitialDelegate {
    private var instanceId: String?

    func loadInterstitialAd() {

        // TODO: import SwiftTryCatch from https://github.com/ypopovych/SwiftTryCatch
        SwiftTryCatch.try({

            //Get and validate app ID
            let appKey = customEventConfig.thirdPartyCustomEventData["appId"] as? String
            if !stringIsGood(appKey) {
                let vrtError = VRTError(code: VRTErrorCodeInvalidParam, format: "IronSource appId of %@ unusable", appKey)
                customEventLoadDelegate.customEventFailedToLoadWithError(vrtError)
                return
            }

            //Init IronSource if it hasn't been already
            VRTIronSourceManager.singleton().initIronSourceSDK(withAppKey: appKey ?? "", forAdUnits: Set<AnyHashable>([IS_INTERSTITIAL]))

            //Check if an interstitial is ready
            if IronSource.hasInterstitial() {
                customEventLoadDelegate.customEventLoaded()
                return
            }

            //Request an interstitial
            IronSource.interstitialDelegate = self
            IronSource.loadInterstitial()
        }, catch: { exception in

            let description = exception.description()
            let vrtError = VRTError(code: VRTErrorCodeUnknown, format: "Exception in loadInterstitialAd: %@", description)
            customEventLoadDelegate.customEventFailedToLoadWithError(vrtError)
        }, finallyBlock: {
        })

    }

    func showInterstitialAd() {
        let vc = viewControllerDelegate.vrtViewControllerForModalPresentation()
        IronSource.showInterstitial(with: vc)
    }

    // MARK: - ISInterstitialDelegate

    func didClickInterstitial() {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventClicked()
    }

    func interstitialDidClose() {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeInterstitial)
    }

    func interstitialDidFailToLoadWithError(_ error: Error?) {
        VRTLogWhereAmI()
        customEventLoadDelegate.customEventFailedToLoadWithError(error)
    }

    func interstitialDidFailToShowWithError(_ error: Error?) {
        //No VRT analog for this
        VRTLogWhereAmI()
    }

    func interstitialDidLoad() {
        VRTLogWhereAmI()
        customEventLoadDelegate.customEventLoaded()
    }

    func interstitialDidOpen() {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventWillPresentModal(VRTModalTypeInterstitial)
    }

    func interstitialDidShow() {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidPresentModal(VRTModalTypeInterstitial)
    }

    // MARK: - Utility

    func stringIsGood(_ str: String?) -> Bool {
        return str != nil && (str is NSString) && (str?.count ?? 0) > 0
    }
}

//Dependencies

//IronSource Interstitial Adapter, Vrtcal as Primary

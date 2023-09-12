//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//
//  ISVRTCALCustomInterstitial.h
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Superclass
//
//  ISVRTCALCustomInterstitial.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
import Foundation
import IronSource
import VrtcalSDK

//IronSource Rewarded Video Adapter, Vrtcal as Secondary

class ISVRTCALCustomRewardedVideo: ISBaseRewardedVideo, VRTInterstitialDelegate {
    private weak var viewControllerForModalPresentation: UIViewController?
    private var vrtInterstitial: VRTInterstitial?
    private var vrtcalAdLoaded = false
    private weak var delegate: ISRewardedVideoAdDelegate?

    override func loadAd(
        with adData: ISAdData,
        delegate: ISRewardedVideoAdDelegate
    ) {

        self.delegate = delegate

        let strZoneId = adData.configuration["zoneid"] as? String
        let zoneId = Int(strZoneId ?? "") ?? 0
        if zoneId <= 0 {
            let error = VRTError(code: VRTErrorCodeInvalidParam, format: "Unusable zoneId of %i. Vrtcal ads require a Zone ID (unsigned int) to serve ads", zoneId) as? Error
            let errorDescription = error?.description()

            self.delegate.adDidFailToLoadWithErrorType(ISAdapterErrorTypeInternal, errorCode: ISAdapterErrorMissingParams, errorMessage: errorDescription)
            return
        }

        vrtInterstitial = VRTInterstitial()
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }

    func isAdAvailable(with adData: ISAdData) -> Bool {
        return vrtcalAdLoaded
    }

    func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISAdapterAdDelegate) {
        viewControllerForModalPresentation = viewController
        vrtInterstitial?.showAd()
    }

    func releaseMemory() {
        vrtcalAdLoaded = false
        vrtInterstitial = nil
    }

    // MARK: - VRTInterstitialDelegate

    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        delegate?.adDidClick()
    }

    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        delegate?.adDidClose()
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        delegate?.adDidShowSucceed()
        delegate?.adDidOpen()
    }

    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        delegate?.adDidFailToLoadWithErrorType(ISAdapterErrorTypeNoFill, errorCode: 0, errorMessage: error.description())
    }

    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        delegate?.adDidFailToShowWithErrorCode(ISAdapterErrorInternal, errorMessage: error.description())
    }

    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        vrtcalAdLoaded = true
        delegate?.adDidLoad()
    }

    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        delegate?.adDidEnd()
        delegate?.adRewarded()
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        delegate?.adDidStart()
    }

    func vrtViewControllerForModalPresentation() -> UIViewController {
        return viewControllerForModalPresentation!
    }
}

//Dependencies


//IronSource Rewarded Video Adapter, Vrtcal as Secondary

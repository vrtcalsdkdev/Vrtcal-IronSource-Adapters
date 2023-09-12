//  ISVRTCALCustomInterstitial.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
import Foundation
import IronSource
import VrtcalSDK

// IronSource Interstitial Adapter, Vrtcal as Secondary
class ISVRTCALCustomInterstitial: ISBaseInterstitial, VRTInterstitialDelegate {
    private weak var viewControllerForModalPresentation: UIViewController?
    private var vrtInterstitial: VRTInterstitial?
    private var vrtcalAdLoaded = false
    private weak var delegate: ISInterstitialAdDelegate?

    override func loadAd(
        with adData: ISAdData,
        delegate: ISInterstitialAdDelegate
    ) {

        self.delegate = delegate

        let strZoneId = adData.configuration["zoneid"] as? String
        let zoneId = Int(strZoneId ?? "") ?? 0
        if zoneId <= 0 {
            let error = VRTError(
                vrtErrorCode: .invalidParam,
                message: "Unusable zoneId of \(zoneId). Vrtcal ads require a Zone ID (unsigned int) to serve ads"
            )
            let errorDescription = error.description()

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
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        delegate?.adDidStart()
    }

    func vrtViewControllerForModalPresentation() -> UIViewController {
        return viewControllerForModalPresentation!
    }
}


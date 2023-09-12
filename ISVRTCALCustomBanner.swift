//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//
//  ISVRTCALCustomBanner.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Superclass
//
//  ISVRTCALCustomBanner.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

import Foundation
import IronSource
import VrtcalSDK

//IronSource Banner Adapter, Vrtcal as Secondary
//This is a stub. IS Doesn't currently support mediation of their banners.

class ISVRTCALCustomBanner: ISBaseAdAdapter {
    private weak var viewControllerForModalPresentation: UIViewController?
    private var vrtBanner: VRTBanner?
    private var vrtcalAdLoaded = false
    private weak var delegate: ISAdapterAdDelegate?
    
    override func loadAd(
        with adData: ISAdData,
        delegate: ISAdapterAdDelegate
    ) {
        
        self.delegate = delegate
        
        let zoneId = Int(adData.getInt("zid"))
        if zoneId <= 0 {
            
            let errorMessage = VRTError(
                vrtErrorCode: .customEvent,
                message: "Unusable zoneId of \(zoneId). Vrtcal ads require a Zone ID (unsigned int) to serve ads"
            ).description
            
            
            self.delegate.adDidFailToLoadWithErrorType(ISAdapterErrorTypeInternal, errorCode: ISAdapterErrorMissingParams, errorMessage: errorMessage)
            return
        }
        
        vrtBanner = VRTBanner()
        vrtBanner?.adDelegate = self
        vrtBanner?.loadAd(zoneId)
    }
    
    func isAdAvailable(with adData: ISAdData) -> Bool {
        return vrtcalAdLoaded
    }
    
    func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISAdapterAdDelegate) {
        viewControllerForModalPresentation = viewController
    }
    
    override func releaseMemory() {
        vrtcalAdLoaded = false
        vrtBanner = nil
    }
}

extension ISVRTCALCustomBanner : VRTBannerDelegate {

    func vrtBannerAdClicked(_ vrtBanner: VRTBanner) {
        delegate?.adDidClick()
    }

    func vrtBannerAdFailed(toLoad vrtBanner: VRTBanner, error: Error) {
        delegate?.adDidFailToLoadWithErrorType(ISAdapterErrorTypeNoFill, errorCode: 0, errorMessage: error.description())
    }

    func vrtBannerAdLoaded(_ vrtBanner: VRTBanner, withAdSize adSize: CGSize) {
        delegate?.adDidLoad()
    }

    func vrtBannerAdWillLeaveApplication(_ vrtBanner: VRTBanner) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtBannerDidDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        //[self.delegate adDidClose];
    }

    func vrtBannerDidPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        //[self.delegate adDidOpen];
    }

    func vrtBannerVideoCompleted(_ vrtBanner: VRTBanner) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtBannerVideoStarted(_ vrtBanner: VRTBanner) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtBannerWillDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtBannerWillPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        //No ISAdapterAdDelegate analog to this
    }

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        return viewControllerForModalPresentation!
    }
}

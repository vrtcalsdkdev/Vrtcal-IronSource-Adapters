//
//  InterstitialManager.swift
//  Vrtcal-IronSource-Adapters
//
//  Created by Scott McCoy on 4/22/24.
//

import VrtcalSDK
import IronSource

enum InterstitialManagerStatus {
    case empty
    case loading
    case loaded
}

class ISVRTCALInterstitialManager {
    static var singletonInterstitial = ISVRTCALInterstitialManager(name: "Interstitial")
    static var singletonRewardedVideo = ISVRTCALInterstitialManager(name: "Rewarded Video")
    
    // Interface
    var name: String
    var status = InterstitialManagerStatus.empty
    
    // IronSource
    // Note: This has to be a strong reference
    private var isInterstitialAdDelegate: ISInterstitialAdDelegate?
    
    // Vrtcal
    private weak var viewControllerForModalPresentation: UIViewController?
    private var vrtInterstitial: VRTInterstitial?
    
    // MARK: Interface
    init(name: String) {
        self.name = name
    }
    
    
    func loadAd(
        isAdData: ISAdData,
        isInterstitialAdDelegate: ISInterstitialAdDelegate
    ) {
        VRTLogInfo("name: \(name), status: \(status)")
  
        self.isInterstitialAdDelegate = isInterstitialAdDelegate
        
        switch status {
        case .empty:
            VRTLogInfo("Loading ad...")
            break
            
        case .loading:
            VRTLogInfo("Already Loading ad...")
            return
            
        case .loaded:
            VRTLogInfo("Already loaded")
            isInterstitialAdDelegate.adDidLoad()
            return
        }
        
        self.isInterstitialAdDelegate = isInterstitialAdDelegate
        status = .loading
        
        // Extract ZoneID from adData
        guard let strZoneId = isAdData.configuration["zoneid"] as? String,
        let zoneId = Int(strZoneId),
        zoneId > 0 else {
            let vrtError = VRTError(
                vrtErrorCode: .invalidParam,
                message: "Unusable zoneid field in adData.configuration: \(isAdData.configuration). Vrtcal ads require a Zone ID (unsigned int) to serve ads"
            )

            isInterstitialAdDelegate.adDidFailToLoadWith(
                .internal,
                errorCode: ISAdapterErrors.missingParams.rawValue,
                errorMessage: "\(vrtError)"
            )
            return
        }
        
        // Make a new VRTInterstitial
        vrtInterstitial = VRTInterstitial()
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }
    
    var isAdAvailable: Bool {
        VRTLogInfo("name: \(name), status: \(status)")
        return status == .loaded
    }
    
    func showAd(
        uiViewController: UIViewController,
        isInterstitialAdDelegate: ISInterstitialAdDelegate
    ) {
        VRTLogInfo("name: \(name), status: \(status)")
        self.isInterstitialAdDelegate = isInterstitialAdDelegate
        viewControllerForModalPresentation = uiViewController
        vrtInterstitial?.showAd()
    }
    
    func releaseMemory() {
        VRTLogInfo()
        isInterstitialAdDelegate = nil
    }
}


// MARK: - VRTInterstitialDelegate
extension ISVRTCALInterstitialManager: VRTInterstitialDelegate {

    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isInterstitialAdDelegate?.adDidClick()
    }

    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isInterstitialAdDelegate?.adDidClose()
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isInterstitialAdDelegate?.adDidShowSucceed()
        isInterstitialAdDelegate?.adDidOpen()
    }

    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo("error: \(error)")
        isInterstitialAdDelegate?.adDidFailToLoadWith(
            .noFill,
            errorCode: 0,
            errorMessage: "\(error)"
        )
    }

    func vrtInterstitialAdFailed(
        toShow vrtInterstitial: VRTInterstitial,
        error: Error
    ) {
        VRTLogInfo()
        status = .empty
        isInterstitialAdDelegate?.adDidFailToShowWithErrorCode(
            ISAdapterErrors.internal.rawValue,
            errorMessage: "\(error)"
        )
    }

    func vrtInterstitialAdLoaded(
        _ vrtInterstitial: VRTInterstitial
    ) {
        VRTLogInfo()
        status = .loaded
        isInterstitialAdDelegate?.adDidLoad()
    }

    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISAdapterAdDelegate analog to this
    }

    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISAdapterAdDelegate analog to this
    }

    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISAdapterAdDelegate analog to this
    }

    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isInterstitialAdDelegate?.adDidEnd()
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isInterstitialAdDelegate?.adDidStart()
    }

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        VRTLogInfo()
        return viewControllerForModalPresentation!
    }
}

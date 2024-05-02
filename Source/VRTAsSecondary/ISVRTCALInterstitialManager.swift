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
    case showing
}

class ISVRTCALInterstitialManager {
    static var singletonInterstitial = ISVRTCALInterstitialManager(name: "Interstitial")
    static var singletonRewardedVideo = ISVRTCALInterstitialManager(name: "Rewarded Video")
    
    // Interface
    var name: String
    var status = InterstitialManagerStatus.empty
    
    // IronSource
    private weak var isInterstitialAdDelegate: ISInterstitialAdDelegate?
    private weak var isRewardedVideoAdDelegate: ISRewardedVideoAdDelegate?
    
    // Vrtcal
    private weak var viewControllerForModalPresentation: UIViewController?
    private var vrtInterstitial: VRTInterstitial?
    
    // MARK: Interface
    init(name: String) {
        self.name = name
    }
    
    
    func loadAd(
        isAdData: ISAdData,
        isInterstitialAdDelegate: ISInterstitialAdDelegate?,
        isRewardedVideoAdDelegate: ISRewardedVideoAdDelegate?
    ) {
        VRTLogInfo("🎉🎉🎉🎉 name: \(name), status: \(status)")
        
        self.isInterstitialAdDelegate = isInterstitialAdDelegate
        self.isRewardedVideoAdDelegate = isRewardedVideoAdDelegate
        
        switch status {
        case .empty:
            VRTLogInfo("Loading ad...")
            break
            
        case .loading:
            VRTLogInfo("Already showing ad. Bailing.")
            return
            
        case .showing:
            VRTLogInfo("Already showing ad. Bailing.")
            return
            
        case .loaded:
            VRTLogInfo("Already loaded. Calling adDidLoad.")
            isInterstitialAdDelegate?.adDidLoad()
            isRewardedVideoAdDelegate?.adDidLoad()
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

            isInterstitialAdDelegate?.adDidFailToLoadWith(
                .internal,
                errorCode: ISAdapterErrors.missingParams.rawValue,
                errorMessage: "\(vrtError)"
            )
            
            isRewardedVideoAdDelegate?.adDidFailToLoadWith(
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
        isInterstitialAdDelegate: ISInterstitialAdDelegate?,
        isRewardedVideoAdDelegate: ISRewardedVideoAdDelegate?
    ) {
        VRTLogInfo("name: \(name), status: \(status)")
        
        status = .showing
        
        self.isInterstitialAdDelegate = isInterstitialAdDelegate
        self.isRewardedVideoAdDelegate = isRewardedVideoAdDelegate
        viewControllerForModalPresentation = uiViewController
        
        vrtInterstitial?.showAd()
    }
    
    func releaseMemory() {
        VRTLogInfo()
    }
}


// MARK: - VRTInterstitialDelegate
extension ISVRTCALInterstitialManager: VRTInterstitialDelegate {

    func vrtInterstitialAdLoaded(
        _ vrtInterstitial: VRTInterstitial
    ) {
        VRTLogInfo("🎉🎉🎉🎉")
        status = .loaded

        isInterstitialAdDelegate?.adDidLoad()
        isRewardedVideoAdDelegate?.adDidLoad()
    }
    
    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo("error: \(error)")
        
        isInterstitialAdDelegate?.adDidFailToLoadWith(
            .noFill,
            errorCode: 0,
            errorMessage: "\(error)"
        )
        
        isRewardedVideoAdDelegate?.adDidFailToLoadWith(
            .noFill,
            errorCode: 0,
            errorMessage: "\(error)"
        )
    }
    
    

    

    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISInterstitialAdDelegate analog
        // No ISRewardedVideoAdDelegate analog
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()

        isInterstitialAdDelegate?.adDidOpen()
        isRewardedVideoAdDelegate?.adDidOpen()
        
        isInterstitialAdDelegate?.adDidShowSucceed()
        isRewardedVideoAdDelegate?.adDidShowSucceed()
    }



    func vrtInterstitialAdFailed(
        toShow vrtInterstitial: VRTInterstitial,
        error: Error
    ) {
        VRTLogInfo("error: \(error)")
        status = .empty
        
        isInterstitialAdDelegate?.adDidFailToShowWithErrorCode(
            ISAdapterErrors.internal.rawValue,
            errorMessage: "\(error)"
        )
        
        isRewardedVideoAdDelegate?.adDidFailToShowWithErrorCode(
            ISAdapterErrors.internal.rawValue,
            errorMessage: "\(error)"
        )
    }


    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isInterstitialAdDelegate?.adDidClick()
        isRewardedVideoAdDelegate?.adDidClick()
    }
    
    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISInterstitialAdDelegate analog
        // No ISRewardedVideoAdDelegate analog
    }
    

    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISInterstitialAdDelegate analog
        // No ISRewardedVideoAdDelegate analog
    }
    
    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()

        isInterstitialAdDelegate?.adDidClose()
        isRewardedVideoAdDelegate?.adDidClose()
        
        status = .empty
        self.vrtInterstitial = nil
    }
    
    
    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No ISInterstitialAdDelegate analog
        isRewardedVideoAdDelegate?.adDidStart()
    }

    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        
        // No ISInterstitialAdDelegate analog
        isRewardedVideoAdDelegate?.adDidEnd()
        
        // Reward User
        isRewardedVideoAdDelegate?.adRewarded()
    }



    func vrtViewControllerForModalPresentation() -> UIViewController? {
        VRTLogInfo()
        return viewControllerForModalPresentation!
    }
}

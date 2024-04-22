
import Foundation
import IronSource
import VrtcalSDK

// IronSource Rewarded Video Adapter, Vrtcal as Secondary
@objc(ISVRTCALCustomRewardedVideo)
final class ISVRTCALCustomRewardedVideo: ISBaseRewardedVideo {
    
    private var isRewardedVideoAdDelegate: ISRewardedVideoAdDelegate?
    
    private weak var viewControllerForModalPresentation: UIViewController?
    private var vrtInterstitial: VRTInterstitial?
    private var vrtcalAdLoaded = false
    
    override init() {
        VRTLogInfo()
        super.init()
    }
    
    override init(_ providerConfig: ISAdapterConfig) {
        VRTLogInfo()
        super.init(providerConfig)
    }
    
    override init(adUnit: ISAdUnit, adapterConfig: ISAdapterConfig) {
        VRTLogInfo()
        super.init(adUnit: adUnit, adapterConfig: adapterConfig)
    }
    
    override init(adUnit: ISAdUnit, adapterConfig: ISAdapterConfig, adUnitObjectId: UUID?) {
        VRTLogInfo()
        super.init(adUnit: adUnit, adapterConfig: adapterConfig, adUnitObjectId: adUnitObjectId)
    }
    
    override func loadAd(
        with adData: ISAdData,
        delegate: ISRewardedVideoAdDelegate
    ) {
        VRTLogInfo()
        self.isRewardedVideoAdDelegate = delegate
        
        guard let strZoneId = adData.configuration["zoneid"] as? String,
              let zoneId = Int(strZoneId),
              zoneId > 0 else {
            let vrtError = VRTError(
                vrtErrorCode: .invalidParam,
                message: "Unusable zoneid field in adData.configuration: \(adData.configuration). Vrtcal ads require a Zone ID (unsigned int) to serve ads"
            )
            
            self.isRewardedVideoAdDelegate?.adDidFailToLoadWith(
                .internal,
                errorCode: ISAdapterErrors.missingParams.rawValue,
                errorMessage: "\(vrtError)"
            )
            return
        }
        
        vrtInterstitial = VRTInterstitial()
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }
    
    override func isAdAvailable(with adData: ISAdData) -> Bool {
        return vrtcalAdLoaded
    }
    
    func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISAdapterAdDelegate) {
        viewControllerForModalPresentation = viewController
        vrtInterstitial?.showAd()
    }
    
    override func releaseMemory() {
        vrtcalAdLoaded = false
        
        vrtInterstitial?.adDelegate = nil
        vrtInterstitial = nil
        isRewardedVideoAdDelegate = nil
    }
}

// MARK: - VRTInterstitialDelegate
extension ISVRTCALCustomRewardedVideo: VRTInterstitialDelegate {

    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isRewardedVideoAdDelegate?.adDidClick()
    }

    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isRewardedVideoAdDelegate?.adDidClose()
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isRewardedVideoAdDelegate?.adDidShowSucceed()
        isRewardedVideoAdDelegate?.adDidOpen()
    }

    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo("error: \(error)")
        isRewardedVideoAdDelegate?.adDidFailToLoadWith(
            .noFill,
            errorCode: 0,
            errorMessage: "\(error)"
        )
    }

    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        VRTLogInfo()
        isRewardedVideoAdDelegate?.adDidFailToShowWithErrorCode(
            ISAdapterErrors.internal.rawValue,
            errorMessage: "\(error)"
        )
    }

    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        vrtcalAdLoaded = true
        isRewardedVideoAdDelegate?.adDidLoad()
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
        isRewardedVideoAdDelegate?.adDidEnd()
        isRewardedVideoAdDelegate?.adRewarded()
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        isRewardedVideoAdDelegate?.adDidStart()
    }

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        VRTLogInfo()
        return viewControllerForModalPresentation
    }
}

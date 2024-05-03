import Foundation
import IronSource
import VrtcalSDK

// IronSource Rewarded Video Adapter, Vrtcal as Secondary
@objc(ISVRTCALCustomRewardedVideo)
final class ISVRTCALCustomRewardedVideo: ISBaseRewardedVideo {
    
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
    
    public override func loadAd(
        with adData: ISAdData,
        delegate: ISRewardedVideoAdDelegate
    ) {
        VRTLogInfo()
        
        ISVRTCALInterstitialManager.singletonRewardedVideo.loadAd(
            isAdData: adData,
            isInterstitialAdDelegate: nil,
            isRewardedVideoAdDelegate: delegate
        )
    }
    
    public override func isAdAvailable(
        with adData: ISAdData
    ) -> Bool {
        VRTLogInfo()
        return ISVRTCALInterstitialManager.singletonRewardedVideo.isAdAvailable
    }
    
    public override func showAd(
        with viewController: UIViewController,
        adData: ISAdData,
        delegate: any ISRewardedVideoAdDelegate
    ) {
        VRTLogInfo()
        ISVRTCALInterstitialManager.singletonRewardedVideo.showAd(
            uiViewController: viewController,
            isInterstitialAdDelegate: nil,
            isRewardedVideoAdDelegate: delegate
        )
    }
    
    public override func releaseMemory() {
        ISVRTCALInterstitialManager.singletonRewardedVideo.releaseMemory()
    }
}

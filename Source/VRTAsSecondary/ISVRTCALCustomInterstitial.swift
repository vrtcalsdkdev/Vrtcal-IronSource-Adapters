import Foundation
import IronSource
import VrtcalSDK

// IronSource Interstitial Adapter, Vrtcal as Secondary
@objc(ISVRTCALCustomInterstitial)
final class ISVRTCALCustomInterstitial: ISBaseInterstitial {
    
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
        delegate: ISInterstitialAdDelegate
    ) {
        VRTLogInfo()

        ISVRTCALInterstitialManager.singletonInterstitial.loadAd(
            isAdData: adData,
            isInterstitialAdDelegate: delegate,
            isRewardedVideoAdDelegate: nil
        )
    }

    public override func isAdAvailable(
        with adData: ISAdData
    ) -> Bool {
        VRTLogInfo()
        return ISVRTCALInterstitialManager.singletonInterstitial.isAdAvailable
    }

    public override func showAd(
        with viewController: UIViewController,
        adData: ISAdData,
        delegate: ISInterstitialAdDelegate
    ) {
        VRTLogInfo()
        ISVRTCALInterstitialManager.singletonInterstitial.showAd(
            uiViewController: viewController,
            isInterstitialAdDelegate: delegate,
            isRewardedVideoAdDelegate: nil
        )
    }

    override func releaseMemory() {
        VRTLogInfo()
        ISVRTCALInterstitialManager.singletonInterstitial.releaseMemory()
    }
    
    deinit {
        VRTLogInfo()
    }
}




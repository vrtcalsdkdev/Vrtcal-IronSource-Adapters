
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

        guard let strZoneId = adData.configuration["zoneid"] as? String,
        let zoneId = Int(strZoneId),
        zoneId > 0 else {
            let vrtError = VRTError(
                vrtErrorCode: .invalidParam,
                message: "Unusable zoneid field in adData.configuration: \(adData.configuration). Vrtcal ads require a Zone ID (unsigned int) to serve ads"
            )

            self.delegate?.adDidFailToLoadWith(
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
        delegate?.adDidFailToLoadWith(
            .noFill,
            errorCode: 0,
            errorMessage: "\(error)"
        )
    }

    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        delegate?.adDidFailToShowWithErrorCode(
            ISAdapterErrors.internal.rawValue,
            errorMessage: "\(error)"
        )
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

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        return viewControllerForModalPresentation
    }
}

//Dependencies


//IronSource Rewarded Video Adapter, Vrtcal as Secondary

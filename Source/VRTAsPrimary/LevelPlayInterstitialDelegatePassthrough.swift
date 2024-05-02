//
//  LevelPlay.swift
//  Vrtcal-IronSource-Adapters
//
//  Created by Scott McCoy on 4/26/24.
//

import VrtcalSDK
import IronSource

class LevelPlayInterstitialDelegatePassthrough: NSObject {
    weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
}

extension LevelPlayInterstitialDelegatePassthrough: LevelPlayInterstitialDelegate {

    func didLoad(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }
    
    func didFailToLoadWithError(_ error: (any Error)!) {
        VRTLogInfo("error: \(error!)")
        
        let vrtError = VRTError(
            vrtErrorCode: .customEvent,
            error: error
        )
        
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }
    
    func didOpen(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillPresentModal(.interstitial)
    }

    func didShow(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.interstitial)
    }
    
    func didFailToShowWithError(_ error: (any Error)!, andAdInfo adInfo: ISAdInfo!) {
        //No VRT analog for this
        VRTLogInfo()
    }
    
    func didClick(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func didClose(with adInfo: ISAdInfo!) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.interstitial)
    }
}

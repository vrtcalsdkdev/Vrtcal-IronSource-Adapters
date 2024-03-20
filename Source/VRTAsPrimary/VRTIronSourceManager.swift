//  VRTIronSourceManager.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//


import IronSource
import VrtcalSDK

// Used by IronSource Interstitial Adapter, Vrtcal as Primary
// Note that Ironsource doesn't currently allow mediation of their banners
class VRTIronSourceManager {

    static let singleton = VRTIronSourceManager()
    var isDemandOnlyInterstitialDelegatePassthrough = ISDemandOnlyInterstitialDelegatePassthrough()
    
    init() {
        let mediationName = "vrtcal"
        let isMediationVersion = "500"
        let vrtcalSdkVersion = VrtcalSDK.sdkVersion()
        let mediationType = "\(mediationName)\(isMediationVersion)SDK\(vrtcalSdkVersion)"
        
        IronSource.setMediationType(mediationType)
    }
    
    // MARK: - API
    
    func initIronSourceSDK(
        withAppKey appKey: String
    ) {
        IronSource.setISDemandOnlyInterstitialDelegate(isDemandOnlyInterstitialDelegatePassthrough)
        IronSource.initISDemandOnly(appKey, adUnits: Array([IS_INTERSTITIAL]))
    }
    
    //Demand-Only Interstitials
    func requestInterstitialAd(
        with delegate: ISDemandOnlyInterstitialDelegate,
        instanceID: String
    ) {

        let isDemandOnlyInterstitialDelegateWeakRef = ISDemandOnlyInterstitialDelegateWeakRef(
            isDemandOnlyInterstitialDelegate: delegate
        )

        isDemandOnlyInterstitialDelegatePassthrough.delegates[instanceID] = isDemandOnlyInterstitialDelegateWeakRef
        
        IronSource.loadISDemandOnlyInterstitial(instanceID)
    }
    
    func presentInterstitialAd(
        from viewController: UIViewController,
        instanceID: String
    ) {
        IronSource.showISDemandOnlyInterstitial(viewController, instanceId: instanceID)
    }
}

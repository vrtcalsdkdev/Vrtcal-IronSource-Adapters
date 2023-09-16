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



/*
    // MARK: - Delegate Pass-Through





    // MARK: ISDemandOnlyInterstitialDelegate


    //#pragma Map Utils methods


    func add(_ adapterDelegate: ISDemandOnlyInterstitialDelegate?, forInstanceID instanceID: String?) {

        objc_sync_enter(interstitialAdapterDelegates)
        interstitialAdapterDelegates?.set(adapterDelegate, forKey: instanceID ?? "")
        objc_sync_exit(interstitialAdapterDelegates)
    }

    func getInterstitialDelegate(forInstanceID instanceID: String?) -> ISDemandOnlyInterstitialDelegate? {
        var delegate: ISDemandOnlyInterstitialDelegate?
        objc_sync_enter(interstitialAdapterDelegates)
        delegate = interstitialAdapterDelegates?[instanceID ?? ""] as? ISDemandOnlyInterstitialDelegate
        objc_sync_exit(interstitialAdapterDelegates)
        return delegate
    }

    func removeInterstitialDelegate(forInstanceID InstanceID: String?) {
        objc_sync_enter(interstitialAdapterDelegates)
        interstitialAdapterDelegates?.removeObject(forKey: InstanceID)
        objc_sync_exit(interstitialAdapterDelegates)
    }
}
*/

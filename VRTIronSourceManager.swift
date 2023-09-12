//  VRTIronSourceManager.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
import IronSource

//Used by IronSource Interstitial Adapter, Vrtcal as Primary

class VRTIronSourceManager: NSObject, ISDemandOnlyInterstitialDelegate {
    private var interstitialAdapterDelegates: [String: ISDemandOnlyInterstitialDelegate]

    static let singleton = VRTIronSourceManager()


    override init() {
        super.init()
        //Init the map table such that it will not retain adapters referenced by it
        interstitialAdapterDelegates = NSMapTable(keyOptions: .strongMemory, valueOptions: .weakMemory)

        let mediationName = "vrtcal"
        let isMediationVersion = "500"
        let vrtcalSdkVersion = VrtcalSDK.sdkVersion()
        let mediationType = "\(mediationName)\(isMediationVersion)SDK\(vrtcalSdkVersion)"

        IronSource.mediationType = mediationType
    }

    // MARK: - API

    func initIronSourceSDK(withAppKey appKey: String, forAdUnits adUnits: Set<AnyHashable>) {
        if adUnits.member(IS_INTERSTITIAL) != nil {

            #warning("[Swiftify] failed to move the `dispatch_once()` block below to a static variable initializer")
            {
                IronSource.isDemandOnlyInterstitialDelegate = self
            }
        }

        IronSource.initISDemandOnly(appKey, adUnits: Array(adUnits))
    }

    //Demand-Only Interstitials
    func requestInterstitialAd(with delegate: ISDemandOnlyInterstitialDelegate, instanceID: String) {

        if delegate == nil {
            VRTLogError("Delegate is nil")
            return
        }

        add(delegate, forInstanceID: instanceID)
        IronSource.loadISDemandOnlyInterstitial(instanceID)
    }

    func presentInterstitialAd(from viewController: UIViewController, instanceID: String) {
        IronSource.showISDemandOnlyInterstitial(viewController, instanceId: instanceID)
    }

    // MARK: - Delegate Pass-Through





    // MARK: ISDemandOnlyInterstitialDelegate

    func interstitialDidLoad(_ instanceId: String?) {

        let delegate = getInterstitialDelegate(forInstanceID: instanceId)

        if let delegate {
            delegate.interstitialDidLoad(instanceId)
        } else {
            VRTLogError("delegate is nil")
        }
    }

    func interstitialDidFailToLoadWithError(_ error: Error?, instanceId: String?) {
        let delegate = getInterstitialDelegate(forInstanceID: instanceId)
        if let delegate {
            delegate.interstitialDidFailToLoadWithError(error, instanceId: instanceId)
            removeInterstitialDelegate(forInstanceID: instanceId)
        } else {
            VRTLogError("delegate is nil")
        }
    }

    func interstitialDidOpen(_ instanceId: String?) {
        let delegate = getInterstitialDelegate(forInstanceID: instanceId)
        if let delegate {
            delegate.interstitialDidOpen(instanceId)
        } else {
            VRTLogError("delegate is nil")
        }
    }

    func interstitialDidClose(_ instanceId: String?) {
        let delegate = getInterstitialDelegate(forInstanceID: instanceId)
        if let delegate {
            delegate.interstitialDidClose(instanceId)
            removeInterstitialDelegate(forInstanceID: instanceId)
        } else {
            VRTLogError("delegate is nil")
        }
    }

    func interstitialDidFailToShowWithError(_ error: Error?, instanceId: String?) {
        let delegate = getInterstitialDelegate(forInstanceID: instanceId)
        if let delegate {
            delegate.interstitialDidFailToShowWithError(error, instanceId: instanceId)
            removeInterstitialDelegate(forInstanceID: instanceId)
        } else {
            VRTLogError("delegate is nil")
        }
    }

    func didClickInterstitial(_ instanceId: String?) {
        let delegate = getInterstitialDelegate(forInstanceID: instanceId)
        if let delegate {
            delegate.didClickInterstitial(instanceId)
        } else {
            VRTLogError("delegate is nil")
        }
    }

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

//Dependencies

//Used by IronSource Interstitial Adapter, Vrtcal as Primary

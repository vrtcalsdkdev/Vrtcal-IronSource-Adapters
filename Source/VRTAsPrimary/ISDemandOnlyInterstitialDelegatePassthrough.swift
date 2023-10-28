//
//  Passthrough.swift
//  Vrtcal-Fyber-Marketplace-Adapters
//
//  Created by Scott McCoy on 9/16/23.
//

import VrtcalSDK
import IronSource

class ISDemandOnlyInterstitialDelegatePassthrough: NSObject, ISDemandOnlyInterstitialDelegate {

    public weak var viewControllerDelegate: ViewControllerDelegate?
    public weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    public weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    var delegates = [String: ISDemandOnlyInterstitialDelegateWeakRef]()
    
    func interstitialDidLoad(_ instanceId: String?) {
        VRTLogInfo()
        
        guard let instanceId else {
            VRTLogError("instanceId is nil")
            return
        }
        
        guard let delegate = delegates[instanceId]?.isDemandOnlyInterstitialDelegate else {
            VRTLogError("delegate is nil")
            return
        }
        
        delegate.interstitialDidLoad(instanceId)
    }
    
    func interstitialDidFailToLoadWithError(_ error: Error?, instanceId: String?) {
        VRTLogInfo()
        
        guard let instanceId else {
            VRTLogError("instanceId is nil")
            return
        }
        
        guard let delegate = delegates[instanceId]?.isDemandOnlyInterstitialDelegate else {
            VRTLogError("delegate is nil")
            return
        }
        
        delegate.interstitialDidFailToLoadWithError(error, instanceId: instanceId)
        
        delegates[instanceId] = nil
    }
    
    func interstitialDidOpen(_ instanceId: String?) {
        VRTLogInfo()

        guard let instanceId else {
            VRTLogError("instanceId is nil")
            return
        }
        
        guard let delegate = delegates[instanceId]?.isDemandOnlyInterstitialDelegate else {
            VRTLogError("delegate is nil")
            return
        }
        
        delegate.interstitialDidOpen(instanceId)
    }
    
    func interstitialDidClose(_ instanceId: String?) {
        VRTLogInfo()

        guard let instanceId else {
            VRTLogError("instanceId is nil")
            return
        }
        
        guard let delegate = delegates[instanceId]?.isDemandOnlyInterstitialDelegate else {
            VRTLogError("delegate is nil")
            return
        }
        
        delegate.interstitialDidClose(instanceId)
        
        delegates[instanceId] = nil
    }
    
    func interstitialDidFailToShowWithError(_ error: Error?, instanceId: String?) {
        VRTLogInfo()

        guard let instanceId else {
            VRTLogError("instanceId is nil")
            return
        }
        
        guard let delegate = delegates[instanceId]?.isDemandOnlyInterstitialDelegate else {
            VRTLogError("delegate is nil")
            return
        }
        
        delegate.interstitialDidFailToShowWithError(error, instanceId: instanceId)
        
        delegates[instanceId] = nil
    }
    
    func didClickInterstitial(_ instanceId: String?) {
        VRTLogInfo()

        guard let instanceId else {
            VRTLogError("instanceId is nil")
            return
        }
        
        guard let delegate = delegates[instanceId]?.isDemandOnlyInterstitialDelegate else {
            VRTLogError("delegate is nil")
            return
        }
        
        delegate.didClickInterstitial(instanceId)
    }
}

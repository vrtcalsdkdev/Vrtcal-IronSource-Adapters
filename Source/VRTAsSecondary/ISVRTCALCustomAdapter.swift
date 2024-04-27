//
//  ISVRTCALCustomAdapter.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
import Foundation
import IronSource
import VrtcalSDK

//Used by Vrtcal as Secondary Adapters
@objc(ISVRTCALCustomAdapter)
final class ISVRTCALCustomAdapter: ISBaseNetworkAdapter {
    
    // Note: NOT WEAK
    private var isNetworkInitializationDelegate: ISNetworkInitializationDelegate?
    static var vrtcalInitialized = false
    
    public override func `init` (_ adData: ISAdData, delegate: ISNetworkInitializationDelegate) {
        VRTLogInfo()
        
        // Since IronSource is Primary, blank out the mediation type
        IronSource.setMediationType("")
        
        // Get the app ID
        let strAppId = adData.configuration["appid"] as? String
        let appId = Int(strAppId ?? "") ?? 0
        
        // Save the delegate
        isNetworkInitializationDelegate = delegate
        
        // Init the SDK
        if ISVRTCALCustomAdapter.vrtcalInitialized {
            isNetworkInitializationDelegate?.onInitDidSucceed()
        } else {
            ISVRTCALCustomAdapter.vrtcalInitialized = true
            VrtcalSDK.initializeSdk(withAppId: appId, sdkDelegate: self)
        }
    }
    
    public override func networkSDKVersion() -> String? {
        return VrtcalSDK.sdkVersion()
    }
    
    public override func adapterVersion() -> String? {
        return "1.0"
    }
}

// MARK: - VrtcalSDKDelegate
extension ISVRTCALCustomAdapter: VrtcalSdkDelegate {

    func sdkInitialized() {
        VRTLogInfo()
        isNetworkInitializationDelegate?.onInitDidSucceed()
    }

    func sdkInitializationFailedWithError(_ error: Error) {
        VRTLogInfo("error: \(error)")
        isNetworkInitializationDelegate?.onInitDidFailWithErrorCode(0, errorMessage: description)
    }
}

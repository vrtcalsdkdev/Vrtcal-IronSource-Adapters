//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//
//  ISVRTCALCustomAdapter.swift
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//


//Superclass
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

class ISVRTCALCustomAdapter: ISBaseNetworkAdapter, VrtcalSdkDelegate {
    private weak var isNetworkInitializationDelegate: ISNetworkInitializationDelegate?
    
    init(_ adData: ISAdData?, delegate: ISNetworkInitializationDelegate?) {

        //Get the app ID
        let strAppId = adData?.configuration["appid"] as? String
        let appId = Int(strAppId ?? "") ?? 0

        //Save the delegate
        isNetworkInitializationDelegate = delegate

        //Init the SDK
        DispatchQueue.main.async(execute: {
            VrtcalSDK.initializeSdk(withAppId: appId, sdkDelegate: self)
        })
    }

    override func networkSDKVersion() -> String? {
        return VrtcalSDK.sdkVersion()
    }

    override func adapterVersion() -> String? {
        return "1.0"
    }

    // MARK: - VrtcalSDKDelegate

    func sdkInitialized() {
        isNetworkInitializationDelegate?.onInitDidSucceed()
    }

    func sdkInitializationFailedWithError(_ error: Error) {
        let description = "\(error)"
        isNetworkInitializationDelegate?.onInitDidFailWithErrorCode(0, errorMessage: description)
    }
}

//Dependencies

//Used by Vrtcal as Secondary Adapters

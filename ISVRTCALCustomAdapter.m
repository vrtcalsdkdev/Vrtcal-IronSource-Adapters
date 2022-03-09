//
//  ISVRTCALCustomAdapter.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
#import <Foundation/Foundation.h>
#import "ISVRTCALCustomAdapter.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>

//Used by Vrtcal as Secondary Adapters
@interface ISVRTCALCustomAdapter() <VrtcalSdkDelegate>
@property (weak) id<ISNetworkInitializationDelegate> isNetworkInitializationDelegate;
@end

@implementation ISVRTCALCustomAdapter

- (void)init:(ISAdData *)adData delegate:(id<ISNetworkInitializationDelegate>)delegate {
    
    //Get the app ID
    NSString *strAppId = [adData.configuration objectForKey:@"appid"];
    int appId = [strAppId intValue];
    
    //Save the delegate
    self.isNetworkInitializationDelegate = delegate;
    
    //Init the SDK
    dispatch_async(dispatch_get_main_queue(), ^{
        [VrtcalSDK initializeSdkWithAppId:appId sdkDelegate:self];
    });
}

- (NSString *) networkSDKVersion {
   return [VrtcalSDK sdkVersion];
}
- (NSString *) adapterVersion {
   return @"1.0";
}


#pragma mark - VrtcalSDKDelegate
- (void)sdkInitialized {
    [self.isNetworkInitializationDelegate onInitDidSucceed];
}

- (void)sdkInitializationFailedWithError:(nonnull NSError *)error {
    NSString *description = [error description];
    [self.isNetworkInitializationDelegate onInitDidFailWithErrorCode:0 errorMessage:description];
}



@end

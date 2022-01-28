//
//  VRTIronSourceManager.m
//  VrtcalSDKInternalTestApp
//
//  Created by Scott McCoy on 12/20/21.
//  Copyright © 2021 VRTCAL. All rights reserved.
//

//Header
#import "VRTIronSourceManager.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>

@interface VRTIronSourceManager ()
@property(nonatomic) NSMapTable<NSString *, id<ISDemandOnlyInterstitialDelegate>> *interstitialAdapterDelegates;
@end

@implementation VRTIronSourceManager

+ (instancetype)singleton {
    static VRTIronSourceManager *singleton = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    if (self = [super init]) {

        //Init the map table such that it will not retain adapters referenced by it
        self.interstitialAdapterDelegates = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
        
        NSString *mediationName = @"vrtcal";
        NSString *isMediationVersion = @"500";
        NSString *vrtcalSdkVersion = [VrtcalSDK sdkVersion];
        NSString *mediationType = [NSString stringWithFormat:@"%@%@SDK%@",
                                   mediationName,
                                   isMediationVersion,
                                   vrtcalSdkVersion];
        
        [IronSource setMediationType:mediationType];
    }
    return self;
}

#pragma mark - API
- (void)initIronSourceSDKWithAppKey:(NSString *)appKey forAdUnits:(NSSet *)adUnits {
    if([adUnits member:IS_INTERSTITIAL] != nil) {
        static dispatch_once_t onceTokenIS;

        dispatch_once(&onceTokenIS, ^{
            [IronSource setISDemandOnlyInterstitialDelegate:self];
        });
    }
    
    [IronSource initISDemandOnly:appKey adUnits:[adUnits allObjects]];
}



- (void)requestInterstitialAdWithDelegate: (id<ISDemandOnlyInterstitialDelegate>)delegate instanceID:(NSString *)instanceID {
    
    if (delegate == nil) {
        VRTLogError(@"Delegate is nil");
        return;
    }
    
    [self addInterstitialDelegate:delegate forInstanceID:instanceID];
    [IronSource loadISDemandOnlyInterstitial:instanceID];
}

- (void)presentInterstitialAdFromViewController:(nonnull UIViewController *)viewController instanceID: (NSString *) instanceID {
    [IronSource showISDemandOnlyInterstitial:viewController instanceId:instanceID];
}




#pragma mark - Delegate Pass-Through





#pragma mark ISDemandOnlyInterstitialDelegate

- (void)interstitialDidLoad:(NSString *)instanceId {

    id<ISDemandOnlyInterstitialDelegate> delegate = [self getInterstitialDelegateForInstanceID:instanceId];
    
    if (delegate) {
        [delegate interstitialDidLoad:instanceId];
    } else {
        VRTLogError(@"delegate is nil");
    }
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    id<ISDemandOnlyInterstitialDelegate> delegate = [self getInterstitialDelegateForInstanceID:instanceId];
    if (delegate) {
        [delegate interstitialDidFailToLoadWithError:error instanceId:instanceId];
        [self removeInterstitialDelegateForInstanceID:instanceId];
    } else {
        VRTLogError(@"delegate is nil");
    }
}

- (void)interstitialDidOpen:(NSString *)instanceId {
    id<ISDemandOnlyInterstitialDelegate> delegate = [self getInterstitialDelegateForInstanceID:instanceId];
    if (delegate) {
        [delegate interstitialDidOpen:instanceId];
    } else {
        VRTLogError(@"delegate is nil");
    }
}

- (void)interstitialDidClose:(NSString *)instanceId {
    id<ISDemandOnlyInterstitialDelegate> delegate = [self getInterstitialDelegateForInstanceID:instanceId];
    if (delegate) {
        [delegate interstitialDidClose:instanceId];
        [self removeInterstitialDelegateForInstanceID:instanceId];
    } else {
        VRTLogError(@"delegate is nil");
    }
}

- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    id<ISDemandOnlyInterstitialDelegate> delegate = [self getInterstitialDelegateForInstanceID:instanceId];
    if (delegate) {
        [delegate interstitialDidFailToShowWithError:error instanceId:instanceId];
        [self removeInterstitialDelegateForInstanceID:instanceId];
    } else {
        VRTLogError(@"delegate is nil");
    }
}

- (void)didClickInterstitial:(NSString *)instanceId {
    id<ISDemandOnlyInterstitialDelegate> delegate = [self getInterstitialDelegateForInstanceID:instanceId];
    if (delegate) {
        [delegate didClickInterstitial:instanceId];
    } else {
        VRTLogError(@"delegate is nil");
    }
}

#pragma Map Utils methods


- (void)addInterstitialDelegate: (id<ISDemandOnlyInterstitialDelegate>)adapterDelegate forInstanceID:(NSString *)instanceID {
    
    @synchronized(self.interstitialAdapterDelegates) {
        [self.interstitialAdapterDelegates setObject:adapterDelegate forKey:instanceID];
    }
}

- (id<ISDemandOnlyInterstitialDelegate>) getInterstitialDelegateForInstanceID:(NSString *)instanceID {
    id<ISDemandOnlyInterstitialDelegate> delegate;
    @synchronized(self.interstitialAdapterDelegates) {
        delegate = [self.interstitialAdapterDelegates objectForKey:instanceID];
    }
    return delegate;
}

- (void)removeInterstitialDelegateForInstanceID:(NSString *)InstanceID {
    @synchronized(self.interstitialAdapterDelegates) {
        [self.interstitialAdapterDelegates removeObjectForKey:InstanceID];
    }
}

@end

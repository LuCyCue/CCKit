//
//  CCAuthorizationLocation.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationLocation.h"

@interface CCAuthorizationLocation ()<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, copy) CCAuthorizationHandler completion;
@property (nonatomic, assign) BOOL firstTime;

@end

@implementation CCAuthorizationLocation

+ (instancetype)sharedManager {
    static CCAuthorizationLocation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCAuthorizationLocation alloc] init];
    });
    
    return sharedInstance;
}

/// 手机定位功能总开关状态
+ (BOOL)isServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)authorized {
    if (@available(iOS 14,*)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        CLAuthorizationStatus authorizationStatus = [[CCAuthorizationLocation sharedManager].locationManager authorizationStatus];
        return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
#endif
    }
    if (@available(iOS 8,*)) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
    }
    return YES;
}

+ (CLAuthorizationStatus)authorizationStatus {
    if (@available(iOS 14,*)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        CLAuthorizationStatus authorizationStatus = [[CCAuthorizationLocation sharedManager].locationManager authorizationStatus];
        return authorizationStatus;
#endif
    }
    return  [CLLocationManager authorizationStatus];
}

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)completion {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    [CCAuthorizationLocation sharedManager].firstTime = NO;
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways://kCLAuthorizationStatusAuthorized both equal 3
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            !completion ?: completion(YES, NO);
        }
            break;
        case kCLAuthorizationStatusNotDetermined: {
            if (![self isServicesEnabled]) {
                !completion ?: completion(NO, NO);
                return;
            }
            [CCAuthorizationLocation sharedManager].firstTime = YES;
            [[CCAuthorizationLocation sharedManager] startGPS:completion];
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            !completion ?: completion(NO, NO);
        }
            break;
            
        default:
            !completion ?: completion(YES, NO);
    }
}

- (CLLocationManager*)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)startGPS:(CCAuthorizationHandler)completion {
    if (_locationManager) {
        [self stopGPS];
    }
    self.completion = completion;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    if (@available(iOS 8,*)) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            if (hasAlwaysKey) {
                [_locationManager requestAlwaysAuthorization];
            } else if (hasWhenInUseKey) {
                [_locationManager requestWhenInUseAuthorization];
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or
                // NSLocationWhenInUseUsageDescription MUST be present in the Info.plist
                // file to use location services on iOS 8+.
                NSAssert(hasAlwaysKey || hasWhenInUseKey,
                         @"To use location services in iOS 8+, your Info.plist must "
                         @"provide a value for either "
                         @"NSLocationWhenInUseUsageDescription or "
                         @"NSLocationAlwaysUsageDescription.");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopGPS {
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //access permission,first callback this status
            [self stopGPS];
            if (_completion) {
                _completion(NO, NO);
            }
            self.completion = nil;
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self stopGPS];
            if (_completion) {
                _completion(YES, self.firstTime);
            }
            _completion = nil;
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            
            [self stopGPS];
            if (_completion) {
                _completion(NO, self.firstTime);
            }
            _completion = nil;
            break;
        }
    }
}

@end

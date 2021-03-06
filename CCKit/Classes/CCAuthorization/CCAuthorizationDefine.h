//
//  CCAuthorizationDefine.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#ifndef CCAuthorizationDefine_h
#define CCAuthorizationDefine_h

#ifndef __IPHONE_14_0
    #define __IPHONE_14_0    140000
#endif

typedef void(^CCAuthorizationHandler)(BOOL granted, BOOL firstTime);

typedef NS_ENUM(NSInteger, CCAuthorizationType) {
    CCAuthorizationTypeLocation,      ///<ä½ç½®
    CCAuthorizationTypeCamera,        ///<ç¸æº ð·
    CCAuthorizationTypePhotos,        ///<ç¸å
    CCAuthorizationTypePush,          ///<æ¨é
    CCAuthorizationTypeMicrophone,    ///<éº¦åé£ ð¤
    CCAuthorizationTypeMediaLibrary,  ///<åªä½åº Media& Apple music
    CCAuthorizationTypeTracking,      ///<å¹¿åè¿½è¸ª
};

///å UNAuthorizationStatus
typedef NS_ENUM(NSInteger, CCAuthorizationPushStatus) {
    CCAuthorizationPushStatusNotDetermined = 0,   ///< æéæªç¡®å®
    CCAuthorizationPushStatusDenied,              ///<æ²¡ææé
    CCAuthorizationPushStatusAuthorized,          ///<æéå·²ç»è·å
    CCAuthorizationPushStatusProvisional,         ///<æéå·²ç»è·å:ä¸å½±åç¨æ·æä½çéç¥æé
    CCAuthorizationPushStatusEphemeral,            ///<clipsæéä¸´æ¶æéå·²è·å
};

/**
 AVAudioSessionRecordPermissionUndetermined = 'undt',
 AVAudioSessionRecordPermissionDenied = 'deny',
 AVAudioSessionRecordPermissionGranted = 'grnt'
 */
typedef NS_ENUM(NSUInteger, CCAuthorizationMicroPhoneStatus) {
    CCAuthorizationMicroPhoneStatusUndetermined,
    CCAuthorizationMicroPhoneStatusDenied,
    CCAuthorizationMicroPhoneStatusGranted,
};

/** åç³»ç»  PHAuthorizationStatus*/
typedef NS_ENUM(NSUInteger, CCAuthorizationPhotoStatus) {
    CCAuthorizationPhotoStatusNotDetermined,
    CCAuthorizationPhotoStatusRestricted,
    CCAuthorizationPhotoStatusDenied,
    CCAuthorizationPhotoStatusAuthorized,
    CCAuthorizationPhotoStatusLimited,
};

///å MPMediaLibraryAuthorizationStatus
typedef NS_ENUM(NSInteger, CCAuthorizationMediaStatus) {
    CCAuthorizationMediaStatusNotDetermined = 0,
    CCAuthorizationMediaStatusDenied,
    CCAuthorizationMediaStatusRestricted,
    CCAuthorizationMediaStatusAuthorized,
};

#endif /* CCAuthorizationDefine_h */

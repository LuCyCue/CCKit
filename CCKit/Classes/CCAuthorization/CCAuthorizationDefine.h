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
    CCAuthorizationTypeLocation,      ///<位置
    CCAuthorizationTypeCamera,        ///<相机 📷
    CCAuthorizationTypePhotos,        ///<相册
    CCAuthorizationTypePush,          ///<推送
    CCAuthorizationTypeMicrophone,    ///<麦克风 🎤
    CCAuthorizationTypeMediaLibrary,  ///<媒体库 Media& Apple music
    CCAuthorizationTypeTracking,      ///<广告追踪
};

///同 UNAuthorizationStatus
typedef NS_ENUM(NSInteger, CCAuthorizationPushStatus) {
    CCAuthorizationPushStatusNotDetermined = 0,   ///< 权限未确定
    CCAuthorizationPushStatusDenied,              ///<没有权限
    CCAuthorizationPushStatusAuthorized,          ///<权限已经获取
    CCAuthorizationPushStatusProvisional,         ///<权限已经获取:不影响用户操作的通知权限
    CCAuthorizationPushStatusEphemeral,            ///<clips权限临时权限已获取
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

/** 同系统  PHAuthorizationStatus*/
typedef NS_ENUM(NSUInteger, CCAuthorizationPhotoStatus) {
    CCAuthorizationPhotoStatusNotDetermined,
    CCAuthorizationPhotoStatusRestricted,
    CCAuthorizationPhotoStatusDenied,
    CCAuthorizationPhotoStatusAuthorized,
    CCAuthorizationPhotoStatusLimited,
};

///同 MPMediaLibraryAuthorizationStatus
typedef NS_ENUM(NSInteger, CCAuthorizationMediaStatus) {
    CCAuthorizationMediaStatusNotDetermined = 0,
    CCAuthorizationMediaStatusDenied,
    CCAuthorizationMediaStatusRestricted,
    CCAuthorizationMediaStatusAuthorized,
};

#endif /* CCAuthorizationDefine_h */

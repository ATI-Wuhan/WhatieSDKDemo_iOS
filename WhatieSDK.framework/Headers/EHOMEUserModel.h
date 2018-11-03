//
//  EHOMEUserModel.h
//  WhatieSDK
//
//  Created by IIDreams on 2018/4/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"
#import "EHOMEDeviceModel.h"
#import "EHOMEHomeModel.h"

@class EHOMEPhotoModel;

@interface EHOMEUserModel : EHOMEBaseObject

#pragma mark - Property of UserModel

/**
 The unique ID of user, called userId.
 It's very important.And it is used everywhere.
 */
@property (nonatomic, assign) int id;

/**
 The email of user,which can login in app with password together
 such as:zhouwei2015@whut.edu.cn
 */
@property (nonatomic, copy) NSString *email;

/** Gender of user. */
@property (nonatomic, copy) NSString *gender;

/** Name of user. */
@property (nonatomic, copy) NSString *name;

/** Phone Number of user. */
@property (nonatomic, copy) NSString *phone;

/**
 Portrait of user.
 Get the web image's url by portrait.path
 */
@property (nonatomic, strong) EHOMEPhotoModel *portrait;

/**
 Thumb portrait of user.
 Get the web image's url by portraitThumb.path
 */
@property (nonatomic, strong) EHOMEPhotoModel *portraitThumb;

/**
 The topic of user used in MQTT.
 Subscribe topic with this topic.
 */
@property (nonatomic, copy) NSString *topic;

/** The time of user register.such as:1522487366000 */
@property (nonatomic, assign) long long createTime;

/** The time of latest login.such as:1523599236000 */
@property (nonatomic, assign) long long updateTime;


@property (nonatomic, strong) NSArray <EHOMEDeviceModel *> *deviceArray;

@property (nonatomic, strong) NSArray <EHOMEDeviceModel *> *sharedDeviceArray;

@property (nonatomic, strong) NSArray <EHOMEHomeModel *> *homeArray;

@property (nonatomic, assign) BOOL isHomeArrayFromServer;

@property (nonatomic, assign) BOOL isDeviceArrayFromServer;


#pragma mark - Functions

/**
 instance
 
 @return self
 */
+(EHOMEUserModel *)shareInstance;


/**
 isLogin
 
 The BOOL value returns.
 If user has been logged in,return YES,else return NO.
 */
+(BOOL)isLogin;

/**
 GetCurrentUser
 
 Get current user info after login.And the data will be EHOMEUserModel.
 */
+(EHOMEUserModel *)getCurrentUser;

/**
 RemoveCurrentUser
 
 Remove the user info.
 After do this,user should login again.
 */
+(void)removeCurrentUser;

/**
 SetCurrentUser
 
 The latest user info should be updated in cache.
 
 @param userModel : mode of user info
 */
+(void)setCurrentUserWithUserModel:(EHOMEUserModel *)userModel;


/**
 registerByEmail
 
 No verification code is required during email registration. Users may register their accounts directly.
 
 @param email : user email
 @param password : password

 */
-(void)registerByEmail:(NSString *)email
              password:(NSString *)password
               success:(successBlock)success
               failure:(failBlock)failure;

/**
 Login
 
 Upon a successful call, the user’s session will be stored locally by the SDK. When the app is launched next time, the used is logged in by default and no more login process is required.

 @param email : user email
 @param password : password

 */
-(void)loginByEmail:(NSString *)email
           password:(NSString *)password
            success:(successBlock)success
            failure:(failBlock)failure;

/**
 SendVerifyCodeByEmail(Step 1)
 
 Sending a verification code to the mailbox for Resetting a password once forget password.

 @param email : user email
 
 */
-(void)sendVerifyCodeByEmail:(NSString *)email
                     success:(successBlock)success
                     failure:(failBlock)failure;


/**
 resetPasswordByEmail(Step 2)
 
 The verification code received is then used to reset the password

 @param email : user email
 @param newPassword : user new password
 @param code : The verification code received
 
 */
-(void)resetPasswordByEmail:(NSString *)email
                newPassword:(NSString *)newPassword
                       code:(NSString *)code
                    success:(successBlock)success
                    failure:(failBlock)failure;


/**
 resetPasswordByOldPassword
 
 Set new password by old password and email.
 
 @param oldPassword : old password
 @param newPassword : new password
 
 */
-(void)resetPasswordByOldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword
                            email:(NSString *)email
                          success:(successBlock)success
                          failure:(failBlock)failure;



/**
 syncDeviceWithCloud
 
 Using the "syncDeviceWithCloud" method will update the user’s current device list deviceArray.
 
 The success returns the deviceArray with <EHOMEDeviceModel *> array.
 
 */
-(void)syncDeviceWithCloud:(successBlock)success
                   failure:(failBlock)failure;


/**
 syncSharedDeviceWithCloud
 
 Using the "syncSharedDeviceWithCloud" method will update the user’s current shared device list sharedDeviceArray.
 
 The success returns the sharedDeviceArray with <EHOMEDeviceModel *> array.
 
 */
-(void)syncSharedDeviceWithCloud:(successBlock)success
                         failure:(failBlock)failure;


/**
 syncSharedoOutDeviceWithCloud
 
 Using the "syncSharedOutDeviceWithCloud" method.
 
 */
-(void)syncSharedOutDeviceWithCloud:(successBlock)success
                            failure:(failBlock)failure;


/**
 syncHomeWithCloud
 
 Using the "syncHomeWithCloud" method will update the user’s home list homeArray.
 
 The success returns the homeArray with <EHOMEHomeModel *> array.
 
 */
-(void)syncHomeWithCloud:(successBlock)success
                 failure:(failBlock)failure;


/**
 updateNickname
 
 */
-(void)updateNickname:(NSString *)name
              success:(successBlock)success
              failure:(failBlock)failure;


/**
 Logout
 
 If user want to logout,do this.
 
 */
-(void)loginOut:(successBlock)success
      failure:(failBlock)failure;



/**
 getFeedbackTalkList
 
 */
-(void)getFeedbackListWithPage:(int)page
                          size:(int)size
                       success:(successBlock)success
                       failure:(failBlock)failure;

/**
 addFeedback
 
 */
-(void)addFeedback:(NSString *)feedback
           success:(successBlock)success
           failure:(failBlock)failure;

/**
 addHomeWithName
 
 add a home with name.
 
 @param name : new home name.
 
 */
-(void)addNewHomeWithName:(NSString *)name
                  success:(successBlock)success
                  failure:(failBlock)failure;


/**
 setCurrentHome
 
 */
-(void)setCurrentHome:(EHOMEHomeModel *)currentHome;

/**
 getCurrentHome
 
 */
-(void)getCurrentHomeSuccess:(successBlock)success
                     failure:(failBlock)failure;

/**
 removeCurrentHome
 
 */
-(void)removeCurrentHome;



@end

@interface EHOMEPhotoModel : EHOMEBaseObject

@property (nonatomic, assign) int id;// = 237;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) long long createTime;

@end

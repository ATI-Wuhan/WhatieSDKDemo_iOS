//
//  EHOMEHomeModel.h
//  WhatieSDK
//
//  Created by clj on 2018/6/30.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"
#import "EHOMERoomModel.h"
#import "EHOMESceneModel.h"

@class host;
@class EHomeMemberModel;
@interface EHOMEHomeModel : EHOMEBaseObject

#pragma mark - Property of HomeModel

/**
 The unique ID of home, called homeId.
 */
@property (nonatomic, assign) int id;

/** Name of home. */
@property (nonatomic, copy) NSString *name;

/**
 host of home.
 Get the hostID of home by host.id
 */
@property(nonatomic, strong) host *host;

#pragma mark - Functions

/**
 UpdateHomeName
 
 update home name with name.
 
 @param name : new home name.
 
 */
-(void)updateHomeName:(NSString *)name
              success:(successBlock)success
              failure:(failBlock)failure;


/**
 transferHome
 
 */
-(void)transferHomeWithByEmail:(NSString *)email
                       success:(successBlock)success
                       failure:(failBlock)failure;


/**
 exitHome
 
 */
-(void)removeHome:(successBlock)success
          failure:(failBlock)failure;


/**
 transferAdmin
 
 */
-(void)transferAdminWithMemberModel:(EHomeMemberModel *)memberModel
                            success:(successBlock)success
                            failure:(failBlock)failure;


/**
 inviteHomeMemberWithEmail
 invite member of home with home email
 @param email : new member email.
 
 */
-(void)inviteHomeMemberByEmail:(NSString *)email
                       success:(successBlock)success
                       failure:(failBlock)failure;


/**
 syncDeviceByHome
 
 */
-(void)syncDeviceByHomeSuccess:(successBlock)success
                       failure:(failBlock)failure;


/**
 syncRoomByHome
 
 */
-(void)syncRoomByHomeSuccess:(successBlock)success
                     failure:(failBlock)failure;


/**
 getMemberList
 
 */
-(void)getHomeMemberSuccess:(successBlock)success
                    failure:(failBlock)failure;


/**
 add new room
 
 */
-(void)addNewRoomWithName:(NSString *)name
           roomBackground:(EHOMEBackgroundModel *)roomBackground
                  success:(successBlock)success
                  failure:(failBlock)failure;

/**
 syncSceneByHome
 
 */
-(void)syncSceneByHomeSuccess:(successBlock)success
                     failure:(failBlock)failure;


/**
 add new scene
 
 */
-(void)addSceneWithName:(NSString *)name
                   time:(NSString *)time
                  loops:(NSString *)loops
          deviceIdArray:(NSArray *)deviceIdArray
          functionArray:(NSArray *)functionArray
               sceneTye:(BOOL)isManual
                success:(successBlock)success
                failure:(failBlock)failure;


/**
 Add new scene by <EHOMEDeviceModel *>actionDeviceArray
 
 */
-(void)addSceneWithName:(NSString *)name
                   time:(NSString *)time
                  loops:(NSString *)loops
      actionDeviceArray:(NSArray *)actionDeviceArray
                success:(successBlock)success
                 failue:(failBlock)failure;


/**
 inviteHomeMemberWithScanCode
 @param email : new member email.
 @param homeId : inviter's homeId.
 */
+(void)addMemberWithMemberEmail:(NSString *)email
                         homeId:(int)homeId
              generateTimeStamp:(long)generateTimeStamp
                        success:(successBlock)success
                         failue:(failBlock)failure;


/**
 transferHomeWithScanCode
 
 */
+(void)transferHomeWithHomeId:(int)homeId
                       hostId:(int)hostId
                transferEmail:(NSString *)transferEmail
            generateTimeStamp:(long)generateTimeStamp
                      success:(successBlock)success
                      failure:(failBlock)failure;
@end


@interface host : EHOMEBaseObject
@property (nonatomic, assign) int id;
@end


@class customer;
@interface EHomeMemberModel : EHOMEBaseObject

@property (nonatomic, assign) BOOL host;
@property (nonatomic, strong) customer *customer;



/**
 deleteMember
 
 */
-(void)removeMemberFromHome:(EHOMEHomeModel *)homeModel
                    success:(successBlock)success
                    failure:(failBlock)failure;

@end


@class userPhoto;
@interface customer : EHOMEBaseObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) userPhoto *portrait;
@property (nonatomic, strong) userPhoto *portraitThumb;

@end

@interface userPhoto:EHOMEBaseObject

@property (nonatomic, copy) NSString *path;

@end

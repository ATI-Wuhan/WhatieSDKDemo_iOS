//
//  EHOMEDataStore.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHOMEDataStore : NSObject

/** Home DataBase
 *
 */
//1.添加单个家庭到数据库，用于新增家庭成功后调用
+(void)setHomeToDB:(EHOMEHomeModel *)homeModel;

//2.添加家庭列表到数据库，用于获取家庭列表成功后调用
+(void)setHomesToDBWithHomes:(NSArray <EHOMEHomeModel *> *)homes;

//3.从数据库中获取家庭列表
+(NSArray <EHOMEHomeModel *> *)getHomesFromDB;

//4.从数据库中删除单个家庭数据，用于删除家庭成功后调用
+(void)removeHomeFromDB:(EHOMEHomeModel *)homeModel;

//5.从数据中删除所有家庭数据
+(void)removeAllHomesFromDB;






/** Device DataBase
 *
 */
//1.添加单个设备到数据库，用于新增设备成功后调用，目前无效。
+(void)setDeviceToDB:(EHOMEDeviceModel *)deviceModel;

//2.添加设备列表到数据库，用于获取设备列表成功后调用
+(void)setDevicesToDBWithDevices:(NSArray <EHOMEDeviceModel *> *)devices;

//3.从数据库中获取设备列表
+(NSArray <EHOMEDeviceModel *> *)getDevicesFromDB;

//4.从数据库中删除单个设备数据，用于删除设备成功后调用
+(void)removeDeviceFromDB:(EHOMEDeviceModel *)deviceModel;

//5.从数据中删除所有设备数据
+(void)removeAllDevicesFromDB;






/** Room DataBase
 *
 */
//1.添加单个房间到数据库，用于新增、修改房间成功后调用
+(void)setRoomToDB:(EHOMERoomModel *)roomModel;

//2.添加房间列表到数据库，用于获取房间列表成功后调用
+(void)setRoomsToDBWithRooms:(NSArray <EHOMERoomModel *> *)rooms inHome:(int)homeId;

//3.从数据库中获取某个家庭下面的房间列表
+(NSArray <EHOMERoomModel *> *)getRoomsFromDBWithHomeId:(int)homeId;

//4.从数据库中删除单个房间数据，用于删除房间成功后调用
+(void)removeRoomFromDB:(EHOMERoomModel *)roomModel InHomeId:(int)homeId;

//5.从数据中删除所有房间数据
+(void)removeAllRoomsFromDB;

//6.从数据中删除某个家庭下的房间数据
+(void)removeAllRoomsFromDBInHome:(int)homeId;





/** Scene DataBase
 *
 */
//1.添加单个场景到数据库，用于新增、修改场景成功后调用
+(void)setSceneToDB:(EHOMESceneModel *)sceneModel;

//2.添加场景列表到数据库，用于获取场景列表成功后调用
+(void)setScenesToDBWithScenes:(NSArray <EHOMESceneModel *> *)scenes inHome:(int)homeId;

//3.从数据库中获取某个家庭下面的场景列表
+(NSArray <EHOMESceneModel *> *)getScenesFromDBWithHomeId:(int)homeId;

//4.从数据库中删除单个场景数据，用于删除场景成功后调用
+(void)removeSceneFromDB:(EHOMESceneModel *)sceneModel InHomeId:(int)homeId;

//5.从数据中删除所有场景数据
+(void)removeAllScenesFromDB;

//6.从数据中删除某个家庭下的场景数据
+(void)removeAllScenesFromDBInHome:(int)homeId;




//WiFi
/** WIFI DataBase
 *
 */
//1.添加单个wifi到数据库，用于配网时确定了WiFi密码后调用
+(void)setWifiToDB:(NSString *)wifiName andWifiPassword:(NSString *)password;

//2.从数据库中获取某个wifi的WiFi密码
+(NSString *)getWifiPasswordFromDBWithWifiName:(NSString *)wifiName;

//3.从数据库中删除单个wifi数据
+(void)removeWifiFromDB:(NSString *)wifiName;

//4.从数据中删除所有wifi数据
+(void)removeAllWifiFromDB;






//User
/** User DataBase
 *
 */
//1.添加单个登录账号密码到数据库，用于登录成功时调用
+(void)setUserToDB:(NSString *)email andPassword:(NSString *)password;

//2.从数据库中获取某个用户的登录信息（邮箱和密码）
+(EHOMEUserDB *)getUserFromDBWithEmail:(NSString *)email;

//3.从数据库中获取所有用户的登录信息（邮箱和密码）
+(NSArray <EHOMEUserDB *> *)getUserDBsFromDB;

//4.从数据库中删除单个用户的登录信息
+(void)removeUserDBFromDB:(NSString *)email;

//5.从数据中删除所有用户登录数据
+(void)removeAllUserDBFromDB;


@end

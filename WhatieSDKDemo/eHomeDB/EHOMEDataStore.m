//
//  EHOMEDataStore.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEDataStore.h"
#import <YYCache/YYCache.h>

@implementation EHOMEDataStore

+(void)setHomeToDB:(EHOMEHomeModel *)homeModel{
    
    RLMResults *results = [Home objectsWhere:@"id == %d",homeModel.id];
    
    if (results.count == 0) {
        //数据库不存在当前家庭，可以新增到数据库
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        Home *object = [[Home alloc] init];
        object.id = homeModel.id;
        object.homeJson = homeModel.mj_JSONString;
        
        [realm transactionWithBlock:^{
            [realm addObject:object];
        }];
    }else{
        //数据库存在当前家庭，更新信息
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm transactionWithBlock:^{
            for (Home *h in results) {
                h.homeJson = homeModel.mj_JSONString;
            }
        }];
    }
}

+(void)setHomesToDBWithHomes:(NSArray <EHOMEHomeModel *> *)homes{
    
    //获取所有家庭列表成功，存档至数据库
    
    //1.避免多个手机数据库不同步，先清空本地数据库家庭列表数据
    [EHOMEDataStore removeAllHomesFromDB];
    
    //2.重新添加到数据库
    for (EHOMEHomeModel *home in homes) {
        
        RLMResults *results = [Home objectsWhere:@"id == %d",home.id];
        
        if (results.count == 0) {
            //数据库不存在当前家庭，可以新增到数据库
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            Home *object = [[Home alloc] init];
            object.id = home.id;
            object.homeJson = home.mj_JSONString;
            
            [realm transactionWithBlock:^{
                [realm addObject:object];
            }];
        }else{
            //数据库存在当前家庭，更新信息
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm transactionWithBlock:^{
                for (Home *h in results) {
                    h.homeJson = home.mj_JSONString;
                }
            }];
        }
    }
}

+(NSArray <EHOMEHomeModel *> *)getHomesFromDB{
    
    RLMResults *results = [Home allObjects];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (results.count > 0) {
        for (Home *objet in results) {
            
            EHOMEHomeModel *home = [EHOMEHomeModel mj_objectWithKeyValues:objet.homeJson];
            [tempArray addObject:home];
        }
        return tempArray;
    }else{
        return @[];
    }
}

+(void)removeHomeFromDB:(EHOMEHomeModel *)homeModel{
    
    RLMResults *results = [Home objectsWhere:@"id == %d",homeModel.id];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

+(void)removeAllHomesFromDB{
    
    RLMResults *results = [Home allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}


/** Device DataBase
 *
 */
//1.添加单个设备到数据库，用于新增设备成功后调用，目前无效。
+(void)setDeviceToDB:(EHOMEDeviceModel *)deviceModel{
    
    RLMResults *results = [DeviceDB objectsWhere:@"id == %d",deviceModel.device.id];
    
    if ([deviceModel.device.status isEqualToString:@"Offline"]) {
        deviceModel.device.status = @"Online";
    }
    
    if (results.count == 0) {
        //数据库不存在当前家庭，可以新增到数据库
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        DeviceDB *object = [[DeviceDB alloc] init];
        object.id = deviceModel.device.id;
        object.devId = deviceModel.device.devId;
        object.deviceJson = deviceModel.mj_JSONString;
        
        [realm transactionWithBlock:^{
            [realm addObject:object];
        }];
    }else{
        //数据库存在当前家庭，更新信息
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm transactionWithBlock:^{
            for (DeviceDB *d in results) {
                d.devId = deviceModel.device.devId;
                d.deviceJson = deviceModel.mj_JSONString;
            }
        }];
    }
}

//2.添加设备列表到数据库，用于获取设备列表成功后调用
+(void)setDevicesToDBWithDevices:(NSArray <EHOMEDeviceModel *> *)devices{
    
    //获取所有设备列表成功，存档至数据库
    
    //1.避免多个手机数据库不同步，先清空本地数据库设备列表数据
    [EHOMEDataStore removeAllDevicesFromDB];
    

    //2.重新添加到数据库
    for (EHOMEDeviceModel *device in devices) {
        
        if ([device.device.status isEqualToString:@"Offline"]) {
//            device.device.status = @"Online";
        }
        
        RLMResults *results = [DeviceDB objectsWhere:@"id == %d",device.device.id];
        
        if (results.count == 0) {
            //数据库不存在当前设备，可以新增到数据库
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            DeviceDB *object = [[DeviceDB alloc] init];
            object.id = device.device.id;
            object.devId = device.device.devId;
            object.deviceJson = device.mj_JSONString;
            
            [realm transactionWithBlock:^{
                [realm addObject:object];
            }];
        }else{
            //数据库存在当前设备，更新信息
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm transactionWithBlock:^{
                for (DeviceDB *d in results) {
                    d.devId = device.device.devId;
                    d.deviceJson = device.mj_JSONString;
                }
            }];
        }
    }
}

//3.从数据库中获取设备列表
+(NSArray <EHOMEDeviceModel *> *)getDevicesFromDB{
    
    RLMResults *results = [DeviceDB allObjects];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (results.count > 0) {
        
        NSMutableDictionary *topics = [NSMutableDictionary dictionary];
        
        for (DeviceDB *objet in results) {
            
            EHOMEDeviceModel *device = [EHOMEDeviceModel mj_objectWithKeyValues:objet.deviceJson];
            if ([device.device.status isEqualToString:@"Offline"]) {
                device.device.status = @"Online";
            }

            [tempArray addObject:device];
            
            NSString *topic = [NSString stringWithFormat:@"d9lab/device/out/%@",device.device.devId];
            topics[topic] = @(1);
        }
        
        [[EHOMEMQTTClientManager shareInstance] subscribeTopicsWithTopics:topics];
        
        return tempArray;
    }else{
        return @[];
    }
}

//4.从数据库中删除单个设备数据，用于删除设备成功后调用
+(void)removeDeviceFromDB:(EHOMEDeviceModel *)deviceModel{
    
    RLMResults *results = [DeviceDB objectsWhere:@"id == %d",deviceModel.device.id];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//5.从数据中删除所有设备数据
+(void)removeAllDevicesFromDB{
    
    RLMResults *results = [DeviceDB allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}






/** Room DataBase
 *
 */
//1.添加单个房间到数据库，用于新增、修改房间成功后调用
+(void)setRoomToDB:(EHOMERoomModel *)roomModel{
    
    RLMResults *results = [RoomDB objectsWhere:@"homeId == %d AND roomId = %d",roomModel.room.home.id,roomModel.room.id];
    
    if (results.count == 0) {
        //数据库不存在当前房间，可以新增到数据库
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        RoomDB *object = [[RoomDB alloc] init];
        object.homeId = roomModel.room.home.id;
        object.roomId = roomModel.room.id;
        object.roomJson = roomModel.mj_JSONString;
        
        [realm transactionWithBlock:^{
            [realm addObject:object];
        }];
    }else{
        //数据库存在当前房间，更新信息
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm transactionWithBlock:^{
            for (RoomDB *r in results) {
                r.roomJson = roomModel.mj_JSONString;
            }
        }];
    }
}

//2.添加房间列表到数据库，用于获取房间列表成功后调用
+(void)setRoomsToDBWithRooms:(NSArray <EHOMERoomModel *> *)rooms inHome:(int)homeId{
    
    //获取所有设备列表成功，存档至数据库
    
    //1.避免多个手机数据库不同步，先清空本地数据库设备列表数据
    [EHOMEDataStore removeAllRoomsFromDBInHome:homeId];
    
    //2.重新添加到数据库
    for (EHOMERoomModel *room in rooms) {
        
        RLMResults *results = [RoomDB objectsWhere:@"homeId == %d AND roomId == %d",homeId ,room.room.id];
        
        if (results.count == 0) {
            //数据库不存在当前设备，可以新增到数据库
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            RoomDB *object = [[RoomDB alloc] init];
            object.homeId = homeId;
            object.roomId = room.room.id;
            object.roomJson = room.mj_JSONString;
            
            [realm transactionWithBlock:^{
                [realm addObject:object];
            }];
        }else{
            //数据库存在当前家庭，更新信息
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm transactionWithBlock:^{
                for (RoomDB *r in results) {
                    r.roomJson = room.mj_JSONString;
                }
            }];
        }
    }
}

//3.从数据库中获取某个家庭下面的房间列表
+(NSArray <EHOMERoomModel *> *)getRoomsFromDBWithHomeId:(int)homeId{
    
    RLMResults *results = [RoomDB objectsWhere:@"homeId == %d", homeId];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (results.count > 0) {
        
        for (RoomDB *objet in results) {
            
            EHOMERoomModel *room = [EHOMERoomModel mj_objectWithKeyValues:objet.roomJson];
            [tempArray addObject:room];
        }
        
        return tempArray;
    }else{
        return @[];
    }
}

//4.从数据库中删除单个房间数据，用于删除房间成功后调用
+(void)removeRoomFromDB:(EHOMERoomModel *)roomModel InHomeId:(int)homeId{
    
    RLMResults *results = [RoomDB objectsWhere:@"homeId == %d AND roomId == %d",homeId,roomModel.room.id];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//5.从数据中删除所有房间数据
+(void)removeAllRoomsFromDB{
    
    RLMResults *results = [RoomDB allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//6.从数据中删除某个家庭下的房间数据
+(void)removeAllRoomsFromDBInHome:(int)homeId{
    
    
    RLMResults *results = [RoomDB objectsWhere:@"homeId == %d", homeId];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}






/** Scene DataBase
 *
 */
//1.添加单个场景到数据库，用于新增、修改场景成功后调用
+(void)setSceneToDB:(EHOMESceneModel *)sceneModel{
    
    RLMResults *results = [SceneDB objectsWhere:@"homeId == %d AND sceneId = %d",sceneModel.scene.homeId,sceneModel.scene.id];
    
    if (results.count == 0) {
        //数据库不存在当前房间，可以新增到数据库
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        SceneDB *object = [[SceneDB alloc] init];
        object.homeId = sceneModel.scene.homeId;
        object.sceneId = sceneModel.scene.id;
        object.sceneJson = sceneModel.mj_JSONString;
        
        [realm transactionWithBlock:^{
            [realm addObject:object];
        }];
    }else{
        //数据库存在当前房间，更新信息
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm transactionWithBlock:^{
            for (SceneDB *r in results) {
                r.sceneJson = sceneModel.mj_JSONString;
            }
        }];
    }
}

//2.添加场景列表到数据库，用于获取场景列表成功后调用
+(void)setScenesToDBWithScenes:(NSArray <EHOMESceneModel *> *)scenes inHome:(int)homeId{
    
    //获取所有设备列表成功，存档至数据库
    
    //1.避免多个手机数据库不同步，先清空本地数据库设备列表数据
    [EHOMEDataStore removeAllScenesFromDBInHome:homeId];
    
    //2.重新添加到数据库
    for (EHOMESceneModel *scene in scenes) {
        
        RLMResults *results = [SceneDB objectsWhere:@"homeId == %d AND sceneId == %d",homeId ,scene.scene.id];
        
        if (results.count == 0) {
            //数据库不存在当前设备，可以新增到数据库
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            SceneDB *object = [[SceneDB alloc] init];
            object.homeId = homeId;
            object.sceneId = scene.scene.id;
            object.sceneJson = scene.mj_JSONString;
            
            [realm transactionWithBlock:^{
                [realm addObject:object];
            }];
        }else{
            //数据库存在当前家庭，更新信息
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm transactionWithBlock:^{
                for (SceneDB *s in results) {
                    s.sceneJson = scene.mj_JSONString;
                }
            }];
        }
    }
}

//3.从数据库中获取某个家庭下面的场景列表
+(NSArray <EHOMESceneModel *> *)getScenesFromDBWithHomeId:(int)homeId{
    
    RLMResults *results = [SceneDB objectsWhere:@"homeId == %d", homeId];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (results.count > 0) {
        
        for (SceneDB *objet in results) {
            
            [EHOMESceneModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"sceneDeviceVos":@"EHOMESceneDeviceModel"};
            }];
            
            EHOMESceneModel *scene = [EHOMESceneModel mj_objectWithKeyValues:objet.sceneJson];
            [tempArray addObject:scene];
        }
        
        return tempArray;
    }else{
        return @[];
    }
}

//4.从数据库中删除单个场景数据，用于删除场景成功后调用
+(void)removeSceneFromDB:(EHOMESceneModel *)sceneModel InHomeId:(int)homeId{
    
    RLMResults *results = [SceneDB objectsWhere:@"homeId == %d AND sceneId == %d",homeId,sceneModel.scene.id];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//5.从数据中删除所有场景数据
+(void)removeAllScenesFromDB{
    
    RLMResults *results = [SceneDB allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//6.从数据中删除某个家庭下的场景数据
+(void)removeAllScenesFromDBInHome:(int)homeId{
    
    
    RLMResults *results = [SceneDB objectsWhere:@"homeId == %d", homeId];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}





//WiFi
/** WIFI DataBase
 *
 */
//1.添加单个wifi到数据库，用于配网时确定了WiFi密码后调用
+(void)setWifiToDB:(NSString *)wifiName andWifiPassword:(NSString *)password{
    
    RLMResults *results = [EHOMEWifiDB objectsWhere:@"name == %@",wifiName];
    
    if (results.count == 0) {
        //数据库不存在当前wifi，可以新增到数据库
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        EHOMEWifiDB *object = [[EHOMEWifiDB alloc] init];
        object.name = wifiName;
        object.password = password;
        
        [realm transactionWithBlock:^{
            [realm addObject:object];
        }];
    }else{
        //数据库存在当前房间，更新信息
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm transactionWithBlock:^{
            for (EHOMEWifiDB *w in results) {
                w.password = password;
            }
        }];
    }
}

//2.从数据库中获取某个wifi的WiFi密码
+(NSString *)getWifiPasswordFromDBWithWifiName:(NSString *)wifiName{
    
    RLMResults *results = [EHOMEWifiDB objectsWhere:@"name == %@", wifiName];
    
    NSString *wifiPassword = @"";
    
    if (results.count > 0) {
        
        for (EHOMEWifiDB *objet in results) {
            
            wifiPassword = objet.password;
        }
        
        return wifiPassword;
    }else{
        return @"";
    }
}

//3.从数据库中删除单个wifi数据
+(void)removeWifiFromDB:(NSString *)wifiName{
    
    
    RLMResults *results = [EHOMEWifiDB objectsWhere:@"name == %@", wifiName];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//4.从数据中删除所有wifi数据
+(void)removeAllWifiFromDB{

    RLMResults *results = [EHOMEWifiDB allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}





//User
/** User DataBase
 *
 */
//1.添加单个登录账号密码到数据库，用于登录成功时调用
+(void)setUserToDB:(NSString *)email andPassword:(NSString *)password{
    
    RLMResults *results = [EHOMEUserDB objectsWhere:@"email == %@",email];
    
    if (results.count == 0) {
        //数据库不存在当前用户，可以新增到数据库
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        EHOMEUserDB *object = [[EHOMEUserDB alloc] init];
        object.email = email;
        object.password = password;
        
        [realm transactionWithBlock:^{
            [realm addObject:object];
        }];
    }else{
        //数据库存在当前用户，更新信息
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm transactionWithBlock:^{
            for (EHOMEUserDB *w in results) {
                w.password = password;
            }
        }];
    }
}

//2.从数据库中获取某个用户的登录信息（邮箱和密码）
+(EHOMEUserDB *)getUserFromDBWithEmail:(NSString *)email{
    
    RLMResults *results = [EHOMEUserDB objectsWhere:@"email == %@", email];
    
    EHOMEUserDB *user = [EHOMEUserDB new];
    
    if (results.count > 0) {
        
        for (EHOMEUserDB *objet in results) {

            user = objet;
        }
        
        return user;
    }else{
        return nil;
    }
}

//3.从数据库中获取所有用户的登录信息（邮箱和密码）
+(NSArray <EHOMEUserDB *> *)getUserDBsFromDB{
    
    RLMResults *results = [EHOMEUserDB allObjects];

    if (results.count > 0) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (EHOMEUserDB *objet in results) {
            
            [tempArray addObject:objet];
        }
        
        return tempArray;
    }else{
        return @[];
    }
}

//3.从数据库中删除单个用户的登录信息
+(void)removeUserDBFromDB:(NSString *)email{
    
    
    RLMResults *results = [EHOMEUserDB objectsWhere:@"email == %@", email];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

//4.从数据中删除所有用户登录数据
+(void)removeAllUserDBFromDB{
    
    
    RLMResults *results = [EHOMEUserDB allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:results];
    }];
}

@end

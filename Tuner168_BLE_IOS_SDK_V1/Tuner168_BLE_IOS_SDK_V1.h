//
//  BLE_LXXAVR.h
//  BLE_LXXAVR
//
//  Created by LXXAVR on 14-1-9.
//  Copyright (c) 2014年 LXXAVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


@protocol Tuner168_BLE_IOS_SDK_Delegate
@optional
-(void) BLE_DEV_RD:(CBPeripheral *)peripheral error:(NSError *)error;//连接上设备后，调用此函数
@required

-(void) Receive_Data_Event:(NSData*)TXP p:(UInt8)len DEV:(CBPeripheral*)cb;//接收到数据时调用此函数 ,DEV为接收设备对象
-(void) Receive_Batt_Event:(NSData*)TXP p:(UInt8)len DEV:(CBPeripheral*)cb;//读取设备电池电量，此接口为防丢器专用
- (void) DEV_List_fresh;//设备列表有变化时，调用此函数
//-(void)DEV_Broadcast_Data:(CBPeripheral *)peripheral brd:(NSString*)bb uuid:(NSString*)uuid;//扫描设备回调，bb表示设备的广播数据，uuid表示设备的广播uuid
-(void)disconnect:(CBPeripheral *)peripheral error:(NSError *)error;//当蓝牙设备断开后调用此函数

@end

@interface Tuner168_BLE_IOS_SDK : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    
}

@property (nonatomic,assign) id <Tuner168_BLE_IOS_SDK_Delegate> delegate;
@property (strong, nonatomic) CBCentralManager *CM;//类对象
@property (strong, nonatomic) CBPeripheral *activePeripheral;//ble 对象
@property (retain, nonatomic) NSMutableArray    *DEV_MEM;//设备列表


-(void) sbb:(Byte*)buzVal p:(CBPeripheral *)p pp:(int)len;//备用
-(void) svv:(Byte*)buzVal p:(CBPeripheral *)p pp:(int)len;//备用

-(NSString*)Get_Dev_Name;//获得设备名称
-(NSString*)Get_Dev_Name :(CBPeripheral *)cb;//获得指定设备名称


-(NSData*)stringToByte:(NSString*)string;//字符串转十六进制数据


-(BOOL)Send_Data:(NSString*)Str_data;//发送数据格式为十六进制字符串
-(BOOL)Send_Data:(NSString*)Str_data :(CBPeripheral *)cb;////指定设备，发送数据格式为十六进制字符串

-(int)Read_RSSI;//读取设备RSSI信号强度
-(int)Read_RSSI:(CBPeripheral*)pheral;//读取指定设备RSSI信号强度

-(NSString*)Read_DEV_UUID;//读取设备uuid
-(NSString*)Read_DEV_UUID:(CBPeripheral*)pheral;//读取指定设备uuid


//注意：由于苹果读取设备蓝牙mac地址的权限问题，此mac地址为模拟值，与设备mac地址有一定的差异，
-(NSString*)Read_DEV_MAC;//读取设备mac地址
-(NSString*)Read_DEV_MAC:(CBPeripheral*)pheral;//读取指定设备mac地址

-(BOOL)Read_DEV_isConnected ;//判断是否在连接状态
-(BOOL)Read_DEV_isConnected:(CBPeripheral*)dev;

-(int)FindDEV:(int)timeout fiter:(BOOL)p;//查找设备，timeout：时间单位s, p为ture表示开uuid过滤，false表示关闭

-(void) connect_DEV:(CBPeripheral *)peripheral;//连接设备，peripheral为设备对象
- (void) DisConnectDev:(CBPeripheral*)peripheral;//断开连接设备，peripheral为设备对象

-(const char *) UUIDToString:(CFUUIDRef) UUID;// UUID转字符串
- (void) clearDevices;//清除设备列表

-(void)Read_DEV_Batt:(CBPeripheral*)p;//读电量


-(CBPeripheral*)Get_DEV_CBPeripheral:(NSString*)uuid;//通过uuid得到设备对象
-(NSString*)Get_DEV_UUID:(CBPeripheral*)dev;//通过设备对象得到uuid


-(void)Enable_DEV:(CBPeripheral *)p;
@end
/*
 FDQ_DEV_LIST类说明
 目前暂未开放到外部使用，
 */
#define DEV_COUNT   8
@interface FDQ_DEV_LIST : NSObject
{
    
}

-(BOOL)Get_dv_ISConnected:(int)count;//判断指定设备是否在连接状态
-(CBPeripheral*)dv_Connect:(int)count;//返回指定设备对象

//-(BOOL)Wrtie_MEM_DEV_LIST:(NSString*)dev_id p:(NSString*)address;
//-(BOOL)Read_MEM_DEV_LIST:(NSString*)address;
-(BOOL)MEM_ADD_DEV:(CBPeripheral*)cb;//将设备对象存储到数据库
-(BOOL)MEM_SUB_DEV:(CBPeripheral*)cb;//将这个对象从数据库删除
-(NSInteger*)Get_MEM_DEV_COUNT;//获取数据库已经存储的设备对象的总数目
-(CBPeripheral*)get_mem_dev_obj:(int)count;//得到指定存储设备对象


-(void)init_fdq;//初始化

@end


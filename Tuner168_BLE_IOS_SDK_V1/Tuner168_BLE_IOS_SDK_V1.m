//
//  BLE_LXXAVR.m
//  BLE_LXXAVR
//
//  Created by LXXAVR on 14-1-9.
//  Copyright (c) 2014年 LXXAVR. All rights reserved.
//

#import "Tuner168_BLE_IOS_SDK_V1.h"
#define TI_KEYFOB_PROXIMITY_ALERT_UUID                     0x5678 //0x1802
#define TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID            0x1234 //0x2a06
#define TI_KEYFOB_PROXIMITY_ALERT_ON_VAL                    0x01
#define TI_KEYFOB_PROXIMITY_ALERT_OFF_VAL                   0x00
#define TI_KEYFOB_PROXIMITY_ALERT_WRITE_LEN                 1

#define TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID             0x1111//0x1804
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID        0x1000
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_READ_LEN    1


#define TI_KEYFOB_BATT_SERVICE_UUID                         0x180F
#define TI_KEYFOB_LEVEL_SERVICE_UUID                        0x2A19
#define TI_KEYFOB_LEVEL_SERVICE_READ_LEN                    1

#define TI_KEYFOB_ACCEL_SERVICE_UUID                        0xFFA0
#define TI_KEYFOB_ACCEL_ENABLER_UUID                        0xFFA1
#define TI_KEYFOB_ACCEL_RANGE_UUID                          0xFFA2
#define TI_KEYFOB_ACCEL_READ_LEN                            1
#define TI_KEYFOB_ACCEL_X_UUID                              0xFFA3
#define TI_KEYFOB_ACCEL_Y_UUID                              0xFFA4
#define TI_KEYFOB_ACCEL_Z_UUID                              0xFFA5

#define TI_KEYFOB_KEYS_SERVICE_UUID                         0xFFE0
#define TI_KEYFOB_KEYS_NOTIFICATION_UUID                    0xFFE1
#define TI_KEYFOB_KEYS_NOTIFICATION_READ_LEN                1



#define uart_server_uuid 0x1000
#define uart_rx_uuid 0x1001
#define uart_tx_uuid 0x1002

@implementation Tuner168_BLE_IOS_SDK

@synthesize delegate;
@synthesize CM;
@synthesize activePeripheral;
/*
 @synthesize batteryLevel;
 @synthesize key1;
 @synthesize key2;
 @synthesize x;
 @synthesize y;
 @synthesize z;
 
 @synthesize TXPwrLevel;
 
 foundPeripherals
 
 */
//@synthesize TIBLEConnectBtn;

//@synthesize foundaPeripheral;
@synthesize DEV_MEM;

//@synthesize centralManager;
//@synthesize connectedPeripheral;










- (id) init
{
    self = [super init];
    if (self) {
        
		CM = [[CBCentralManager alloc] initWithDelegate:self queue:/*dispatch_get_current_queue()*/nil];
        self.DEV_MEM = [[NSMutableArray alloc] init];
        //[self.DEV_MEM removeAllObjects];
	}
    //NSLog(@"init");
    return self;
}
/*
 - (void) deallocPeripheral
 {
 if (connectedPeripheral)
 {
 [connectedPeripheral setDelegate:self];
 connectedPeripheral = nil;
 }
 }
 
 - (void) reset{
 if (connectedPeripheral) {
 connectedPeripheral = nil;
 }
 }*/


//-(void) initConnectButtonPointer:(UIButton *)b {
//    TIBLEConnectBtn = b;
//}


-(void)fefe:(Byte *)b p:(CBPeripheral *)p pp:(int)len{
    NSData *d = [[NSData alloc] initWithBytes:b length:len];
    [self writeValue:0xfff0 characteristicUUID:0xfff6 p:p data:d];
}


-(void)enable_rx_tx:(Byte*)bit
{
    
}

-(void) enable_uart_rx:(CBPeripheral *)p {
    [self notification:uart_server_uuid characteristicUUID:uart_rx_uuid p:p on:YES];
}
-(void) disable_uart_rx:(CBPeripheral *)p {
    [self notification:uart_server_uuid characteristicUUID:uart_rx_uuid p:p on:NO];
}


-(void) enable_uart_tx:(CBPeripheral *)p {
    [self notification:uart_server_uuid characteristicUUID:uart_tx_uuid p:p on:YES];
}
-(void) disable_uart_tx:(CBPeripheral *)p {
    [self notification:uart_server_uuid characteristicUUID:uart_tx_uuid p:p on:NO];
}



-(void) sbb:(Byte *)buzVal p:(CBPeripheral *)p pp:(int)len{
    
    NSData *d = [[NSData alloc] initWithBytes:buzVal length:len];
    //[self writeValue:TI_KEYFOB_PROXIMITY_ALERT_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID p:p data:d];
    [self writeValue:0x1000 characteristicUUID:0x1001 p:p data:d];
    //[self writeValue:TI_KEYFOB_PROXIMITY_ALERT_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID p:p data:d];
}

-(void) svv:(Byte*)buzVal p:(CBPeripheral *)p pp:(int)len
{
    NSData *d = [[NSData alloc] initWithBytes:buzVal length:len];
    [self writeValue1:TI_KEYFOB_PROXIMITY_ALERT_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID p:p data:d];
}

-(void) readBattery:(CBPeripheral *)p {
    [self readValue:0x1000 characteristicUUID:0x1003 p:p];
}

-(void)enable_battery:(BOOL)var p:(CBPeripheral *)p
{
    [self notification:0x1000 characteristicUUID:0x1003 p:p on:var];
}

-(void)Read_DEV_Batt:(CBPeripheral*)p
{
    [self readBattery:p];
}

//

-(void) enableAccelerometer:(CBPeripheral *)p {
    char data = 0x01;
    NSData *d = [[NSData alloc] initWithBytes:&data length:1];
    [self writeValue:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_ENABLER_UUID p:p data:d];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_X_UUID p:p on:YES];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Y_UUID p:p on:YES];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Z_UUID p:p on:YES];
    //NSLog(@"Enabling accelerometer\r\n");
}


-(void) disableAccelerometer:(CBPeripheral *)p {
    char data = 0x00;
    NSData *d = [[NSData alloc] initWithBytes:&data length:1];
    [self writeValue:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_ENABLER_UUID p:p data:d];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_X_UUID p:p on:NO];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Y_UUID p:p on:NO];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Z_UUID p:p on:NO];
    //NSLog(@"Disabling accelerometer\r\n");
}


-(void) enableButtons:(CBPeripheral *)p {
    [self notification:TI_KEYFOB_KEYS_SERVICE_UUID characteristicUUID:TI_KEYFOB_KEYS_NOTIFICATION_UUID p:p on:YES];
}
-(void) disableButtons:(CBPeripheral *)p {
    [self notification:TI_KEYFOB_KEYS_SERVICE_UUID characteristicUUID:TI_KEYFOB_KEYS_NOTIFICATION_UUID p:p on:NO];
}
-(void) enableTXPower:(CBPeripheral *)p {
    [self notification:TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID p:p on:YES];
}

-(void) disableTXPower:(CBPeripheral *)p {
    [self notification:TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID p:p on:NO];
}

-(void)disablefefe:(CBPeripheral *)p
{
    [self notification:0xfff0 characteristicUUID:0xfff6 p:p on:NO];
}
//蓝牙通讯再次握手
-(void)Enable_DEV:(CBPeripheral *)p
{
    [self enableButtons:p];
    [self enableTXPower:p];
    
    //[t enablefefe:[t activePeripheral]];
    
    [self enable_uart_rx:p];
    [self Get_DEV_CBPeripheral:@""];
    [self enable_uart_tx:p];
    
    [self enable_battery:TRUE p:p];
}

-(void) writeValue1:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        //NSLog(@"Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        //NSLog(@"Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        //NSLog(@"Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}



-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        //NSLog(@"Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}



-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}
//搜索蓝牙设备
-(int)FindDEV:(int)timeout fiter:(BOOL)p{
    if (self->CM.state  != CBCentralManagerStatePoweredOn)
    {
        //NSLog(@"CoreBluetooth not correctly initialized !\r\n");
        // NSLog(@"State = %d (%s)\r\n",self->CM.state,[self centralManagerStateToString:self.CM.state]);
        return -1;
    }
    if(p)
    {
        NSString *kLinkServicesUUID = @"1000";
        NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kLinkServicesUUID], nil];
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        [self.CM scanForPeripheralsWithServices:uuidArray options:options];
    }
    else
    {
        [self.CM scanForPeripheralsWithServices:nil options:0];
    }
    if(timeout!=0)
    {
        [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    }
    return 0;
}


//- (int) FindDev:(int) timeout {
//    
//    if (self->CM.state  != CBCentralManagerStatePoweredOn)
//    {
//        //NSLog(@"CoreBluetooth not correctly initialized !\r\n");
//        // NSLog(@"State = %d (%s)\r\n",self->CM.state,[self centralManagerStateToString:self.CM.state]);
//        return -1;
//    }
//    NSString *kLinkServicesUUID = @"1000";
//    NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kLinkServicesUUID], nil];
//	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
//	[self.CM scanForPeripheralsWithServices:uuidArray options:options];
//    // [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
//    //[self.CM scanForPeripheralsWithServices:nil options:0];
//    return 0;
//}
//链接设备
- (void) connect_DEV:(CBPeripheral *)peripheral {
    //NSLog(@"Connecting to peripheral with UUID : %s\r\n",[self UUIDToString:peripheral.UUID]);
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [CM connectPeripheral:activePeripheral options:nil];
    
}
//断开链接
- (void) DisConnectDev:(CBPeripheral*)peripheral
{
//    [self deallocPeripheral];
	[CM cancelPeripheralConnection:peripheral];
}

//清空设备
- (void) clearDevices
{
//    NSArray	*servicearray;
    [self.DEV_MEM removeAllObjects];
//    for (servicearray in self.DEV_MEM) {
//        [self reset];
//    }
//    [self.DEV_MEM removeAllObjects];
}

- (const char *) centralManagerStateToString: (int)state{
    switch(state) {
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}


- (void) scanTimer:(NSTimer *)timer {
    [self.CM stopScan];
    //NSLog(@"Stopped Scanning\r\n");
    //NSLog(@"Known peripherals : %d\r\n",[self->peripherals count]);
    [self printKnownPeripherals];
}

- (void) printKnownPeripherals {
    /*int i;
     //NSLog(@"List of currently known peripherals : \r\n");
     for (i=0; i < self->peripherals.count; i++)
     {
     CBPeripheral *p = [self->peripherals objectAtIndex:i];
     //        CFStringRef s = CFUUIDCreateString(NULL, p.UUID);
     //        NSLog(@"%d  |  %s\r\n",i,CFStringGetCStringPtr(s, 0));
     [self printPeripheralInfo:p];
     }*/
}

- (void) printPeripheralInfo:(CBPeripheral*)peripheral {
    /*
     CFStringRef s = CFUUIDCreateString(NULL, peripheral.UUID);
     NSLog(@"------------------------------------\r\n");
     NSLog(@"Peripheral Info :\r\n");
     NSLog(@"UUID : %s\r\n",CFStringGetCStringPtr(s, 0));
     NSLog(@"RSSI : %d\r\n",[peripheral.RSSI intValue]);
     NSLog(@"Name : %@\r\n",peripheral.name);
     NSLog(@"isConnected : %d\r\n",peripheral.isConnected);
     NSLog(@"-------------------------------------\r\n");
     */
}
//-(BOOL)Get_Link_Status{
//    
//}

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}

-(void) getAllServicesFromKeyfob:(CBPeripheral *)p{
    //    [TIBLEConnectBtn setTitle:@"Discovering services.." forState:UIControlStateNormal];
    [p discoverServices:nil];
}

-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    //    [TIBLEConnectBtn setTitle:@"Discovering characteristics.." forState:UIControlStateNormal];
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        //NSLog(@"Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}



-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}



-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}


-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}

-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}


-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}


-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil;
}


-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil;
}

-(NSString*)Get_Dev_Name{
    return [activePeripheral name];
}
-(NSString*)Get_Dev_Name :(CBPeripheral *)cb{
    return [cb name];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    //lxxavr NSLog(@"Status of CoreBluetooth central manager changed %d (%s)\r\n",central.state,[self centralManagerStateToString:central.state]);
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
//    //NSLog(@"start-------%@",[peripheral name]);
//    NSString *uuid=[advertisementData objectForKey: @"kCBAdvDataServiceUUIDs"];
//    //NSLog(@"uuid-------%@",uuid);
//    //NSMutableArray *s1=[[NSMutableArray alloc]init];
//    NSString *s1=(NSString*)[advertisementData objectForKey: @"kCBAdvDataManufacturerData"] ;
//    //NSLog(@"ff===%@",s11);
//    
//    NSMutableString* nsmstring=[NSMutableString stringWithString:@"\n"];
//    NSLog(@"adverisement:%@",advertisementData);
//    [nsmstring appendFormat:@"adverisement:%@",advertisementData];
//    [nsmstring appendString:@"didDiscoverPeripheral\n"];
//    NSLog(@"%@",nsmstring);
//    
//    NSString *strin=peripheral.UUID;
//    [delegate DEV_Broadcast_Data:peripheral brd:s1 uuid:uuid];
//    NSString *dd=[advertisementData objectForKey: @"kCBAdvDataManufacturerData"] ;
//    dd=[NSString stringWithFormat:@"%@",dd];
//    
//    if(dd)
//    NSLog(@"ff==df==df===%@",dd);
    
    
    /*
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"\n"];
    [nsmstring appendString:@"Peripheral Info:"];
    [nsmstring appendFormat:@"NAME: %@\n",peripheral.name];
    [nsmstring appendFormat:@"RSSI: %@\n",RSSI];
    
    if (peripheral.isConnected){
        [nsmstring appendString:@"isConnected: connected"];
    }else{
        [nsmstring appendString:@"isConnected: disconnected"];
    }
    NSLog(@"adverisement:%@",advertisementData);
    [nsmstring appendFormat:@"adverisement:%@",advertisementData];
    [nsmstring appendString:@"didDiscoverPeripheral\n"];
    NSLog(@"%@",nsmstring);
    */
    //NSString *name=[peripheral name];
    if(1)// [name isEqualToString:@"Ble_Light"])//t1 )
    {
        if (![self->DEV_MEM containsObject:peripheral] )
        {
            //int len=[peripheral.name length];
            //NSString *gg=[peripheral name];
            // if((len>=8)&&(/gg==@"BT4.0---Tuner"/1) )
            // {
            [self->DEV_MEM addObject:peripheral];
            //foundaPeripheral =peripheral;
            //foundaPeripheral.delegate = self;
            // NSString *ss=[peripheral name];
            //NSLog(@"发现一个广播设备: %@\n",ss);
            //NSLog(@"当前找到的设备数量: %d\n",(int)[self->foundPeripherals count]);
            //NSLog(@"当前找到的设备数量: %@\n",foundPeripherals);
            
            [[self delegate] DEV_List_fresh];
            // }
            
        }
        //[peripheral  readRSSI];
        //NSLog(@"rssi=%@",[RSSI stringValue]);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // NSLog(@"Connection to peripheral with UUID : %s successfull\r\n",[self UUIDToString:peripheral.UUID]);
    self.activePeripheral = peripheral;
    [self.activePeripheral discoverServices:nil];
    [central stopScan];
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [delegate disconnect:peripheral error:error];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
        //NSLog(@"Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
        for(int i=0; i < service.characteristics.count; i++)
        {
            //            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            //            NSLog(@"Found characteristic %s\r\n",[ self CBUUIDToString:c.UUID]);
            CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
            if([self compareCBUUID:service.UUID UUID2:s.UUID]) {
                //NSLog(@"Finished discovering characteristics");
                [[self delegate] BLE_DEV_RD:peripheral error:error];
                [self Enable_DEV:peripheral];
            }
        }
    }
    else {
        // NSLog(@"Characteristic discorvery unsuccessfull !\r\n");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (!error) {
        //NSLog(@"Services of peripheral with UUID : %s found\r\n",[self UUIDToString:peripheral.UUID]);
        [self getAllCharacteristicsFromKeyfob:peripheral];
    }
    else {
        //NSLog(@"Service discovery was unsuccessfull !\r\n");
    }
    // NSLog(@"777777777\r\n");
    
}
-(void)uart:(Byte *)b p:(CBPeripheral *)p pp:(int)len;
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (!error) {
        //NSLog(@"Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
    }
    else {
        //NSLog(@"Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
        //NSLog(@"Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
}
-(int)Read_RSSI
{
    [[self activePeripheral] readRSSI];
    int rs=[[self activePeripheral].RSSI intValue];
    return rs;
}

-(int)Read_RSSI:(CBPeripheral*)pheral
{
    [pheral readRSSI];
    int rs=[pheral.RSSI intValue];
    
    return rs;
}

-(NSString*)Read_DEV_UUID//:(CBPeripheral*)pheral
{
    NSString*strNSString = [[NSString alloc] initWithUTF8String:[self UUIDToString:[[self activePeripheral] UUID]]];
    return strNSString;
}
-(NSString*)Read_DEV_UUID:(CBPeripheral*)pheral
{
    NSString*strNSString = [[NSString alloc] initWithUTF8String:[self UUIDToString:[pheral UUID]]];
    return strNSString;
}

-(NSString*)Read_DEV_MAC{
    NSString*strNSString = [[NSString alloc] initWithUTF8String:[self UUIDToString:[[self activePeripheral] UUID]]];
    return [strNSString substringFromIndex:29];
}

-(NSString*)Read_DEV_MAC:(CBPeripheral*)pheral
{
    NSString*strNSString = [[NSString alloc] initWithUTF8String:[self UUIDToString:[pheral UUID]]];
    return [strNSString substringFromIndex:29];
}


-(CBPeripheral*)Get_DEV_CBPeripheral:(NSString*)uuid;
{
    CBPeripheral *cb;
    //NSString *STT=@"56FB4A44-3C1A-0810-FEC4-4D45777E27A4";//@"11DD96DA-DD21-D71A-1B72-C9E4E2837F14";
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:uuid];
    //CBCentralManager *cbmg=[[CBCentralManager alloc]init];
    if(nsUUID)
    {
        NSArray *peripheralArray = [[self CM] retrievePeripheralsWithIdentifiers:@[nsUUID]];
        CBPeripheral *dev_perpheral;
        if([peripheralArray count] > 0)
        {
            for(CBPeripheral *peripheral in peripheralArray)
            {
                NSLog(@"Connecting to Peripheral - %@", peripheral);
                dev_perpheral=peripheral;
            }
            //[t connectPeripheral:dev_perpheral];
            cb=dev_perpheral;
        }
    }
    return cb;
}

-(NSString*)Get_DEV_UUID:(CBPeripheral*)dev
{
    NSString*str;
    str = [[NSString alloc] initWithUTF8String:[self UUIDToString:[dev UUID]]];
    return str;
}


-(BOOL)Read_DEV_isConnected
{
    if([self activePeripheral].isConnected){
        return TRUE;
    }else{
        return FALSE;
    }
}
-(BOOL)Read_DEV_isConnected:(CBPeripheral*)dev
{
    if(dev.isConnected){
        return TRUE;
    }else{
        return FALSE;
    }
}


-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

-(BOOL)Send_Data:(NSString*)Str_data :(CBPeripheral *)cb
{
    if (cb==nil) {
        return false;
    }else{
        
        if([Str_data length]>0);
        else return FALSE;
        Str_data=[NSString stringWithFormat:@"54%@",Str_data];
        NSData *da2=[self stringToByte:Str_data];
        Byte *testbyte=(Byte*)[da2 bytes];
        NSLog(@"hh=%@",Str_data);
        
        int len=(int)[da2 length];
        int le=len-1;
        Byte bb[20];
        bb[0]=0x54;
        unsigned char j=255*rand();
        bb[1]=0X54^(le+1);
        bb[2]=0x54^j;
        for(int iv=0;iv<le;iv++)
        {
            bb[iv+3]=testbyte[1+iv]^j;
        }
        //[t sbb:testbyte p:[t activePeripheral] pp:(int)([da2 length])];
        [self sbb:bb p:cb pp:len+2];
        return TRUE;
    }
}

-(BOOL)Send_Data:(NSString*)Str_data
{
    if([Str_data length]>0);
    else return FALSE;
    Str_data=[NSString stringWithFormat:@"54%@",Str_data];
    NSData *da2=[self stringToByte:Str_data];
    Byte *testbyte=(Byte*)[da2 bytes];
    NSLog(@"hh=%@",Str_data);
    
    int len=(int)[da2 length];
    int le=len-1;
    Byte bb[20];
    bb[0]=0x54;
    unsigned char j=255*rand();
    bb[1]=0X54^(le+1);
    bb[2]=0x54^j;
    for(int iv=0;iv<le;iv++)
    {
        bb[iv+3]=testbyte[1+iv]^j;
    }
    //[t sbb:testbyte p:[t activePeripheral] pp:(int)([da2 length])];
    [self sbb:bb p:[self activePeripheral] pp:len+2];
    
    return TRUE;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    
     NSString *st=[NSString stringWithFormat:@"%hu",characteristicUUID];
//     NSLog(@"lxxavr:uuid %@\r\n",st);
//     NSLog(@"lxxavr:uuid %@\r\n",st);
    
    if (!error) {
        switch(characteristicUUID){
            case 0x1002:
            {
                NSLog(@"有数据接收－－－－ble:uuid %@\r\n",st);
                char TXLevel[20];
                char YY[17];
                [characteristic.value getBytes:TXLevel length:20];
                int ii=0;
                if(TXLevel[0]=='T')
                {
                    ii=(TXLevel[1]^0x54)-1;
                }
                unsigned char ghg=(TXLevel[2]^0x54)&0xff;
                if(ii<=17)
                {
                    for(int y=0;y<ii;y++)
                    {
                        YY[y]=TXLevel[3+y]^ghg;
                    }
                    NSData *adata = [[NSData alloc] initWithBytes:YY length:ii];
                    [[self delegate] Receive_Data_Event:adata p:ii DEV:peripheral];
                }
                break;
            }
            case 0x1003:
            {
                char TXLevel[20];
                //char YY[17];
                [characteristic.value getBytes:TXLevel length:20];
                int ii=0;
                NSData *adata = [[NSData alloc] initWithBytes:TXLevel length:20];
                [[self delegate] Receive_Batt_Event:adata p:ii DEV:peripheral];
                /*
                if(TXLevel[0]=='T')
                {
                    ii=(TXLevel[1]^0x54)-1;
                }
                unsigned char ghg=(TXLevel[2]^0x54)&0xff;
                if(ii<=17)
                {
                    for(int y=0;y<ii;y++)
                    {
                        YY[y]=TXLevel[3+y]^ghg;
                    }
                    NSData *adata = [[NSData alloc] initWithBytes:YY length:ii];
                    [[self delegate] Receive_Batt_Event:adata p:ii DEV:peripheral];
                    
                }*/
                break;
            }
            default:
            {
                
            }
                
        }
    }
    else {
        
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
}


@end



@interface FDQ_DEV_LIST()
{
    CBPeripheral *fdq_dv[DEV_COUNT];//
    
    NSMutableArray*dec_mutable_array_list;//uuid
    //NSMutableArray*dec_nane_array_list;//
}
@end
@implementation FDQ_DEV_LIST
-(BOOL)Get_dv_ISConnected:(int)count
{
    if(fdq_dv[count].isConnected)return TRUE;
    else return FALSE;
}

-(CBPeripheral*)dv_Connect:(int)count
{
    return fdq_dv[count];
}

-(BOOL)Wrtie_MEM_DEV_LIST:(NSString*)dev_id p:(NSString*)address
{
    return FALSE;
}
-(BOOL)Read_MEM_DEV_LIST:(NSString*)address
{
    return FALSE;
}

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

-(BOOL)MEM_ADD_DEV:(CBPeripheral*)cb
{
    NSString *uuid= [[NSString alloc] initWithUTF8String:[self UUIDToString:[cb UUID]]];
    
    dec_mutable_array_list=nil;
    dec_mutable_array_list=[self mem_read_data];
    if( ![dec_mutable_array_list containsObject:uuid] )
    {
        [dec_mutable_array_list addObject:uuid];
        [self mem_write_dada:dec_mutable_array_list];
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
    return 0;
}

-(BOOL)MEM_SUB_DEV:(CBPeripheral*)cb
{
    int select=99;
    NSString *uuid= [[NSString alloc] initWithUTF8String:[self UUIDToString:[cb UUID]]];
    for(int i=0;i<dec_mutable_array_list.count;i++)
    {
        NSString *str=[dec_mutable_array_list objectAtIndex:i];
        if([str isEqualToString:uuid] )
        {
            select=i;
            break;
        }
    }
    if(select!=99)
    {
        [self mem_write_dada:dec_mutable_array_list];
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

-(NSInteger*)Get_MEM_DEV_COUNT
{
    NSInteger *count;
    count=(NSInteger*)[dec_mutable_array_list count];
    return count;
}

-(void)mem_write_dada:(NSMutableArray*)arr
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:arr forKey:@"BLE_DEV_UUID"];
    [defaults synchronize];
}

-(NSMutableArray*)mem_read_data
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    arr=[defaults objectForKey:@"BLE_DEV_UUID"];
    [defaults synchronize];
    return arr;
}

-(CBPeripheral*)get_mem_dev_obj:(int)count
{
    CBPeripheral *dev_perpheral=nil;
    CBCentralManager *cbmg=[[CBCentralManager alloc]init];
    
    int cnt=(int)dec_mutable_array_list.count;
    
    if( (count-1)<=cnt )
    {
        NSUUID *nsUUID=[dec_mutable_array_list objectAtIndexedSubscript:count];
        if(nsUUID)
        {
            NSArray *peripheralArray = [cbmg retrievePeripheralsWithIdentifiers:@[nsUUID]];
            if([peripheralArray count] > 0)
            {
                for(CBPeripheral *peripheral in peripheralArray)
                {
                    NSLog(@"Connecting to Peripheral - %@", peripheral);
                    dev_perpheral=peripheral;
                }
                //[t connectPeripheral:dev_perpheral];
            }
        }
    }
    return dev_perpheral;
}

-(void)init_fdq
{
    dec_mutable_array_list=[[NSMutableArray alloc]init];
    dec_mutable_array_list=[self mem_read_data];
    
    
}

@end

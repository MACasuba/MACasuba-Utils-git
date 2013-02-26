//
//  EAAccessoryManager.h
//  ExternalAccessory
//
//  Copyright 2008 Apple, Inc. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

// EAAccessoryManager Notifications
EA_EXTERN NSString *const EAAccessoryDidConnectNotification __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
EA_EXTERN NSString *const EAAccessoryDidDisconnectNotification __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
// Keys in the EAAccessoryDidConnectNotification/EAAccessoryDidDisconnectNotification userInfo
EA_EXTERN NSString *const EAAccessoryKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0); // EAAccessory

@class EAAccessory;

EA_EXTERN_CLASS @interface EAAccessoryManager : NSObject {
@private
    NSMutableArray *_connectedAccessories;
}

+ (EAAccessoryManager *)sharedAccessoryManager __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

- (void)registerForLocalNotifications __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
- (void)unregisterForLocalNotifications __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property (nonatomic, readonly) NSArray *connectedAccessories __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end

#endif // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

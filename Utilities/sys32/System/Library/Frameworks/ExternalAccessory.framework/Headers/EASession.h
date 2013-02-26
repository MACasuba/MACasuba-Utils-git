//
//  EASession.h
//  ExternalAccessory
//
//  Copyright 2008 Apple Inc.. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@class EAAccessory;

EA_EXTERN_CLASS @interface EASession : NSObject {
@private
    EAAccessory *_accessory;
    NSUInteger _sessionID;
    NSString *_protocolString;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
}

- (id)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocolString __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property (nonatomic, readonly) EAAccessory *accessory __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@property (nonatomic, readonly) NSString *protocolString __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@property (nonatomic, readonly) NSInputStream *inputStream __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@property (nonatomic, readonly) NSOutputStream *outputStream __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@end

#endif // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

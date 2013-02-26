//
//  SKProduct.h
//  StoreKit
//
//  Copyright 2009 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKitDefines.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

SK_EXTERN_CLASS @interface SKProduct : NSObject {
@private
    id _internal;
}

@property(nonatomic, readonly) NSString *localizedDescription __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property(nonatomic, readonly) NSString *localizedTitle __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property(nonatomic, readonly) NSDecimalNumber *price __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property(nonatomic, readonly) NSLocale *priceLocale __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property(nonatomic, readonly) NSString *productIdentifier __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end

#endif // __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

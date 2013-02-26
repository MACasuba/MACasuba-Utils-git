//
//  SKPayment.h
//  StoreKit
//
//  Copyright 2009 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKitDefines.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@class SKProduct;

SK_EXTERN_CLASS @interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
@private
    id _internal;
}

+ (id)paymentWithProduct:(SKProduct *)product __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
+ (id)paymentWithProductIdentifier:(NSString *)identifier __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Identifier agreed upon with the store.  Required.
@property(nonatomic, copy, readonly) NSString *productIdentifier __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Payment request data agreed upon with the store.  Optional.
@property(nonatomic, copy, readonly) NSData *requestData __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// default: 1.  Must be at least 1.
@property(nonatomic, readonly) NSInteger quantity __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end


SK_EXTERN_CLASS @interface SKMutablePayment : SKPayment {
}

@property(nonatomic, copy, readwrite) NSString *productIdentifier __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@property(nonatomic, readwrite) NSInteger quantity __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@property(nonatomic, copy, readwrite) NSData *requestData __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end

#endif // __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

//
//  SKProductsRequest.h
//  StoreKit
//
//  Copyright 2009 Apple, Inc. All rights reserved.
//

#import <StoreKit/SKRequest.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@protocol SKProductsRequestDelegate;

// request information about products for your application
SK_EXTERN_CLASS @interface SKProductsRequest : SKRequest {
@private
    id _productsRequestInternal;
}

// Set of string product identifiers
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property(nonatomic, assign) id <SKProductsRequestDelegate> delegate __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end


SK_EXTERN_CLASS @interface SKProductsResponse : NSObject {
@private
    id _internal;
}

// Array of SKProduct instances.
@property(nonatomic, readonly) NSArray *products __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Array of invalid product identifiers.
@property(nonatomic, readonly) NSArray *invalidProductIdentifiers __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end


@protocol SKProductsRequestDelegate <SKRequestDelegate>

@required
// Sent immediately before -requestDidFinish:
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end

#endif // __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

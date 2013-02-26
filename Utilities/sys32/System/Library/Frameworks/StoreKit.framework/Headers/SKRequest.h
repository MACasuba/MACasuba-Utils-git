//
//  SKRequest.h
//  StoreKit
//
//  Copyright 2009 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKitDefines.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@protocol SKRequestDelegate;

// Base class used to fetch data from the store.  Should not be used directly.
SK_EXTERN_CLASS @interface SKRequest : NSObject {
@private
    id _requestInternal;
}

@property(nonatomic, assign) id <SKRequestDelegate> delegate __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Cancel the request if it has started.
- (void)cancel __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Start the request if it has not already been started.
- (void)start __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end


@protocol SKRequestDelegate <NSObject>

@optional
- (void)requestDidFinish:(SKRequest *)request __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end

#endif // __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

//
//  UIEvent.h
//  UIKit
//
//  Copyright 2005-2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>

@class UIWindow, UIView, UIGestureRecognizer;

typedef enum {
    UIEventTypeTouches,
    UIEventTypeMotion,
} UIEventType;

typedef enum {
    UIEventSubtypeNone        = 0,  // available in iPhone 3.0
    UIEventSubtypeMotionShake = 1,  // for UIEventTypeMotion. 		// available in iPhone 3.0
} UIEventSubtype;

UIKIT_EXTERN_CLASS @interface UIEvent : NSObject
{
  @private
    NSTimeInterval _timestamp;
}

@property(nonatomic,readonly) UIEventType     type __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
@property(nonatomic,readonly) UIEventSubtype  subtype __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@property(nonatomic,readonly) NSTimeInterval  timestamp;

- (NSSet *)allTouches;
- (NSSet *)touchesForWindow:(UIWindow *)window;
- (NSSet *)touchesForView:(UIView *)view;
- (NSSet *)touchesForGestureRecognizer:(UIGestureRecognizer *)gesture __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2);

@end

//
//  UITouch.h
//  UIKit
//
//  Copyright 2007-2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>

@class UIWindow, UIView;

typedef enum {
    UITouchPhaseBegan,             // whenever a finger touches the surface.
    UITouchPhaseMoved,             // whenever a finger moves on the surface.
    UITouchPhaseStationary,        // whenever a finger is touching the surface but hasn't moved since the previous event.
    UITouchPhaseEnded,             // whenever a finger leaves the surface.
    UITouchPhaseCancelled,         // whenever a touch doesn't end but we need to stop tracking (e.g. putting device to face)
} UITouchPhase;

UIKIT_EXTERN_CLASS @interface UITouch : NSObject
{
  // Note: all instance variables will become private in the future. Do not access directly.
    NSTimeInterval  _timestamp;
    UITouchPhase    _phase;
    UITouchPhase    _savedPhase;
    NSUInteger      _tapCount;

    UIWindow        *_window;
    UIView          *_view;
    UIView          *_gestureView;
    NSMutableArray  *_gestureRecognizers;

    CGPoint         _locationInWindow;
    CGPoint         _previousLocationInWindow;
    UInt8           _pathIndex;
    UInt8           _pathIdentity;
    float           _pathMajorRadius;
    struct {
        unsigned int _firstTouchForView:1;
        unsigned int _isTap:1;
        unsigned int _isWarped:1;
        unsigned int _isDelayed:1;
        unsigned int _sentTouchesEnded:1;
    } _touchFlags;
}

@property(nonatomic,readonly) NSTimeInterval      timestamp;
@property(nonatomic,readonly) UITouchPhase        phase;
@property(nonatomic,readonly) NSUInteger          tapCount;   // touch down within a certain point within a certain amount of time

@property(nonatomic,readonly,retain) UIWindow    *window;
@property(nonatomic,readonly,retain) UIView      *view;
@property(nonatomic,readonly,copy)   NSArray     *gestureRecognizers __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2);

- (CGPoint)locationInView:(UIView *)view;
- (CGPoint)previousLocationInView:(UIView *)view;

@end

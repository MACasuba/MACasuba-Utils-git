//
//  UILongPressGestureRecognizer.h
//  UIKit
//
//  Copyright 2008-2010 Apple Inc. All rights reserved.
//

#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import <Foundation/Foundation.h>

#import <UIKit/UIGestureRecognizer.h>
#import <CoreGraphics/CoreGraphics.h>

// Begins:  when numberOfTouchesRequired have tapped numberOfTapsRequired times and been held for minumPressDuration
// Changes: when a finger moves
// Ends:    when a finger is lifted

UIKIT_EXTERN_CLASS @interface UILongPressGestureRecognizer : UIGestureRecognizer {
  @package
    NSArray          *_touches;
    NSMutableSet     *_activeTouches;
    NSInteger         _numberOfTouchesRequired;
    CFTimeInterval    _delay;
    CGFloat           _allowableMovement;
    CGPoint           _startPointScreen;
    id                _enoughTimeElapsed;
    id                _tooMuchTimeElapsed;
    id                _imp;
    
    unsigned int      _gotTouchEnd:1;
    unsigned int      _gotTooMany:1;
    unsigned int      _gotEnoughTaps:1;
    unsigned int      _cancelPastAllowableMovement:1;
}

@property (nonatomic) NSInteger numberOfTapsRequired;      // Default is 0. The number of full taps required before the press for gesture to be recognized
@property (nonatomic) NSInteger numberOfTouchesRequired;   // Default is 1. Number of fingers that must be held down for the gesture to be recognized

@property (nonatomic) CFTimeInterval minimumPressDuration; // Default is 0.5. Time in seconds the fingers must be held down for the gesture to be recognized
@property (nonatomic) CGFloat allowableMovement;           // Default is 10. Maximum movement in pixels allowed before the gesture fails. Once recognized (after minimumPressDuration) there is no limit on finger movement for the remainder of the touch tracking

@end

#endif

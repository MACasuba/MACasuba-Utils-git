//
//  UIDataDetectors.h
//  UIKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#if __IPHONE_3_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

enum {
    UIDataDetectorTypePhoneNumber   = 1 << 0,          // Phone number detection
    UIDataDetectorTypeLink          = 1 << 1,          // URL detection
    
    UIDataDetectorTypeNone          = 0,               // No detection at all
    UIDataDetectorTypeAll           = NSUIntegerMax    // All types
};

typedef NSUInteger UIDataDetectorTypes;

#endif

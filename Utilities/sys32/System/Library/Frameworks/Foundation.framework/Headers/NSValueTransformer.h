/*	NSValueTransformer.h
        Copyright (c) 2002-2007, Apple Inc. All rights reserved.
*/

#import <Foundation/NSObject.h>
#import <Availability.h>

#if MAC_OS_X_VERSION_10_3 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_3_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

@class NSArray, NSString;

FOUNDATION_EXPORT NSString * const NSNegateBooleanTransformerName	__OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_3_0);
FOUNDATION_EXPORT NSString * const NSIsNilTransformerName		__OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_3_0);
FOUNDATION_EXPORT NSString * const NSIsNotNilTransformerName		__OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_3_0);
FOUNDATION_EXPORT NSString * const NSUnarchiveFromDataTransformerName		__OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_3_0);
FOUNDATION_EXPORT NSString * const NSKeyedUnarchiveFromDataTransformerName		__OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_3_0);

@interface NSValueTransformer : NSObject {
}

// name-based registry for shared objects (especially used when loading nib files with transformers specified by name in Interface Builder) - also useful for localization (developers can register different kind of transformers or differently configured transformers at application startup and refer to them by name from within nib files or other code)
// if valueTransformerForName: does not find a registered transformer instance, it will fall back to looking up a class with the specified name - if one is found, it will instantiate a transformer with the default -init method and automatically register it
+ (void)setValueTransformer:(NSValueTransformer *)transformer forName:(NSString *)name;
+ (NSValueTransformer *)valueTransformerForName:(NSString *)name;
+ (NSArray *)valueTransformerNames;

// information that can be used to analyze available transformer instances (especially used inside Interface Builder)
+ (Class)transformedValueClass;    // class of the "output" objects, as returned by transformedValue:
+ (BOOL)allowsReverseTransformation;    // flag indicating whether transformation is read-only or not

- (id)transformedValue:(id)value;           // by default returns value
- (id)reverseTransformedValue:(id)value;    // by default raises an exception if +allowsReverseTransformation returns NO and otherwise invokes transformedValue:

@end

#endif

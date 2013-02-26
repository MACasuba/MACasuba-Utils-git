//
//  MKAnnotation.h
//  MapKit
//
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@protocol MKAnnotation <NSObject>

// Center latitude and longitude of the annotion view.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

// Title and subtitle for use by selection UI.
- (NSString *)title;
- (NSString *)subtitle;

@end

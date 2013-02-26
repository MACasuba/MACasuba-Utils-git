//
//  MKGeometry.h
//  MapKit
//
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>


typedef struct {
    CLLocationDegrees latitudeDelta;
    CLLocationDegrees longitudeDelta;
} MKCoordinateSpan;

typedef struct {
	CLLocationCoordinate2D center;
	MKCoordinateSpan span;
} MKCoordinateRegion;


UIKIT_STATIC_INLINE MKCoordinateSpan MKCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
{
    MKCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

UIKIT_STATIC_INLINE MKCoordinateRegion MKCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, MKCoordinateSpan span)
{
	MKCoordinateRegion region;
	region.center = centerCoordinate;
    region.span = span;
	return region;
}

UIKIT_EXTERN MKCoordinateRegion MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters);


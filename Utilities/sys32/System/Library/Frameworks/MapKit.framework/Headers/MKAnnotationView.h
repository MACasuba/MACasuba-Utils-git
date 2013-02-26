//
//  MKAnnotationView.h
//  MapKit
//
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Post this notification to re-query callout information.
UIKIT_EXTERN NSString *MKAnnotationCalloutInfoDidChangeNotification;

@class MKAnnotationViewInternal;
@protocol MKAnnotation;

@interface MKAnnotationView : UIView
{
@private
    MKAnnotationViewInternal *_internal;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly) NSString *reuseIdentifier;

// Classes that override must call super.
- (void)prepareForReuse;

@property (nonatomic, retain) id <MKAnnotation> annotation;

@property (nonatomic, retain) UIImage *image;

// By default, the center of annotation view is placed over the coordinate of the annotation.
// centerOffset is the offset in pixels from the center of the annotion view.
@property (nonatomic) CGPoint centerOffset;

// calloutOffset is the offset in pixels from the top-middle of the annotation view, where the anchor of the callout should be shown.
@property (nonatomic) CGPoint calloutOffset;

// Defaults to YES. If NO, ignores touch events and subclasses may draw differently.
@property (nonatomic, getter=isEnabled) BOOL enabled;

// Defaults to NO. This gets set/cleared automatically when touch enters/exits during tracking and cleared on up.
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

// Defaults to NO. Becomes YES when tapped on in the map view.
@property (nonatomic, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

// If YES, a standard callout bubble will be shown when the annotation is selected.
// The annotation must have a title for the callout to be shown.
@property (nonatomic) BOOL canShowCallout;

// The left accessory view to be used in the standard callout.
@property (retain, nonatomic) UIView *leftCalloutAccessoryView;

// The right accessory view to be used in the standard callout.
@property (retain, nonatomic) UIView *rightCalloutAccessoryView;


@end

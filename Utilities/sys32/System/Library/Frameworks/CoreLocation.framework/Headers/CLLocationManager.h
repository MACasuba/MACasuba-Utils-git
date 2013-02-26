
/*
 *  CLLocationManager.h
 *  CoreLocation
 *
 *  Copyright 2008 Apple Computer, Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class CLLocation;
@protocol CLLocationManagerDelegate;

/*
 *  CLLocationManager
 *  
 *  Discussion:
 *    The CLLocationManager object is your entry point to the location service.
 */
@interface CLLocationManager : NSObject
{
@private
	id _internal;
}

@property(assign, nonatomic) id<CLLocationManagerDelegate> delegate;

/*
 *  locationServicesEnabled
 *  
 *  Discussion:
 *      Determines whether the user has location services enabled on the device (Settings -> General -> Location Services).
 *      If NO, and you proceed to call other CoreLocation API, user will be prompted with the warning
 *      dialog. You may want to check this property and use location services only when explicitly requested by the user.
 */
@property(readonly, nonatomic) BOOL locationServicesEnabled;

/*
 *  purpose
 *  
 *  Discussion:
 *      Allows the application to specify what location will be used for in their app. This
 *      will be displayed along with the standard Location permissions dialogs. This property will need to be
 *      set prior to calling startUpdatingLocation.
 */
@property(copy, nonatomic) NSString *purpose __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2);

/*
 *  distanceFilter
 *  
 *  Discussion:
 *      Specifies the minimum update distance in meters. Client will not be notified of movements of less 
 *      than the stated value, unless the accuracy has improved. Pass in kCLDistanceFilterNone to be 
 *      notified of all movements. By default, kCLDistanceFilterNone is used.
 */
@property(assign, nonatomic) CLLocationDistance distanceFilter;

/*
 *  desiredAccuracy
 *  
 *  Discussion:
 *      The desired location accuracy. The location service will try its best to achieve
 *      your desired accuracy. However, it is not guaranteed. To optimize
 *      power performence, be sure to specify an appropriate accuracy for your usage scenario (eg,
 *      use a large accuracy value when only a coarse location is needed). Use kCLLocationAccuracyBest to
 *      achieve the best possible accuracy. By default, kCLLocationAccuracyBest is used.
 */
@property(assign, nonatomic) CLLocationAccuracy desiredAccuracy;

/*
 *  lastLocation
 *  
 *  Discussion:
 *      The last location received. Will be nil until a location has been received.
 */
@property(readonly, nonatomic) CLLocation *location;

/*
 *  startUpdatingLocation
 *  
 *  Discussion:
 *      Start updating locations.
 */
- (void)startUpdatingLocation;

/*
 *  stopUpdatingLocation
 *  
 *  Discussion:
 *      Stop updating locations.
 */
- (void)stopUpdatingLocation;

/*
 *  headingFilter
 *  
 *  Discussion:
 *      Specifies the minimum amount of change in degrees needed for a heading service update. Client will not
 *      be notified of movements of less than the stated value. Pass in kCLHeadingFilterNone to be
 *      notified of all movements. By default, kCLHeadingFilterNone is used.
 */
@property(assign, nonatomic) CLLocationDegrees headingFilter __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

/*
 *  headingAvailable
 *
 *  Discussion:
 *      Returns YES if the device supports the heading service, otherwise NO.
 */
@property(readonly, nonatomic) BOOL headingAvailable __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

/*
 *  startUpdatingHeading
 *
 *  Discussion:
 *      Start updating heading.
 */
- (void)startUpdatingHeading __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

/*
 *  stopUpdatingHeading
 *
 *  Discussion:
 *      Stop updating heading.
 */
- (void)stopUpdatingHeading __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

/*
 *  dismissHeadingCalibrationDisplay
 *  
 *  Discussion:
 *      Dismiss the heading calibration immediately.
 */
- (void)dismissHeadingCalibrationDisplay __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

@end

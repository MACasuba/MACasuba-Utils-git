
/*
 *  CLLocationManagerDelegate.h
 *  CoreLocation
 *
 *  Copyright 2008 Apple Computer, Inc. All rights reserved.
 *
 */

#import <Availability.h>
#import <Foundation/Foundation.h>

@class CLLocation;
@class CLHeading;
@class CLLocationManager;

/*
 *  CLLocationManagerDelegate
 *  
 *  Discussion:
 *    Delegate for CLLocationManager.
 */
@protocol CLLocationManagerDelegate<NSObject>

@optional

/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *  
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 */
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation;

/*
 *  locationManager:didUpdateHeading:
 *  
 *  Discussion:
 *    Invoked when a new heading is available.
 */
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

/*
 *  locationManager:shouldDisplayHeadingCalibrationForDuration:
 *
 *  Discussion:
 *    Invoked when a new heading is available. Return YES to display heading calibration info. The display 
 *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

/*
 *  locationManager:didFailWithError:
 *  
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
	didFailWithError:(NSError *)error;

@end

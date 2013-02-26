
/*
 *  CLError.h
 *  CoreLocation
 *
 *  Copyright 2008 Apple Computer, Inc. All rights reserved.
 *
 */

/*
 *  CLError
 *  
 *  Discussion:
 *    Error returned as code to NSError from CoreLocation.
 */
typedef enum {
	kCLErrorLocationUnknown  = 0,   // location is currently unknown, but CL will keep trying
	kCLErrorDenied,                 // CL access has been denied (eg, user declined location use)
	kCLErrorNetwork,                // general, network-related error
	kCLErrorHeadingFailure          // heading could not be determined
} CLError;

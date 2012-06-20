//
//  UIDevice-Hardware.m
//  atvHelloWorld
//
//  Created by admin on 21-05-12.
//  Copyright 2012 Wayin Inc. All rights reserved.
//


/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/cdefs.h>
#include <sys/types.h>

#include <time.h> //tbv uptime
#include <errno.h>
#include <utmpx.h>

#import "UIDevice-Uptime.h"

//typedef struct kinfo_proc kinfo_proc;

@implementation UIDevice (Uptime)



//- (NSTimeInterval)uptimeATV
- (NSString*) uptimeATV
{ 
	struct timeval boottime;

	size_t len = sizeof(boottime); 
	
	int mib[2] = { CTL_KERN, KERN_BOOTTIME };
	
	if (sysctl(mib, 2, &boottime, &len, NULL, 0) == -1) { 
		perror("sysctl"); 
		return [NSString stringWithFormat: @"%f", -1]; 
		//return (NSTimeInterval) -1; 

	} 
	time_t bsec = boottime.tv_sec, csec = time(NULL); 
	
	//return (NSTimeInterval) difftime(csec, bsec); //werkt	//oorspronkelijke code

	NSTimeInterval elapsedTime = ((NSTimeInterval) difftime(csec, bsec));
	
	
	// Divide the interval by 3600 and keep the quotient and remainder
	div_t h = div(elapsedTime, 3600);

    int hours = h.quot;
    // Divide the remainder by 60; the quotient is minutes
    div_t m = div(h.rem, 60);
    int minutes = m.quot;
	//the remainder is seconds.
    int seconds = m.rem;

	return [NSString stringWithFormat:@"uptime: %02li:%02li:%02li", hours, minutes, seconds];


} 




- (NSString*) uptimeATV2

{ 
	struct timeval boottime;
	
	size_t len = sizeof(boottime); 
	
	int mib[2] = { CTL_KERN, KERN_BOOTTIME };
	
	if (sysctl(mib, 2, &boottime, &len, NULL, 0) == -1) { 
		perror("sysctl"); 
		return [NSString stringWithFormat: @"%f", -1]; 
		//return (NSTimeInterval) -1; 
		
	} 
	time_t bsec = boottime.tv_sec, csec = time(NULL); 
	
	// The time interval 
	NSTimeInterval theTimeInterval = ((NSTimeInterval) difftime(csec, bsec));

	// Get the system calendar
	NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	
	// Create the NSDates
	NSDate *date1 = [[NSDate alloc] init];
	NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1]; 
	
	// Get conversion to months, days, hours, minutes
	unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
	
	NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
	
	//NSLog(@"Break down: %dmin %dhours %ddays %dmoths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
	
	return [NSString stringWithFormat:@"Last boot was: %dmin %dhours %ddays %dmoths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]];
	
	[date1 release];
	[date2 release];
	
	
} 


- (NSString*) wtmpATV2 {

	struct lastlogx *lastLogin;
	uid_t myuid = getuid();
	lastLogin = getlastlogx(myuid,nil);
	NSDate *dateAtLogon = [NSDate dateWithTimeIntervalSince1970:lastLogin->ll_tv.tv_sec];
	NSDate *currentDate = [NSDate date];
	NSTimeInterval timeSinceLogin = [currentDate timeIntervalSinceDate:dateAtLogon];
	NSLog(@"%1.1f seconds since logon",timeSinceLogin); 

}


@end






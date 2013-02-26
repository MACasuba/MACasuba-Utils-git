//
//  UIDevice-KERN.m
//  ATV2utils
//
//  Created by admin on 20-06-12.
//  Copyright 2012 MACasuba. All rights reserved.
//


#include <sys/socket.h> // definitions for second level network identifiers
#include <sys/sysctl.h> //definitions for top level identifiers, second level kernel and hardware identi-fiers, identifiers, and user level identifiers
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/cdefs.h>
#include <sys/types.h>

#import <sys/types.h> 

#import <netinet/in.h>
#import <net/if_dl.h>
#import <netdb.h>
#import <arpa/inet.h>
//#import <unistd.hv> //onvindbaar
#import <ifaddrs.h>




#include <time.h> //tbv uptime
#include <errno.h>

#import "UIDevice-KERN.h"


@implementation UIDevice (KERN)



#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    //return [self getSysInfo:HW_BUS_FREQ];
	  return ([self getSysInfo:HW_BUS_FREQ]/1000000.0f);
}

- (NSUInteger) clockFrequency  //vervallen
//A struct clockinfo structure is returned.  This structure contains the clock, statistics clock
//and profiling clock frequencies, the number of micro-seconds per hz tick and the skew rate.
// struct: struct clockrate 
//Information about the system clock rate may be obtained with:
//kern.clockrate: hz = 100, tick = 10000, profhz = 100, stathz = 100
{
   return [self getSysInfo:KERN_CLOCKRATE];//org werkt

	//return [NSString stringWithFormat:@"%@:%d", [NSString stringWithUTF8String:clock_hz]];
	
}


-(NSUInteger) printClockInfo //vervalen
{
    size_t length;
    int mib[6]; 
	//int mib[2];
    int result;
	
    mib[0] = CTL_HW;
    mib[1] = KERN_CLOCKRATE;
    length = sizeof(result);
    if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
    {
        perror("getting cpu frequency");
    }
    //printf("CPU Frequency = %d hz\n", result);

	return result;	

//	return [NSString stringWithFormat:@"Frequency = %u hz\n", result ];	
}

static int hertz(void);

-(NSUInteger) printClockInfo2
{
	//size_t length;
    //int mib[6]; 
	//int mib[2];
    //int clockinfo;
	
	struct clockinfo clockinfo;
	int mib[2];
	size_t size;

	size = sizeof(clockinfo);
	mib[0] = CTL_KERN;
	mib[1] = KERN_CLOCKRATE;
	if (sysctl(mib, 2, &clockinfo, &size, NULL, 0) < 0)
	{
		/*
		 * Best guess
		 */
		clockinfo.profhz = hertz();
	} else if (clockinfo.profhz == 0) {
		if (clockinfo.hz != 0)
			clockinfo.profhz = clockinfo.hz;
		else
			clockinfo.profhz = hertz();
	}
	return clockinfo.profhz;
}

//
// discover the tick frequency of the machine
// if something goes wrong, we return 0, an impossible hertz.
//
static int
hertz()
{
	struct itimerval tim;
	
	tim.it_interval.tv_sec = 0;
	tim.it_interval.tv_usec = 1;
	tim.it_value.tv_sec = 0;
	tim.it_value.tv_usec = 0;
	setitimer(ITIMER_REAL, &tim, 0);
	setitimer(ITIMER_REAL, 0, &tim);
	if (tim.it_interval.tv_usec < 2)
		return(0);
	return (1000000 / tim.it_interval.tv_usec);
}


- (NSUInteger) totalMemory /* int: total memory in MB */
//The bytes of physical memory represented by a 32-bit integer (for backward compatibility). Use HW_MEMSIZE instead.
{
    return (([self getSysInfo:HW_PHYSMEM]/1024.0f)/1024.0f);
}

- (NSUInteger) userMemory  //The bytes of non-kernel memory. amount in MB
{
    return (([self getSysInfo:HW_USERMEM]/1024)/1024);
}

//toegevoegd als test The number of bytes of physical memory in the system
//hw.memsize - The number of bytes of physical memory in the system.
//The bytes of physical memory represented by a 64-bit integer.
- (NSUInteger) imhoMemory
{
    return (([self getSysInfo:HW_MEMSIZE]/1024)/1024); /* uint64_t: physical ram size */
}

- (NSUInteger) maxSocketBufferSize
{
    return (([self getSysInfo:KIPC_MAXSOCKBUF]/1024.0f)/1024.0f);
}


// var test voor USER_POSIX2_UPE 
//Return 1 if the system supports the User Portability Utilities Option, otherwise 0.
- (NSUInteger) userPOSIX
{
    return [self getSysInfo:USER_POSIX2_UPE];
}

// A struct timeval structure is returned.  This structure contains the time that the system was booted.
//- (NSUInteger) kernBOOT
- (NSTimeInterval) kernBOOT
{	
	struct timeval boottime; 
	size_t len = sizeof(boottime); 
	
	int mib[2] = { CTL_KERN, KERN_BOOTTIME };
	
	if (sysctl(mib, 2, &boottime, &len, NULL, 0) == -1) { 
		perror("sysctl"); 
		return (NSTimeInterval) -1; 
	} 
	time_t bsec = boottime.tv_sec, csec = time(NULL); 
	return (NSTimeInterval) difftime(csec, bsec);
}

- (NSUInteger) myHostID  //get or set HostId  int: host identifier 
{
    return [self getSysInfo:KERN_HOSTID];
}

- (NSUInteger) myHostName  //Get or set the hostname  string: hostname 
{
    return [self getSysInfo:KERN_HOSTNAME];
}


@end























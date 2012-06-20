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

#import "UIDevice-Hardware.h"



@implementation UIDevice (Hardware)
/*
 Platforms
 iFPGA -> ??
 
 iPhone1,1 -> iPhone 1G, M68
 iPhone1,2 -> iPhone 3G, N82
 iPhone2,1 -> iPhone 3GS, N88
 iPhone3,1 -> iPhone 4/AT&T, N89
 iPhone3,2 -> iPhone 4/Other Carrier?, ??
 iPhone3,3 -> iPhone 4/Verizon, TBD
 iPhone4,1 -> (iPhone 5/AT&T), TBD
 iPhone4,2 -> (iPhone 5/Verizon), TBD
 
 iPod1,1 -> iPod touch 1G, N45
 iPod2,1 -> iPod touch 2G, N72
 iPod2,2 -> Unknown, ??
 iPod3,1 -> iPod touch 3G, N18
 iPod4,1 -> iPod touch 4G, N80
 // Thanks NSForge
 iPad1,1 -> iPad 1G, WiFi and 3G, K48
 iPad2,1 -> iPad 2G, WiFi, K93
 iPad2,2 -> iPad 2G, GSM 3G, K94
 iPad2,3 -> iPad 2G, CDMA 3G, K95
 iPad3,1 -> (iPad 3G, GSM)
 iPad3,2 -> (iPad 3G, CDMA)
 
 AppleTV2,1 -> AppleTV 2, K66
 
 i386, x86_64 -> iPhone Simulator
 */


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = (char*)malloc(size); //char toegevoegd
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	
    free(answer);
    return results;
}

//- (NSString *) platform
//{
//    return [self getSysInfoByName:"hw.machine"];
//}


- (NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}


// Thanks, Tom Harrington (Atomicbird)
//- (NSString *) hwmodel
//{
//    return [self getSysInfoByName:"hw.model"];
//}


- (NSString *) hwmodel
{
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *machine = (char*) malloc(size);
    sysctlbyname("hw.model", machine, &size, NULL, 0);
    NSString *hwmodel = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return hwmodel;
}



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
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) totalMemory
{
    return (([self getSysInfo:HW_PHYSMEM]/1024.0f)/1024.0f);
	// / 1024 geeft MB's
}


- (NSUInteger) userMemory
{
    return (([self getSysInfo:HW_USERMEM]/1024)/1024);
}

//toegevoegd als test The number of bytes of physical memory in the system
- (NSUInteger) imhoMemory
{
    return (([self getSysInfo:HW_MEMSIZE]/1024)/1024); /* uint64_t: physical ram size */
}


- (NSUInteger) maxSocketBufferSize
{
    return (([self getSysInfo:KIPC_MAXSOCKBUF]/1024.0f)/1024.0f);
}



// var test voor USER_POSIX2_UPE 
- (NSUInteger) userPOSIX
{
    return [self getSysInfo:USER_POSIX2_UPE];
}

// test voor KERN_BOOTTIME
- (NSUInteger) kernBOOT
{
    return [self getSysInfo:KERN_BOOTTIME];/* struct: time kernel was booted */
}


//test kernboot omzetten naar date format
- (NSString*) kernBOOTdata
{	
	NSUInteger testMe =  [self getSysInfo:KERN_BOOTTIME];/* struct: time kernel was booted */
	
	
NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
NSDate *date = [NSDate dateWithTimeIntervalSince1970:testMe];

	    return [dateFormatter stringFromDate:date];
//NSString *dateUptime = [dateFormatter stringFromDate:date];

}


//
/*

 Jun  3 16:30:43 Apple-TV /Applications/AppleTV.app/AppleTV[125]: Serial Number:DCYF8DJ2DDR5\n*** OS 8C154, IR 01.28, iBoot 931.71.16, SW 4.1.1 / 1553 ***\n*** OS   partition size/free:786432000/266895360 ***\n*** data partition size/free:7130374144/699334656 ***\n*** AVF main repository size:5519761408 ***\n*** AVF secondary repository size:209715200 ***\n*** Current Date:6/3/12 4:30 PM ***\n*** Time Zone:US/Pacific ***
 Jun  3 16:30:43 Apple-TV AppleTV[125]: localHostName: Apple-TV-2
 Jun  3 16:30:44 Apple-TV AppleTV[125]: reachObserverForHost: NSConcreteNotification 0x4e0c60 {name = CPNetworkObserverHostnameReachableNotification; userInfo = {\n    CPNetworkObserverHostname = "Apple-TV-2";\n    CPNetworkObserverReachable = 1;\n    CPNetworkObserverReachableFlags = <02000100>;\n}}
 
 
 
 
 */
//



#pragma mark file system -- Thanks Joachim Bean!


//see to get those /dev/disk0s1s1 == '/' and /dev/disk0s1s2 == '/private/var'   


- (NSNumber *) totalDiskSpace
{
//    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
//}

//test
NSDictionary * fsAttributes = [ [NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
NSNumber *totalSize = [fsAttributes objectForKey:NSFileSystemSize];
//NSString *sizeInGB = [NSString stringWithFormat:@"\n\n %3.2f GB",[totalSize floatValue] / 1073741824];

//NSString *sizeInGB = [NSString stringWithFormat:@"\n\n %.2f GB",[totalSize floatValue] / 1024];	
//test	
	
//return [NSString stringWithFormat:@"total_FS_GB: ", sizeInGB ];
	return [NSString stringWithFormat:@"GB: %@", [NSString stringWithFormat:@"\n\n %3.2f GB",[totalSize floatValue] / 1073741824] ];

//return [fattributes objectForKey:NSFileSystemSize];

}



- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
   // return [fattributes objectForKey:NSFileSystemFreeSize];
	
	// Create formatter
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; 
	
	NSString *formattedOutput = [formatter stringFromNumber:[fattributes objectForKey:NSFileSystemFreeSize]];
	
	//--------------------------------------------
	// Format style as percentage, output to console
	//--------------------------------------------
	[formatter setNumberStyle:NSNumberFormatterPercentStyle];
	
	// Set to the current locale
	[formatter setLocale:[NSLocale currentLocale]];
	
	// Get percentage of system space that is available
	float percent = [[fattributes objectForKey:NSFileSystemFreeSize] floatValue] / [[fattributes objectForKey:NSFileSystemSize] floatValue];
	NSNumber *num = [NSNumber numberWithFloat:percent];
	formattedOutput = [formatter stringFromNumber:num];

	return [NSString stringWithFormat:@"percent: %@",[formatter stringFromNumber:num]]; 
	
}



//test temp disk size

- (NSNumber *) tempTotalDiskSpace //size of the file system.
{
    //NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSTemporaryDirectory() error:nil];
    //return  [fattributes objectForKey:NSFileSystemSize];//werkt
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	//NSDictionary *attr = [fm attributesOfItemAtPath:@"/" error:&error]; //werkt
	NSDictionary *attr = [fm attributesOfItemAtPath:@"/dev/disk0s1s2" error:&error];
	
	return [NSString stringWithFormat:@"%llu", [[attr objectForKey:NSFileSystemSize] unsignedLongLongValue]/ 1073741824 ];
}

- (NSNumber *) tempFreeDiskSpace //the amount of free space on the file system.
{
    //NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSTemporaryDirectory() error:nil];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	//NSDictionary *attr = [fm attributesOfItemAtPath:@"/" error:&error]; //werkt
	NSDictionary *attr = [fm attributesOfItemAtPath:@"/dev/disk0s1s1" error:&error];

	
   //return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
//return [NSString stringWithFormat:@"%llu", [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue]];//werkt

	return [NSString stringWithFormat:@"%llu", [[attr objectForKey:NSFileSystemFreeSize] unsignedLongLongValue]/ 1073741824 ];//werkt

}


// nog een test 
- (NSNumber *) fileSize
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [NSString stringWithFormat:@"%llu", [[fattributes objectForKey:NSFileSize] unsignedLongLongValue]];//werkt
}

- (NSNumber *) freeNodes //value indicates the number of free nodes in the file system.
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeNodes];//werkt
	//return [[fattributes objectForKey:NSFileSystemFreeNodes] LongValue];

}

- (NSNumber *) systemNodes //value indicates the number of nodes in the file system.
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemNodes];
}

- (NSNumber *) systemNumber  // indicates the filesystem number of the file system.
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemNumber];
}


//owners info

- (NSString *) ownerAccountName
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileOwnerAccountName] ;
}

- (NSString *) ownerGroupAccountName  //value indicates the group name of the file's owner.
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileGroupOwnerAccountName] ;
}

// NSLog(@"free disk space: %dGB", (int)(freeSpace / 1073741824));

/*
 
 NSFileSystemFreeNodes = 5027061;
 NSFileSystemNodes = 69697534;
 NSFileSystemNumber = 234881026;
 
 
 
NSFileCreationDate = "2009-08-28 15:37:03 -0400";
NSFileExtensionHidden = 0;
NSFileGroupOwnerAccountID = 80;
NSFileGroupOwnerAccountName = admin;
NSFileModificationDate = "2009-10-28 15:22:15 -0400";
NSFileOwnerAccountID = 0;
NSFileOwnerAccountName = root;
NSFilePosixPermissions = 1021;
NSFileReferenceCount = 40;
NSFileSize = 1428;
NSFileSystemFileNumber = 2;
NSFileSystemNumber = 234881026;
NSFileType = NSFileTypeDirectory;
*/
 //








// nog een test voor de os en data disk
- (NSNumber *) rootTotalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) rootFreeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	// return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
	return [NSString stringWithFormat:@"%llu", [[fattributes objectForKey:NSFileSize] unsignedLongLongValue]];
}




#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
	
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"]) return UIDeviceIFPGA;
	/*
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"]) return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"]) return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"]) return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"]) return UIDevice5iPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"]) return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"]) return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"]) return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"]) return UIDevice4GiPod;
	
    // iPad
    if ([platform hasPrefix:@"iPad1"]) return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"]) return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"]) return UIDevice3GiPad;
    */
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"]) return UIDeviceAppleTV2;
	/*
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceUnknowniPad;
    */
	// Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceiPhoneSimulatoriPhone : UIDeviceiPhoneSimulatoriPad;
    }
	
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
       /*
		case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
			
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
       */     
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
      /*      
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_IPAD_NAMESTRING;
      */      
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
	//aangepast was en0, dat gaf mac van LAN ipv wifi  LAN=1 WIFI=0
    if ((mib[5] = if_nametoindex("en1")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
	}
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    //NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
      //                     *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
     NSString *outstring = [NSString stringWithFormat:@"%02X-%02X-%02X-%02X-%02X-%02X",
							*ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
	
    return outstring;
}

- (NSString *) macaddressW
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
	//aangepast was en0, dat gaf mac van LAN ipv wifi  LAN=1 WIFI=0 (of andersom?)
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
	
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
	}
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    //NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
	//                     *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *outstring = [NSString stringWithFormat:@"%02X-%02X-%02X-%02X-%02X-%02X",
						   *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
	
    return outstring;
}


- (NSDate*)startTime //De huidige tijd opvragen in milsecs
{
	//toegevoegd als test om tijd in sec op te vragen zodat het de datum van nu geeft
	double theLoggedInTokenTimestampDateEpochSeconds = [[NSDate date] timeIntervalSince1970];
	//nu ingevoegd om de start tijd vast te leggen
    return [NSDate dateWithTimeIntervalSince1970:theLoggedInTokenTimestampDateEpochSeconds];
}


- (NSString*)startTimeAsFormattedDateTime //de starttijd omzetten naar leesbare string
{
	//struct kinfo_proc *process = NULL;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	NSDate *date = [self startTime];

	// Retrieve the date as a string.
    return [dateFormatter stringFromDate:date];
}

//uptime test

+ (NSTimeInterval)uptime 
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

// Illicit Bluetooth check -- cannot be used in App Store

//void loop() {
- (NSString*) bluetoothx {
	
 Class btclass = NSClassFromString(@"GKBluetoothSupport");
 if (
	 [btclass respondsToSelector:@selector(bluetoothStatus)]
	 )
 {
	 //printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
	 return [NSString stringWithFormat : @"BT status_: ", (int)[btclass performSelector:@selector(bluetoothStatus)]] ;
//	 return [NSString stringWithFormat : @"BT status_: %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)]  & 1) != 0];
	 
	 //[NSString stringWithFormat: @"kernBOOT_: %d", 
	 
	 //BOOL bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
	 
	 
	 //printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
	 //return [NSString stringWithFormat: @"BT_: %s enabled\n", bluetooth ? "is" : "isn't"];
	 
 }
}
 



- (NSString*) bluetoothy {
	
	Class btclass = NSClassFromString(@"GKBluetoothSupport");
	if (
		[btclass respondsToSelector:@selector(bluetoothStatus)]
		)
	{
		//printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
		//return [NSString stringWithFormat : @"BT status_: %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)]  & 1) != 0];
		
		//[NSString stringWithFormat: @"kernBOOT_: %d", 
		
		BOOL bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
		
		
		//printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
		//return [NSString stringWithFormat: @"BT_: ", @selector(bluetoothStatus) ];
		return [NSString stringWithFormat: @"BT_: ", bluetooth ];

		//		return [NSString stringWithFormat: @"BT_: %s enabled\n", bluetooth ? "is" : "isn't"];
		
	}
}


@end







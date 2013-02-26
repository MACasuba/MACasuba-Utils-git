//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "HardwareMainMenu.h"
#import "ApplianceConfig.h"

#import "BRImageManager.h"

//#import "BTDevice.h"

#import "UIDevice-Hardware.h"
#import "UIDevice-Reachability.h"
#import "UIDevice-Uptime.h"
#import "UIDevice-KERN.h"

#include <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <IOKit/IOKitLib.h>

//nodig voor MACadress
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <netinet/in.h>
#import <net/if_dl.h>
#import <netdb.h>
#import <errno.h>
#import <arpa/inet.h>
//#import <unistd.hv> //onvindbaar
#import <ifaddrs.h>


//ingevoegd voor uptime

#import <assert.h>
#import <errno.h>
#import <stdbool.h>
#import <stdlib.h>
#import <stdio.h>
//#import <sys/sysctl.h>
//#import <sys/time.h>
#import <mach/host_info.h>
#import <mach/mach_init.h>
#import <mach/mach_host.h>
#import <SystemConfiguration/SystemConfiguration.h>


#if !defined(IFT_ETHER)
#define IFT_ETHER 0x6
#endif

#define CFN(X) [self commasForNumber:X]


@class BRWebView;

@implementation   HardwareMainMenu


- (id)init

{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

		BOOL   success;
		struct ifaddrs *addrs;
		const struct ifaddrs *cursor;
		const struct if_data *networkStatisc; 
		//char buf[64];
		const NSString *SerialNumber_ = nil;
		const NSString *ChipID_ = nil;
		
		NSString *name=[[[NSString alloc]init]autorelease];
	
		success = getifaddrs(&addrs) == 0;
		if (success) 
		{
			cursor = addrs;
			while (cursor != NULL) 
			{
				name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
				//NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
				// names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN 
				
				if (cursor->ifa_addr->sa_family == AF_LINK) 
				{
					if ([name hasPrefix:@"en"]) 
					{
						networkStatisc = (const struct if_data *) cursor->ifa_data;

					}
					
					if ([name hasPrefix:@"pdp_ip"]) 
					{
						networkStatisc = (const struct if_data *) cursor->ifa_data;

					} 
				}
				
				cursor = cursor->ifa_next;
			}
			
			freeifaddrs(addrs);
		}       

		NSString *address = @"error"; 
		struct ifaddrs *interfaces = NULL; 
		struct ifaddrs *temp_addr = NULL; int success1 = 0; 
		// retrieve the current interfaces - returns 0 on success 
		success1 = getifaddrs(&interfaces); 
		if (success1 == 0) { 
			// Loop through linked list of interfaces 
			temp_addr = interfaces; 
			while(temp_addr != NULL) 
			{ 
				if(temp_addr->ifa_addr->sa_family == AF_INET) 
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"]) 
				{ 
					// Get NSString from C String 
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; 
				}
			} temp_addr = temp_addr->ifa_next; } 
		} 
	
	////begin tevoeging
	
	if (CFMutableDictionaryRef dict =
		IOServiceMatching("IOPlatformExpertDevice")) 
		
	{
        if (io_service_t service =
			IOServiceGetMatchingService(kIOMasterPortDefault, dict)) {
            if (CFTypeRef serial =
				IORegistryEntryCreateCFProperty(service,
												CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0)) {
					SerialNumber_ = [NSString stringWithString:(NSString
																*)serial];
					CFRelease(serial);
				}
			
            if (CFTypeRef ecid =
				IORegistryEntrySearchCFProperty(service, kIODeviceTreePlane,
												CFSTR("unique-chip-id"), kCFAllocatorDefault,
												kIORegistryIterateRecursively)) {
					NSData *data((NSData *) ecid);
					size_t length([data length]);
					uint8_t bytes[length];
					[data getBytes:bytes];
					char string[length * 2 + 1];
					for (size_t i(0); i != length; ++i)
						sprintf(string + i * 2, "%.2X", bytes[length - i -
															  1]);
					ChipID_ = [NSString stringWithUTF8String:string];
					CFRelease(ecid);
				}
			
            IOObjectRelease(service);
        }
    }
	
	//eind toevoeging

		
	self = [super init];
	if (self)
	{
		// Initialization code here.
		[self setListTitle:HARDWARE_CATEGORY_NAME];
		
		BRImage *sp = [[BRThemeInfo sharedTheme] gearImage];		
		[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
		
		_names = [[NSMutableArray alloc] init];
		
		if ([[UIDevice currentDevice] networkAvailable])//begrijp niet wat if, de Erica code nog eens nakijken

		[_names addObject: [NSString stringWithFormat: @"S/N	: %@", SerialNumber_]];//300
		[_names addObject: [NSString stringWithFormat: @"Chip ID: %@", ChipID_]];//301	

		[_names addObject: [NSString stringWithFormat: @"Platform	  : %@", [[UIDevice currentDevice] platform]]];//302
		[_names addObject: [NSString stringWithFormat: @"Processor	  : %@", [[UIDevice currentDevice] platformString]]];//303
		[_names addObject: [NSString stringWithFormat: @"Model		  : %@",[[UIDevice currentDevice] hwmodel]]];//304

		[_names addObject: [NSString stringWithFormat: @"Bus freq MHz : %d", [[UIDevice currentDevice] busFrequency ]]];//305
		[_names addObject: [NSString stringWithFormat: @"CPU freq     : %d", [[UIDevice currentDevice] cpuFrequency]]];//306
		[_names addObject: [NSString stringWithFormat: @"Clock freq hz: %u", [[UIDevice currentDevice] printClockInfo2]]];//307

		[_names addObject:@"CPU speed: 1 GHz"];//308
		[_names addObject:@"Ethernet : 1 (RJ-45)"];//309
		[_names addObject:@"USB		 : 1 (Micro-USB)"];//310
		[_names addObject:@"Video	 : 1 (HDMI)"]; //311
		
		//[_names addObject: [NSString stringWithFormat: @"Clock freq  : %@", [[UIDevice currentDevice] clockFrequency]]];

		[_names addObject: [NSString stringWithFormat: @"systemNumber : %@", [[UIDevice currentDevice] systemNumber]]];//312
		//[_names addObject: [NSString stringWithFormat: @"systemNodes : %d", [[UIDevice currentDevice] systemNodes]]];
		//[_names addObject: [NSString stringWithFormat: @"freeNodes   : %d", [[UIDevice currentDevice] freeNodes]]];

		[[self list] setDatasource:self];
		return self;
	}
		
	return self;

	// Free memory
    
    //imho
    /*
    
	freeifaddrs(interfaces); 
	return address; 
*/
	
	[pool release];
	return 0;

     
     
}


-(void)dealloc {
	[_names release];
	[super dealloc];
}

- (id)previewControlForItem:(long)item {
	BRImage* previewImage = nil;
	
	switch (item) {
		case 0://build
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"300" ofType:@"png"]];
			break;
		case 1://product
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"301" ofType:@"png"]];
			break;
		case 2://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"302" ofType:@"png"]];
			break;
		case 3://Machine
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"303" ofType:@"png"]];
			break;
		case 4://ID
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"304" ofType:@"png"]];
			break;
		case 5://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"305" ofType:@"png"]];			
			break;		
		case 6://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"306" ofType:@"png"]];			
			break;	
		case 7://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"307" ofType:@"png"]];			
			break;
		case 8://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"308" ofType:@"png"]];			
			break;	
		case 9://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"309" ofType:@"png"]];			
			break;	
		case 10://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"310" ofType:@"png"]];			
			break;	
		case 11://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"311" ofType:@"png"]];			
			break;	
		case 12://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"312" ofType:@"png"]];			
			break;	
	}
	
	BRImageAndSyncingPreviewController *controller = [[BRImageAndSyncingPreviewController alloc] init];
	[controller setImage:previewImage];
	
	return controller;
}

- (void)itemSelected:(long)selected;{ 
	
	NSDictionary *currentObject = [_names objectAtIndex:selected];
	NSLog(@"%s (%d) item selected: %@", __PRETTY_FUNCTION__, __LINE__, currentObject);
	
	if (selected == 0) {
        //int result = system("");
		system("echo reboot");//
    }
	else if (selected == 1) {
		//int result = system("hostname > File.txt");
    }
}

- (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [_names count];
}

- (id)itemForRow:(long)row {
	
	if(row > [_names count])
		return nil;
	
	BRMenuItem* menuItem	= [[BRMenuItem alloc] init];
	NSString* menuTitle		= [_names objectAtIndex:row];
	
	[menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	switch (row) {
			
		default:
			//[menuItem addAccessoryOfType:0];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] smallHeightListDividerLabelAttributes]];
			break;
	}
	
	return menuItem;
}

- (BOOL)rowSelectable:(long)selectable {
	return YES;
}

- (id)titleForRow:(long)row {
	return [_names objectAtIndex:row];
}

- (BOOL) brEventAction:(BREvent*)event {
	
	NSLog(@"%s (%d): Remote action = %d", __PRETTY_FUNCTION__, __LINE__, [event remoteAction]);
	NSLog(@"%s (%d): Remote value = %d", __PRETTY_FUNCTION__, __LINE__, [event value]);
	NSLog(@"%s (%d): eventDictionary = %@", __PRETTY_FUNCTION__, __LINE__, [[event eventDictionary] description]);
	
	switch ([event remoteAction]) {
		case BREventMenuButtonAction:
			[[self stack] popController];
			break;
		case BREventOKButtonAction:
		case BREventUpButtonAction:
		case BREventDownButtonAction:
		case BREventLeftButtonAction:
		case BREventRightButtonAction:
		case BREventPlayPauseButtonAction:
			/* fallthrough */
		default:
			[super brEventAction:event];
			break;
	}
	
	return YES;
}

@end

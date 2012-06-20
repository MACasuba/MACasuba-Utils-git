//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "HardwareMainMenu.h"
#import "ApplianceConfig.h"
//#import "ApplianceConfig.h"
#import "BRImageManager.h"


#import "UIDevice-Hardware.h"
#import "UIDevice-Reachability.h"
#import "UIDevice-Uptime.h"

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
	

		
	self = [super init];
	if (self)
	{
		// Initialization code here.
		[self setListTitle:HARDWARE_CATEGORY_NAME];
		
		BRImage *sp = [[BRThemeInfo sharedTheme] gearImage];		
		[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
		
		_names = [[NSMutableArray alloc] init];
		
		//let op voor output %d of %@
		
		
		//[_names addObject:[NSNumber numberWithInt:getifaddrs(&addrs)]];
		//[_names addObject: [NSString stringWithFormat: @"User mem: %@", [[UIDevice currentDevice] userMemory]]];
		//[_names addObject:[NSNumber numberWithBool:[[UIDevice currentDevice] activeWLAN]]];
		//[_names addObject: [NSString stringWithFormat: @"uptime: %d", [[UIDevice currentDevice] uptime]]];//werkt niet in een UIDevice omgeving
		//[_names addObject:[[UIDevice currentDevice] uptimeString]];//werkt niet in een UIDevice omgeving
		//[_names addObject:[[UIDevice currentDevice] startTimeAsFormattedDateTime]];//werkt geeft datum van vandaag
		//hoe krijg ik data uit array??
		//[_names addObject:[[UIDevice currentDevice] runningProcesses]];//nog een keer uitzoeken is een Array
		//[_names addObject: [NSString stringWithFormat: @"imhoMmory_MB: %d", [[UIDevice currentDevice] imhoMemory]]];//werkt max memory in kbytes
		//[_names addObject: [NSString stringWithFormat: @"userPOSIX_: %d", [[UIDevice currentDevice] userPOSIX]]]; //werkt		
		//[_names addObject: [NSString stringWithFormat: @"kernBOOT_: %d", [[UIDevice currentDevice] kernBOOT]]];	//werkt geeft een nummer (als datum)
		//[_names addObject: [[UIDevice currentDevice] kernBOOTdata]];	//werkt geeft kernBoot als datum Jun26 1995
		//[_names addObject:[NSString stringWithFormat: @"LAN port : %@", name]];//geeft en1 in decimalen? 208512752	
		//[_names addObject:name];//geeft en1	
		//[_names addObject:[NSString stringWithFormat: @"Mac addess: %@", [[UIDevice currentDevice] macaddress]]];
		//[_names addObject:[NSString stringWithFormat:@"IP address ATV: %@",address]];//geeft ip adres
		[_names addObject:[NSString stringWithFormat: @"Platform_: %@", [[UIDevice currentDevice] platform]]];
		[_names addObject:[NSString stringWithFormat: @"Platform str: %@", [[UIDevice currentDevice] platformString]]];
		//[_names addObject:[NSString stringWithFormat: @"hostname : %@",[[UIDevice currentDevice] hostname]]];
		[_names addObject:[NSString stringWithFormat: @"hwmodel_ : %@",[[UIDevice currentDevice] hwmodel]]];
	//	[_names addObject:[[UIDevice currentDevice] localIPAddress]];
		//[_names addObject:[NSString stringWithFormat: @"Google IP: %@",[[UIDevice currentDevice] getIPAddressForHost:@"www.google.com"]]];
		//[_names addObject:[NSString stringWithFormat: @"localhost IP: %@",[[UIDevice currentDevice] getIPAddressForHost:@"localhost"]]];
		

		[_names addObject:[NSString stringWithFormat: @"BT_: %@",  [[UIDevice currentDevice] bluetoothx   ] ]];
		[_names addObject:[NSString stringWithFormat: @"BT_: %@",  [[UIDevice currentDevice] bluetoothy   ] ]];
		[_names addObject:[NSString stringWithFormat: @"BT_: %d",  [[UIDevice currentDevice] bluetoothx   ] ]];
		[_names addObject:[NSString stringWithFormat: @"BT_: %d",  [[UIDevice currentDevice] bluetoothy   ] ]];
					
		
		//if ([[UIDevice currentDevice] networkAvailable])//begrijp niet wat if, de Erica code nog eens nakijken
		//[_names addObject:[NSString stringWithFormat: @"ISP's IP: %@",[[UIDevice currentDevice] whatismyipdotcom]]];
		[_names addObject: [NSString stringWithFormat: @"Bus freq    : %d", [[UIDevice currentDevice] busFrequency]]];
		[_names addObject: [NSString stringWithFormat: @"CPU freq    : %d", [[UIDevice currentDevice] cpuFrequency]]];
		//[_names addObject: [NSString stringWithFormat: @"Free disk   : %d", [[UIDevice currentDevice] freeDiskSpace]]];
		//[_names addObject: [NSString stringWithFormat: @"Total disk  : %d", [[UIDevice currentDevice] totalDiskSpace]]];

		//[_names addObject: [NSString stringWithFormat: @"Free disk tmp: %d", [[UIDevice currentDevice] tempFreeDiskSpace]]];
		//[_names addObject: [NSString stringWithFormat: @"Total disktmp: %d", [[UIDevice currentDevice] tempTotalDiskSpace]]];

		//[_names addObject: [NSString stringWithFormat: @"File size : %u", [[UIDevice currentDevice] fileSize]]];

		[_names addObject: [NSString stringWithFormat: @"account owner : %@", [[UIDevice currentDevice] ownerAccountName]]];
		[_names addObject: [NSString stringWithFormat: @"account group : %@", [[UIDevice currentDevice] ownerGroupAccountName]]];

		[_names addObject: [NSString stringWithFormat: @"systemNumber: %d", [[UIDevice currentDevice] systemNumber]]];
		[_names addObject: [NSString stringWithFormat: @"systemNodes: %d", [[UIDevice currentDevice] systemNodes]]];
		[_names addObject: [NSString stringWithFormat: @"freeNodes: %d", [[UIDevice currentDevice] freeNodes]]];
		
		//NSLog(@"free disk space: %dGB", (int)(freeSpace / 1073741824));
			
		//[_names addObject: [NSString stringWithFormat: @"Total mem MB: %d", [[UIDevice currentDevice] totalMemory]]];	 
		//[_names addObject: [NSString stringWithFormat: @"Free mem MB : %d", [[UIDevice currentDevice] userMemory]]];
		//[_names addObject: [NSString stringWithFormat: @"imhoMmory_MB: %d", [[UIDevice currentDevice] imhoMemory]]];//werkt max memory in kbytes
		//[_names addObject: [NSString stringWithFormat: @"Buf size : %d", [[UIDevice currentDevice] maxSocketBufferSize]]];
		//[_names addObject:[NSString stringWithFormat:@"%@",cursor]];//werkt echter geeft (null)

		//[_names addObject:@"test"]; // geeft de tekst test
		[[self list] setDatasource:self];
		return self;
	}
		
	return self;

	// Free memory 
	freeifaddrs(interfaces); 
	return address; 

	
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
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"30" ofType:@"png"]];
			break;
		case 1://product
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"31" ofType:@"png"]];
			break;
		case 2://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"32" ofType:@"png"]];
			break;
		case 3://Machine
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"33" ofType:@"png"]];
			break;
		case 4://ID
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"34" ofType:@"png"]];
			break;
		case 5://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"35" ofType:@"png"]];			
			break;		
		case 6://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"36" ofType:@"png"]];			
			break;	
		case 7://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"37" ofType:@"png"]];			
			break;
		case 8://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"38" ofType:@"png"]];			
			break;	
		case 9://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HardwareMainMenu class]] pathForResource:@"39" ofType:@"png"]];			
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
			
		case 0:
			[menuItem addAccessoryOfType:0];
			break;
			
		case 1: 
			[menuItem addAccessoryOfType:0];
			break;
			
		default:
			[menuItem addAccessoryOfType:0];
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
//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "NetworkMainMenu.h"
#import "HardwareMainMenu.h"
#import "ApplianceConfig.h"
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

@implementation   NetworkMainMenu


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
		[self setListTitle:NETWORK_CATEGORY_NAME];
		
		BRImage *sp = [[BRThemeInfo sharedTheme] wirelessImage];		
		[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
		
		_names = [[NSMutableArray alloc] init];
		
		//let op voor output %d of %@
		
		if (![[UIDevice currentDevice] networkAvailable])
		
		{
			[_names addObject: @"You are not connected to the network. Please do so before running this application."];
			return nil;
		}
		
		
		else 
		{
		
		//[_names addObject:[NSNumber numberWithInt:getifaddrs(&addrs)]];
		[_names addObject:@"Wifi status"]; // 20geeft de tekst test
		//[_names addObject:[NSNumber numberWithBool:[[UIDevice currentDevice] activeWLAN]]];//20
			
		[_names addObject: [NSString stringWithFormat: @"%@", [[UIDevice currentDevice] uptimeATV2]]];//geeft 1970


			//test last login
		[_names addObject:[NSString stringWithFormat: @"%@", [[UIDevice currentDevice] wtmpATV2 ]]];
			
			
			
			
		[_names addObject:[NSString stringWithFormat: @"Now: %@", [[UIDevice currentDevice] startTimeAsFormattedDateTime]]];//22werkt geeft datum van vandaag
		//[_names addObject: [NSString stringWithFormat: @"imhoMmory_MB: %d", [[UIDevice currentDevice] imhoMemory]]];//23werkt max memory in kbytes
		//[_names addObject: [NSString stringWithFormat: @"userPOSIX_: %g", [[UIDevice currentDevice] userPOSIX]]]; //24werkt		
			
			
		//[_names addObject: [NSString stringWithFormat: @"kernBOOT_: %g", [[UIDevice currentDevice] kernBOOT]]];	//25werkt geeft een nummer (als datum)
		//[_names addObject: [[UIDevice currentDevice] kernBOOTdata]];	//26werkt geeft kernBoot als datum Jun26 1995
			
		//	[_names addObject: [[UIDevice currentDevice] dateUptime]];//26werkt geeft kernBoot als datum Jun26 1995
		
			
			
		[_names addObject:[NSString stringWithFormat: @"LAN port : %@", name]];//27geeft en1 in decimalen? 208512752	
		//[_names addObject:name];//geeft en1	
		[_names addObject:[NSString stringWithFormat: @"Mac lan addess: %@", [[UIDevice currentDevice] macaddress]]];//28
		[_names addObject:[NSString stringWithFormat: @"Mac wifi addess: %@", [[UIDevice currentDevice] macaddressW]]];//28

		[_names addObject:[NSString stringWithFormat:@"IP address ATV: %@",address]];//29geeft ip adres
		//	[_names addObject:[[UIDevice currentDevice] localIPAddress]];
		//[_names addObject:[NSString stringWithFormat: @"Google IP: %@",[[UIDevice currentDevice] getIPAddressForHost:@"www.google.com"]]];
		//[_names addObject:[NSString stringWithFormat: @"localhost IP: %@",[[UIDevice currentDevice] getIPAddressForHost:@"localhost"]]];
		
		[_names addObject:[NSString stringWithFormat: @"WiFi addess: %@",[[UIDevice currentDevice] localWiFiIPAddress]]];
		
		
		[_names addObject:[NSString stringWithFormat: @"Network up?: %d",[[UIDevice currentDevice] networkAvailable]]];//test
		[_names addObject:[NSString stringWithFormat: @"WLAN up?: %d",[[UIDevice currentDevice] activeWLAN]]];//test
		[_names addObject:[NSString stringWithFormat: @"WWAN up?: %d",[[UIDevice currentDevice] activeWWAN]]];//test

						   
		[_names addObject:[NSString stringWithFormat: @"ISP's IP: %@",[[UIDevice currentDevice] whatismyipdotcom]]];//30
		
		}
		
		
		
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
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"20" ofType:@"png"]];
			break;
		case 1://product
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"21" ofType:@"png"]];
			break;
		case 2://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"22" ofType:@"png"]];
			break;
		case 3://Machine
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"23" ofType:@"png"]];
			break;
		case 4://ID
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"24" ofType:@"png"]];
			break;
		case 5://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"25" ofType:@"png"]];			
			break;		
		case 6://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"26" ofType:@"png"]];			
			break;	
		case 7://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"27" ofType:@"png"]];			
			break;
		case 8://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"28" ofType:@"png"]];			
			break;	
		case 9://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"29" ofType:@"png"]];			
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

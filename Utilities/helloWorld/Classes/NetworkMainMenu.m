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

@implementation   NetworkMainMenu


- (id)init

{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	BOOL   success;
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	const struct if_data *networkStatisc; 
	//char buf[64];
    const NSString *itemNames_ = nil;
    const NSString *ispName_ = nil;

	
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
	

    
    //ISP-name, test 2, nu met een array
    NSString *path = @"/var/preferences/SystemConfiguration/preferences.plist";
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *hostName = [[[[dict objectForKey:@"System"] objectForKey:@"Network"]objectForKey:@"HostNames"]objectForKey:@"LocalHostName"] ;
    itemNames_ = hostName;
    
    
    //locaHostName, test 1, nu met een array
    NSString *path1 = @"/var/preferences/SystemConfiguration/com.apple.network.identification.plist";
    NSDictionary *dict1 = [[NSDictionary alloc] initWithContentsOfFile:path1];
    NSString *hostName1 = [[[[dict1 objectForKey:@"Signature"] objectForKey:@"Services"]objectForKey:@"DNS"]objectForKey:@"DomainName"] ;
    ispName_ = hostName1;
    
    
    
    ///////////////////////einde test
	
	self = [super init];
	if (self)
	{
		// Initialization code here.
		[self setListTitle:NETWORK_CATEGORY_NAME];
		
		BRImage *sp = [[BRThemeInfo sharedTheme] wirelessImage];		
		[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
		

		NSError *error;

		
		_names = [[NSMutableArray alloc] init];
		
		//let op voor output %d of %@
		
		if (![[UIDevice currentDevice] networkAvailable] && error)
		
		{
			[_names addObject: @"You are not connected to the network. Please do so before running this application."];
			//return nil;
		}
		
		
		else 
		{
        [_names addObject:[NSString stringWithFormat: @"%@", [[UIDevice currentDevice] uptimeATV2] ] ];//207
        [_names addObject:[NSString stringWithFormat: @"Now			: %@", [[UIDevice currentDevice] startTimeAsFormattedDateTime]]];//208
		[_names addObject:[NSString stringWithFormat: @"hostname	: %@",[[UIDevice currentDevice] hostname]]];//200
            
            //toegevoegs omdat deze naam in de HDremte app te zien is
        [_names addObject:[NSString stringWithFormat: @"Local Host Name: %@", itemNames_]];//200
        [_names addObject:[NSString stringWithFormat: @"ISP Name: %@", ispName_]];//200
            
		[_names addObject:[NSString stringWithFormat: @"LAN port	: %@", name]];//201	
		[_names addObject:[NSString stringWithFormat: @"LAN-ID		: %@", [[UIDevice currentDevice] macaddress]]];//202
		[_names addObject:[NSString stringWithFormat: @"LAN-ID Wifi : %@", [[UIDevice currentDevice] macaddressW]]];//203
		[_names addObject:[NSString stringWithFormat: @"AppleTV's IP: %@",address]];//204
		//[_names addObject:[[UIDevice currentDevice] localIPAddress]];
		[_names addObject:[NSString stringWithFormat: @"Google's IP	: %@",[[UIDevice currentDevice] getIPAddressForHost:@"www.google.com"]]];//205
		//[_names addObject:[NSString stringWithFormat: @"localhost IP: %@",[[UIDevice currentDevice] getIPAddressForHost:@"localhost"]]];
		[_names addObject:[NSString stringWithFormat: @"Your ISP's IP: %@",[[UIDevice currentDevice] whatismyipdotcom]]];//206
        [_names addObject:[NSString stringWithFormat: @"Your ISP's IP: %@",[[UIDevice currentDevice] whatismyipdotcom2]]];//206
        [_names addObject:[NSString stringWithFormat: @"Your ISP's IP: %@",[[UIDevice currentDevice] getIPAddress]]];//206

		//[_names addObject:[NSString stringWithFormat: @"WiFi addess: %@",[[UIDevice currentDevice] localWiFiIPAddress]]];
		//[_names addObject:[NSString stringWithFormat: @"Network up? : %d",[[UIDevice currentDevice] networkAvailable]]];//
		//[_names addObject:[NSString stringWithFormat: @"WLAN up?    : %d",[[UIDevice currentDevice] activeWLAN]]];//

		}
		
		
		[[self list] setDatasource:self];
		return self;
	}
	
	return self;

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
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"207" ofType:@"png"]];
			break;
		case 1://product
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"208" ofType:@"png"]];
			break;
		case 2://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"200" ofType:@"png"]];
			break;
            
        case 3://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"200" ofType:@"png"]];
			break;
            
		case 4://Machine
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"201" ofType:@"png"]];
			break;
		case 5://ID
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"202" ofType:@"png"]];
			break;
		case 6://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"203" ofType:@"png"]];			
			break;		
		case 7://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"204" ofType:@"png"]];			
			break;	
		case 8://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"205" ofType:@"png"]];			
			break;
		case 9://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[NetworkMainMenu class]] pathForResource:@"206" ofType:@"png"]];			
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

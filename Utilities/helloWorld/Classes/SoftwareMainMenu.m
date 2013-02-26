//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "HardwareMainMenu.h"
#import "ApplianceConfig.h"
#import "SoftwareMainMenu.h"
#import "BRImageManager.h"

#import "UIDevice-Hardware.h"
#import "UIDevice-Reachability.h"
#import "UIDevice-Uptime.h"
#import "UIDevice-KERN.h"

#include <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <IOKit/IOKitLib.h>

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
//toegevoegd vanwege de commands uoitvoeren
#include <unistd.h>


@class BRWebView;


@implementation SoftwareMainMenu

//- (id)init (int argc, char *argv[])  {
- (id)init
{
	const char *Machine_ = NULL;
	const NSString *System_ = NULL;
	const NSString *SerialNumber_ = nil;
	const NSString *ChipID_ = nil;
	const NSString *UniqueID_ = nil;
	//const NSString *UUID_ = nil;
	const NSString *Build_ = nil;
	const NSString *Product_ = nil;
	const NSString *ATV_ = nil;
	const NSString *OS_ = nil;
	const NSString *JB_ = nil;
	const NSString *JBversion_ = nil;

    
	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
    /* System Information {{{ */
    size_t size;
	
    int maxproc;
    size = sizeof(maxproc);
    if (sysctlbyname("kern.maxproc", &maxproc, &size, NULL, 0) == -1)
        perror("sysctlbyname(\"kern.maxproc\", ?)");
    else if (maxproc < 64) {
        maxproc = 64;
        if (sysctlbyname("kern.maxproc", NULL, NULL, &maxproc,
						 sizeof(maxproc)) == -1)
            perror("sysctlbyname(\"kern.maxproc\", #)");
    }
	
    sysctlbyname("kern.osversion", NULL, &size, NULL, 0);
    char *osversion = new char[size];
    if (sysctlbyname("kern.osversion", osversion, &size, NULL, 0) == -1)
        perror("sysctlbyname(\"kern.osversion\", ?)");
    else {
        System_ = [NSString stringWithUTF8String:osversion];
        //printf("System is %s\n", osversion);
    }
	
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = new char[size];
    if (sysctlbyname("hw.machine", machine, &size, NULL, 0) == -1)
        perror("sysctlbyname(\"hw.machine\", ?)");
    else {
        Machine_ = machine;
    }
	
	
	// property of root that describes the machine's UUID as a string
	//#define kIOPlatformUUIDKey	"IOPlatformUUID"	// (OSString)
	
	
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
	
	//iOS Device typ
	OS_ = [[UIDevice currentDevice] systemName];
	
	
	//iOS5
	CFUUIDRef UIID = CFUUIDCreate(NULL);
	CFStringRef TEST = (CFUUIDCreateString(NULL, UIID)) ;
	NSString *UUID_ = [NSString stringWithString:(NSString *) TEST];
	
	//iOS4
//	UniqueID_ = [[UIDevice currentDevice] uniqueIdentifier]; //udid Deprecated in iOS 5.0
	
    
    
	//read jailbreak status
    NSString *path1 = @"/var/mobile/Library/Preferences/Installed.plist";
    NSDictionary *dict1 = [[NSDictionary alloc] initWithContentsOfFile:path1];
    NSString *jbName1 = [[dict1 objectForKey:@"com.firecore.seas0npass"] objectForKey:@"Name"] ;
    JB_ = jbName1;
	
    //read jailbreak verion
    NSString *path2 = @"/var/mobile/Library/Preferences/Installed.plist";
    NSDictionary *dict2 = [[NSDictionary alloc] initWithContentsOfFile:path2];
    NSString *jbName2 = [[dict2 objectForKey:@"com.firecore.seas0npass"] objectForKey:@"Version"] ;
    JBversion_ = jbName2;
    
    
	// reads ios version
	if (NSDictionary *system = [NSDictionary
								dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"])
	{
		Build_ = [system objectForKey:@"ProductBuildVersion"];
	}

	if (NSDictionary *info = [NSDictionary
							  dictionaryWithContentsOfFile:@"/Applications/AppleTV.app/Info.plist"])
	{
		Product_ = [info objectForKey:@"MinimumOSVersion"];
		ATV_ = [info objectForKey:@"CFBundleVersion"];
		
		self = [super init];
		if (self)
			
		{
			// Initialization code here.
			//[self setListTitle:APPLIANCE_MODULE_NAME];
			[self setListTitle:SOFTWARE_CATEGORY_NAME];
			
			BRImage *sp = [[BRThemeInfo sharedTheme] appleTVIconOOB]; //gearImage
			[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
			
			_names = [[NSMutableArray alloc] init];
            
			
			[_names addObject: [NSString stringWithFormat: @"Build	: %@",  Build_]];//3
			[_names addObject: [NSString stringWithFormat: @"MinimumOSVersion: %@", Product_]];//4
			[_names addObject: [NSString stringWithFormat: @"CFBundleVersion : %@",  ATV_]];//5
			[_names addObject: [NSString stringWithUTF8String: Machine_ ]];//6
            
            
			[_names addObject: [NSString stringWithFormat: @"UUID iOS5: %@",  UniqueID_]];//7
			//[_names addObject: [NSString stringWithFormat: @"UDID iOS4: %@",  UUID_]];//8  depricated
			
			[_names addObject:[NSString stringWithFormat: @"Device type : %@", OS_]];//9
// hier moet nog een if statement op komen
			[_names addObject:[NSString stringWithFormat: @"Jailbreak: %@ -%@", JB_, JBversion_]];//10

			
			[_names addObject: [NSString stringWithFormat: @"systemNumber: %@", [[UIDevice currentDevice] systemNumber]]];//12
			//[_names addObject: [NSString stringWithFormat: @"systemNodes : %@", [[UIDevice currentDevice] systemNodes]]];//13
			//[_names addObject: [NSString stringWithFormat: @"freeNodes   : %@", [[UIDevice currentDevice] freeNodes]]];//14
			//	[_names addObject: [NSString stringWithFormat: @"systemSize  : %@", [[UIDevice currentDevice] systemSize]]];
			
			
			
			[[self list] setDatasource:self];
			return self;
		}
		
		return self;
	}
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
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"3" ofType:@"png"]];
			break;
		case 1://product
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"4" ofType:@"png"]];
			break;
		case 2://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"5" ofType:@"png"]];
			break;
		case 3://Machine
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"6" ofType:@"png"]];
			break;
		case 4://ID
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"7" ofType:@"png"]];
			break;
		case 6://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"8" ofType:@"png"]];
			break;
		case 7://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"9" ofType:@"png"]];
			break;
		case 8://JB  hier moet nog een if statemnet op komen
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"sp" ofType:@"png"]];
			break;
		case 9://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"12" ofType:@"png"]];
			break;
		case 10://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"13" ofType:@"png"]];
			break;
		case 11://system
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[SoftwareMainMenu class]] pathForResource:@"14" ofType:@"png"]];
			break;
	}
	
	BRImageAndSyncingPreviewController *controller = [[BRImageAndSyncingPreviewController alloc] init];
	[controller setImage:previewImage];
	
	return controller;
}

- (void)itemSelected:(long)selected; {
	
	NSDictionary *currentObject = [_names objectAtIndex:selected];
    NSLog(@"%s (%d) item selected: %@", __PRETTY_FUNCTION__, __LINE__, currentObject);
	
	/* unistd.h
	 v = Vector, pass in arguments as an array.
	 l = List, pass in arguments individually.
	 e = Environment, environmental variables passed in as an array.
	 p = Path, exec will look into your PATH environmental variable for the executable
	 int	 execl(const char *, const char *, ...);
	 int	 execle(const char *, const char *, ...);
	 int	 execlp(const char *, const char *, ...);
	 int	 execv(const char *, char * const *);
	 int	 execve(const char *, char * const *, char * const *);
	 int	 execvp(const char *, char * const *);*/
	
	if (selected == 0) {
		//int offset = 0 ;
    }
	
	else if (selected == 0) {
		system( "sleep 6s" );//doos icon
    }
	
	else if (selected == 1) {
		system( "sleep 6s" );//chip icon
    }
    else if (selected == 2) {
		execlp ( "ifconfig >>imho.txt" ,NULL);
		//execlp("whoami", "whoami", NULL);
		//system("reboot");//ispw icon werkt niet geeft een soft restart
	}
	
    else if (selected == 3) {
		//    result = sleep(6);
		[[[HardwareMainMenu alloc] init] autorelease];//5.1 werkt niet
    }
	
	else if (selected == 4){
		system("halt");//501 werkt niet
    }
	//def\
	
	else if (selected == 10){
		system("killall -9 AppleTV");
    }
	
	else if (selected == 5){
		system("echo Poweroff");//atv2
    }
	
	else if (selected == 6){
		system("echo purge");//ronde apstore icon ??
    }
	
	else if (selected == 7){
		system("echo reboot");//xcode
    }
	else if (selected == 8){
		system("echo HALT");//iphone os
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










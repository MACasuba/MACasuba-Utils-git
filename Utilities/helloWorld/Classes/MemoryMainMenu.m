//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "MemoryMainMenu.h"
#import "ApplianceConfig.h"
//#import "ApplianceConfig.h"
#import "BRImageManager.h"

#import "LogMainMenu.h"

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


//to get the divider working
#import <BackRow/BRLocalizedStringManager.h>
#define BRLocalizedString(key, comment) \
[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, table, comment) \
[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(table)]


#if !defined(IFT_ETHER)
#define IFT_ETHER 0x6
#endif

#define CFN(X) [self commasForNumber:X]


@class BRWebView;

@implementation   MemoryMainMenu



- (id)init

{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	self = [super init];
	if (self)
	{
		// Initialization code here.
		[self setListTitle:MEMORY_CATEGORY_NAME];
		BRImage *sp = [[BRThemeInfo sharedTheme] gearImage];		
		[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
        
		
		_names = [[NSMutableArray alloc] init];
		if ([[UIDevice currentDevice] networkAvailable])//begrijp niet wat if, de Erica code nog eens nakijken
		//[_names addObject:@"**** iOS filesystem '/private/var' ****"];	//100
		[_names addObject: [NSString stringWithFormat: @"System Total		: %@", [[UIDevice currentDevice] totalDiskSpace]]];//101
		[_names addObject: [NSString stringWithFormat: @"System Free		: %@", [[UIDevice currentDevice] freeDiskSpace]]];//102
		[_names addObject: [NSString stringWithFormat: @"/dev/disk0s1s2  %@", [[UIDevice currentDevice] freeDiskSpacePct]]];//103
		//[_names addObject:@"**** User filesystem '/'    ****"];	//104
		[_names addObject: [NSString stringWithFormat: @"User total: %@", [[UIDevice currentDevice] tempTotalDiskSpace]]];//105
		[_names addObject: [NSString stringWithFormat: @"User free : %@", [[UIDevice currentDevice] tempFreeDiskSpace]]];//106
		[_names addObject: [NSString stringWithFormat: @"/dev/disk0s1s1  %@", [[UIDevice currentDevice] pctFreeDiskSpace]]];//107
		//[_names addObject:@"**** Dev 'devfs'    ****"];	//104
        [_names addObject: [NSString stringWithFormat: @"Total devfs		: %@", [[UIDevice currentDevice] devTotalDiskSpace]]];
        [_names addObject: [NSString stringWithFormat: @"Free  devfs		: %@", [[UIDevice currentDevice] devFreeDiskSpace]]];
        
      //  [_names addObject:  [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"\n\n %3.0u MB",[[UIDevice currentDevice] logSize] / 1048576]]];

        [_names addObject:  [NSString stringWithFormat:@"syslog size: %@", [NSString stringWithFormat:@"\n\n %3@",[[UIDevice currentDevice] prettyBytesLogSize]] ]];

        
		[_names addObject: [NSString stringWithFormat: @"caches rentals: %@", [[UIDevice currentDevice] cachesSize]]];//110
		[_names addObject: [NSString stringWithFormat: @"caches other  : %@", [[UIDevice currentDevice] cachesSize1]]];//111
	//	[_names addObject: [NSString stringWithFormat: @"caches system calc  : %@", [[UIDevice currentDevice] getCachesDirSizeInBytes]]];//test for check of total caches size function
		[_names addObject: [NSString stringWithFormat: @"Maximum RAM in MB	: %d", [[UIDevice currentDevice] totalMemory]]];//112 
		[_names addObject: [NSString stringWithFormat: @"Free User RAM in MB: %d", [[UIDevice currentDevice] userMemory]]];//113
		[_names addObject: [NSString stringWithFormat: @"Standard RAM in MB	: %d", [[UIDevice currentDevice] imhoMemory]]];//114
		[_names addObject: [NSString stringWithFormat: @"Buffer  size		: %d", [[UIDevice currentDevice] maxSocketBufferSize]]];//115

        //create dividers between the sections
        
        [[self list] setDatasource:self];
        [[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"iOS filesystem '/private/var'",@"Featured menu item divider in software section")];
        [[self list] addDividerAtIndex:3 withLabel: @"User filesystem '/'"];
		[[self list] addDividerAtIndex:6 withLabel: @"Dev filesystem '/dev'"];
        
        //if the log file exceeds 50 MB you will be able to flush the logfile
        if ([[UIDevice currentDevice] logSize] >=  50000000)
        {
            [[self list] addDividerAtIndex:8 withLabel: @"Please rotate your syslog !"];
        }
        //in case the syslog is smaller then 50MB it will just show te usage
        if ([[UIDevice currentDevice] logSize] <  50000000)
        {
            [[self list] addDividerAtIndex:8 withLabel: @"your used cashes space"];
        }

        [[self list] addDividerAtIndex:11 withLabel: @"RAM"];
		//[[self list] setDatasource:self]; //turned off to get deviders to work
        
		return self;
	}
	
	return self;


    //is dit nodig?
	[pool release];
	return 0;
	
}


-(void)dealloc {
	[_names release];
	[super dealloc];
}

- (id)previewControlForItem:(long)item {
	BRImage* previewImage = nil;
	
	switch (item)
    {
		case 0://system total
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"100" ofType:@"png"]];
			break;
		case 1://system free
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"102" ofType:@"png"]];
			break;
		case 2://system pct free
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"102" ofType:@"png"]];
			break;
		case 3://user total
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"100" ofType:@"png"]];
			break;
		case 4://user free
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"102" ofType:@"png"]];
			break;
		case 5://user pct free
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"102" ofType:@"png"]];			
			break;
		case 6://devfs total
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"100" ofType:@"png"]];
			break;
		case 7://devfs free
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"102" ofType:@"png"]];
			break;
		case 8://logfile
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"108" ofType:@"png"]];
			break;
		case 9://cache rental
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"110" ofType:@"png"]];			
			break;
		case 10://cache other
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"111" ofType:@"png"]];
			break;	
		case 11://max ram
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"112" ofType:@"png"]];
			break;	
		case 12://free ram
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"113" ofType:@"png"]];
			break;	
		case 13://std ram
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"114" ofType:@"png"]];
			break;	
		case 14://buff size
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"115" ofType:@"png"]];
			break;	
		case 15://
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"113" ofType:@"png"]];			
			break;	
		case 16://
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"114" ofType:@"png"]];			
			break;	
		case 17://
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[MemoryMainMenu class]] pathForResource:@"115" ofType:@"png"]];			
			break;
	}
	
	BRImageAndSyncingPreviewController *controller = [[BRImageAndSyncingPreviewController alloc] init];
	[controller setImage:previewImage];
	
	return controller;
}



- (void)itemSelected:(long)selected;{
    
	NSDictionary *currentObject = [_names objectAtIndex:selected];
	NSLog(@"%s (%d) item selected: %@", __PRETTY_FUNCTION__, __LINE__, currentObject);
	   
	if (selected == 0) 
    {
        //
    }
    
    /*
     else if (selected == 6)
     {
         PowerMainMenu *menuController;
         menuController = [[PowerMainMenu alloc] init];
         [[self stack] pushController:menuController];
         [menuController autorelease];
     }
    
    

     else if (selected == 7)
     {
         PowerMainMenu* rename = [[PowerMainMenu alloc] init];
         [[self stack] pushController:rename];
         [rename autorelease];
     }
    
    */
    
    else if (selected == 8) // ga naar het logfile menu
        {
            LogMainMenu *menuController;
            menuController = [[LogMainMenu alloc] init];
            [[self stack] pushController:menuController];
            [menuController autorelease];
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
            
        case 8:
            if ([[UIDevice currentDevice] logSize] >=  50000000)
        {
            [menuItem addAccessoryOfType:3]; //display an arrow behind the syslog size line
            //ToDo is that a key press will get you to a new sub menu
            //flush of view the syslog
        }
            
        {
            [menuItem addAccessoryOfType:7];
        }
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

//
//  ATVAppliance.mm
//  atvHelloWorld
//
//  Created by Michael Gile on 8/21/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "ATVAppliance.h"
#import "ApplianceConfig.h"
#import "TopShelfController.h"

#import "SoftwareMainMenu.h"
#import "NetworkMainMenu.h"
#import "HardwareMainMenu.h"
#import "MemoryMainMenu.h"
#import "PowerMainMenu.h"

//na oke build onderstaande weer actief gemaakt, wellicht is muziek een item om te testen
#import "BRMediaPlayer.h"
#import "BRMediaPlayerManager.h"

@implementation ATVAppliance

@synthesize topShelfController = _topShelfController;

+ (NSArray*) applianceCategories {
	
	NSMutableArray* categoryList = [[NSMutableArray alloc] initWithCapacity:5];
	
	[categoryList addObject:[BRApplianceCategory categoryWithName:HW_CATEGORY_NAME 
													   identifier:HW_ID 
												   preferredOrder:HW_PREFERRED_ORDER]];
	
	[categoryList addObject:[BRApplianceCategory categoryWithName:SOFTWARE_CATEGORY_NAME 
													   identifier:SOFTWARE_ID 
												   preferredOrder:SOFTWARE_PREFERRED_ORDER]];
	
	[categoryList addObject:[BRApplianceCategory categoryWithName:HARDWARE_CATEGORY_NAME 
													   identifier:HARDWARE_ID 
												   preferredOrder:HARDWARE_PREFERRED_ORDER]];

	[categoryList addObject:[BRApplianceCategory categoryWithName:NETWORK_CATEGORY_NAME 
													   identifier:NETWORK_ID 
												   preferredOrder:NETWORK_PREFERRED_ORDER]];
	
	[categoryList addObject:[BRApplianceCategory categoryWithName:MEMORY_CATEGORY_NAME 
													   identifier:MEMORY_ID 
												   preferredOrder:MEMORY_PREFERRED_ORDER]];	
	
	[categoryList addObject:[BRApplianceCategory categoryWithName:POWER_CATEGORY_NAME 
													   identifier:POWER_ID 
												   preferredOrder:POWER_PREFERRED_ORDER]];	
	return [NSArray arrayWithArray:[categoryList autorelease]];
}


+ (void) initialize {
	;
}

- (id)init {
    self = [super init];
    if (self) {
		_topShelfController		= [[TopShelfController alloc] init];
		_applianceCategories	= [[ATVAppliance applianceCategories] retain];
    }
    
    return self;
}

- (void) dealloc {
	[_applianceCategories release];
	[_topShelfController release];
	[super dealloc];
}

- (id) applianceCategories {
	return _applianceCategories;
}

- (id) identifierForContentAlias:(id)contentAlias {
	//return APPLIANCE_MODULE_NAME;
	return HW_ID;
}

- (id) selectCategoryWithIdentifier:(id)ident {
	NSLog(@"[DEBUG] %s (%d): ident = %@", __PRETTY_FUNCTION__, __LINE__, [ident description]);
	return nil;
}

- (BOOL) handleObjectSelection:(id)fp8 userInfo:(id)fp12 {
	NSLog(@"[ENTRY] %s (%d)", __PRETTY_FUNCTION__, __LINE__);
	return YES;
}

- (id) applianceSpecificControllerForIdentifier:(id)arg1 args:(id)arg2 {
	//NSLog(@"applianceSpecificControllerForIdentifier: %@ args: %@", arg1, arg2);
	return nil;
}

- (id) controllerForIdentifier:(id)identifier args:(id)args
{
	id controller	= nil;
	
	if ([identifier isEqualToString:HW_ID]) {

		controller 	= [BRAlertController alertOfType:2 
											  titled:@"About & Credits" 
										 primaryText:@"ATV2_Utils" 
									   secondaryText:@"created by MACasuba - www.iMHo.nu"];
	}
	else if ([identifier isEqualToString:SOFTWARE_ID]) {
		controller	= [[[SoftwareMainMenu alloc] init] autorelease];
	}
	else if ([identifier isEqualToString:HARDWARE_ID]) {
		controller	= [[[HardwareMainMenu alloc] init] autorelease];
	}
	else if ([identifier isEqualToString:NETWORK_ID]) {
		controller	= [[[NetworkMainMenu alloc] init] autorelease];
	}	
	else if ([identifier isEqualToString:MEMORY_ID]) {
		controller	= [[[MemoryMainMenu alloc] init] autorelease];
	}	
	else if ([identifier isEqualToString:POWER_ID]) {
		controller	= [[[PowerMainMenu alloc] init] autorelease];
	}	
	return controller;
}

- (id) localizedSearchTitle { 
	return APPLIANCE_LOCALIZED_NAME; 
}

- (id) applianceName { 
	return APPLIANCE_NAME; 
}

- (id) moduleName { 
	return APPLIANCE_MODULE_NAME; 
}

- (id) applianceKey { 
	return APPLIANCE_KEY; 
}

@end

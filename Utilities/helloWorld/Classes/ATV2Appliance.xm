
#import "BackRowExtras.h"
//#import "HWBasicMenu.h"

/////////////////////
#import "BackRow.h"
#import <BackRow/BackRow.h>


#import "PowerMainMenu.h"
#import "ApplianceConfig.h"
//#import "GLGravityViewController.h"
//#import "GLGravityView.h"
#import "BRImageManager.h"
#import "BRController.h"
#import "BRAXTitleChangeProtocol.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

//to get the divider working
#import <BackRow/BRLocalizedStringManager.h>
#import <BackRow/BRMediaMenuController.h>

//to get system commandss working
#include <notify.h>
#import <UIKit/UIKit.h>
#import <NSTask.h>
////////////////////


#define TOPSHELFVIEW %c(BRTopShelfView)
#define IMAGECONTROL %c(BRImageControl)
#define BRAPPCAT %c(BRApplianceCategory)

//#define HELLO_ID @"hwHello"
//#define HELLO_CAT [BRAPPCAT categoryWithName:@"Hello World" identifier:HELLO_ID preferredOrder:0]

/////////////////////////

#define APPLIANCE_LOCALIZED_NAME		@"MACasuba"
#define APPLIANCE_NAME					@"MACasuba"
#define APPLIANCE_MODULE_NAME			@"MACasuba"
#define APPLIANCE_KEY					@"MACasuba"

#define HW_ID							@"ATV2 Utils by MACasuba"
//#define HW_CATEGORY_NAME				@"About"
//#define HW_PREFERRED_ORDER				0

#define HW_CAT [BRAPPCAT categoryWithName:@"Hello World" identifier:HD_ID preferredOrder:0]

#define SOFTWARE_ID						@"Software info"
//#define SOFTWARE_CATEGORY_NAME			@"Software info"
//#define SOFTWARE_PREFERRED_ORDER		1

#define SOFTWARE_CAT [BRAPPCAT categoryWithName:@"Software info" identifier:SOFTWARE_ID preferredOrder:1]

#define HARDWARE_ID                     @"Hardware info"
//#define HARDWARE_CATEGORY_NAME          @"Hardware info"
//#define HARDWARE_PREFERRED_ORDER        2

#define HARDWARE_CAT [BRAPPCAT categoryWithName:@"Hardware info" identifier:HARDWARE_ID preferredOrder:2]


#define NETWORK_ID                      @"Network info"
//#define NETWORK_CATEGORY_NAME           @"Network info"
//#define NETWORK_PREFERRED_ORDER         3

#define NETWORK_CAT [BRAPPCAT categoryWithName:@"Network info" identifier:NETWORK_ID preferredOrder:3]

#define MEMORY_ID						@"Memory info"
//#define MEMORY_CATEGORY_NAME			@"Memory info"
//#define MEMORY_PREFERRED_ORDER			4

#define MEMORY_CAT [BRAPPCAT categoryWithName:@"Memory info" identifier:MEMORY_ID preferredOrder:4]

#define POWER_ID						@"Power info"
//#define POWER_CATEGORY_NAME				@"Power info"
//#define POWER_PREFERRED_ORDER			5

#define POWER_CAT [BRAPPCAT categoryWithName:@"Power info" identifier:POWER_ID preferredOrder:5]


/////////////////////////


//@interface BRTopShelfView (specialAdditions)
//
//- (BRImageControl *)productImage;
//
//@end
//
//
//@implementation BRTopShelfView (specialAdditions)
//
//- (BRImageControl *)productImage
//{
//	return MSHookIvar<BRImageControl *>(self, "_productImage");
//}
//
//@end


%subclass ATV2ApplianceInfo : BRApplianceInfo

- (NSString*)key
{
	return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

- (NSString*)name
{
	return [[[NSBundle bundleForClass:[self class]] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

- (id)localizedStringsFileName
{
	return @"HWLocalizable";
}

%end

@interface TopShelfController : NSObject {
}
- (void)refresh; //4.2.1
- (void)selectCategoryWithIdentifier:(id)identifier;
- (id)topShelfView;
@end

@implementation TopShelfController


-(void)refresh
{
		//needed for 4.2.1 compat to keep AppleTV.app from endless reboot cycle
}

- (void)selectCategoryWithIdentifier:(id)identifier {
	
	//leave this entirely empty for controllerForIdentifier:args to work in Appliance subclass
}





- (id)topShelfView {
	
	id topShelf = [[TOPSHELFVIEW alloc] init];
	return topShelf;
	//BRTopShelfView *topShelf = [[BRTopShelfView alloc] init];
	//BRImageControl *imageControl = [topShelf productImage];
	//BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HWBasicMenu class]] pathForResource:@"ApplianceIcon" ofType:@"png"]];
	//BRImage *theImage = [[BRThemeInfo sharedTheme] largeGeniusIconWithReflection];
	//[imageControl setImage:theImage];
	
	//return topShelf;
}

@end

%subclass ATV2Appliance: BRBaseAppliance

static char const * const topShelfControllerKey = "topShelfController";
static char const * const applianceCategoriesKey = "applianceCategories";
//@interface HWAppliance: NSObject {
//	TopShelfController *_topShelfController;
//	NSArray *_applianceCategories;
//}
//@property(nonatomic, readonly, retain) id topShelfController;

//@end

//@implementation HWAppliance
//@synthesize topShelfController = _topShelfController;

- (id)applianceInfo
{

		Class cls = objc_getClass("ATV2ApplianceInfo");
		NSLog(@"cls: %@", cls);
		return [[[cls alloc] init] autorelease];

}

%new + (void)forceCrash
{
	NSArray *theArray = [NSArray arrayWithObjects:@"thejesus", @"heyzus", nil];
	NSLog(@"we should crash now");
	id theObject = [theArray objectAtIndex:2];
}

+ (void)initialize {
	
	//NSLog(@"INITIALIZE");
	
		//[objc_getClass("HWAppliance") forceCrash]; //in here solely to show how to use hwSymbols shell script	
}

- (id)topShelfController { return objc_getAssociatedObject(self, topShelfControllerKey); }

%new - (void)setTopShelfController:(id)topShelfControl { objc_setAssociatedObject(self, topShelfControllerKey, topShelfControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

- (id)applianceCategories {
	
	return objc_getAssociatedObject(self, applianceCategoriesKey);
}

%new - (void)setApplianceCategories:(id)applianceCategories
{ objc_setAssociatedObject(self, applianceCategoriesKey, applianceCategories, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

- (id)init
{
	return [self initWithApplianceInfo:nil]; //compat sanity
}

- (id)initWithApplianceInfo:(id)applianceInfo { //IMPORTANT!!!!: if you dont do initWithApplianceInfo: BRBaseAppliance will always return nil in 6.x+
	if((self = %orig) != nil) {
		
		//[self setTopShelfController:
		//_topShelfController = [[TopShelfController alloc] init];
		id topShelfControl = [[TopShelfController alloc] init];
		[self setTopShelfController:topShelfControl];
		NSArray *catArray = [[NSArray alloc] initWithObjects:HW_CAT,SOFTWARE_CAT,HARDWARE_CAT,MEMORY_CAT,NETWORK_CAT,POWER_CAT,nil];
		[self setApplianceCategories:catArray];
		//_applianceCategories = [[NSArray alloc] initWithObjects:HELLO_CAT,nil];
	
	} return self;
}


// code van KB uitgezet
/*
- (id)controllerForIdentifier:(id)identifier args:(id)args
{
	id menuController = nil;
	if ([identifier isEqualToString:HELLO_ID])
	{
		//for some reason %c(HWBasicMenu) was crashing??
		//	NSLog(@"%c(HWBasicMenu): %@", %c(HWBasicMenu));
		
		menuController = [[objc_getClass("HWBasicMenu") alloc] init];
	}
	return menuController;
}
 */

/////////////////////
- (id) controllerForIdentifier:(id)identifier args:(id)args
{
	id controller	= nil;
	
	if ([identifier isEqualToString:HW_ID]) {
        
		controller 	= [BRAlertController alertOfType:2
											  titled:@"About & Credits"
										 primaryText:@"ATV2_Utils-iOS6"
									   secondaryText:@"created by MACasuba - www.iMHo.nu"];
	}
	else if ([identifier isEqualToString:SOFTWARE_ID]) {
        controller = [[objc_getClass("SoftwareMainMenu") alloc] init];

	}
	else if ([identifier isEqualToString:HARDWARE_ID]) {
        controller = [[objc_getClass("HardwareMainMenu") alloc] init];
	}
	else if ([identifier isEqualToString:NETWORK_ID]) {
        controller = [[objc_getClass("NetworkMainMenu") alloc] init];
	}
	else if ([identifier isEqualToString:MEMORY_ID]) {
        controller = [[objc_getClass("MemoryMainMenu") alloc] init];
	}
	else if ([identifier isEqualToString:POWER_ID]) {
        controller = [[objc_getClass("PowerMainMenu") alloc] init];
	}
	return controller;
}



//////////////////////

- (id)identifierForContentAlias:(id)contentAlias {
	//return @"Hello World";
	//return APPLIANCE_MODULE_NAME;
	return HW_ID;
}

- (id)selectCategoryWithIdentifier:(id)ident {
	//NSLog(@"selecteCategoryWithIdentifier: %@", ident);
	return nil;
}

- (BOOL)handleObjectSelection:(id)fp8 userInfo:(id)fp12 {

	return YES;
}

- (id)applianceSpecificControllerForIdentifier:(id)arg1 args:(id)arg2 {

	return nil;
}


////
//code van KB uitgezet
/*
- (id)localizedSearchTitle { return @"Hello World"; }
- (id)applianceName { return @"Hello World"; }
- (id)moduleName { return @"Hello World"; }
- (id)applianceKey { return @"Hello World"; }
*/
//////////
//mijn oude code
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

///////////////

//@end

%end



// vim:ft=objc

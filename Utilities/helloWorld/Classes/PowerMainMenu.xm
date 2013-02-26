//#import "HWBasicMenu.h"
#import <Foundation/Foundation.h>

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

#define BRLocalizedString(key, comment) \
[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, table, comment) \
[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(table)]

//to get system commandss working
#include <notify.h>
#import <UIKit/UIKit.h>
#import <NSTask.h>
////////////////////

//%subclass HWBasicMenu: BRMediaMenuController
%subclass PowerMainMenu: BRMediaMenuController


static char const * const menuItemKey = "MenuItems";


//@implementation HWBasicMenu //no more interface or implementation, using logos to subclass at runtime.

- (id) init
{
	if((self = %orig) != nil) {
		
		//NSLog(@"%@ %s", self, _cmd);
		
		[self setListTitle:@"Hello World!"];
		
		/* 
		 
		 if you wanted to load your own image from your own resources folder you would use something like line 29 and 30, here we are just loading from BRThemeInfo
		 
		 */
		
		//NSString *settingsPng = [[NSBundle bundleForClass:[HWBasicMenu class]] pathForResource:@"picture" ofType:@"png"];
		//BRImage *sp = [BRImage imageWithPath:settingsPng];
		//BRImage *sp = [[%c(BRThemeInfo) sharedTheme] gearImage];
		
	//[self setListIcon:sp horizontalOffset:0.0 kerningFactor:0.15];
		
			//these are our menu options in our new controller
		
		NSMutableArray *theArray = [[NSMutableArray alloc] init];
		[theArray addObject:@"First Object"];
		[theArray addObject:@"Second Objectz"];
		[self setMenuItems:theArray];
		[[self list] setDatasource:self];
		[[self list] addDividerAtIndex:1 withLabel:@"testing"];
		return ( self );
		
	}
	
	return ( self );
}	

/* 
 
 these are the previews that are displayed on your left when a menu item has been selected, we use a basic case statement and return different images according to index
 
 */


- (id)previewControlForItem:(long)item

{
	id theImage = nil;
	
	switch (item) {
			
		case 0: //item one
		
			theImage = [[%c(BRThemeInfo) sharedTheme] largeGeniusIconWithReflection];
			break;
		
		case 1: //item two
			
			theImage = [[%c(BRThemeInfo) sharedTheme] networkPhotosImage];
			break;
		
	}
	
//here we had to change to BRIconPreviewController (or just something different than in prior versions, the old class we used here is gone)
	
	id obj = [[%c(BRIconPreviewController) alloc] init];
	
	[obj setImage:theImage];
	
	return ([obj autorelease]);
	
}

%new - (id)menuItems { return objc_getAssociatedObject(self, menuItemKey); }
%new - (void)setMenuItems:(id)newMenuItems { objc_setAssociatedObject(self, menuItemKey, newMenuItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
/*
 
 here we handle selecting an object from the list, right now we just log out to the syslog which item was selected, you can obviously be more complex than that :) 
 */


- (void)itemSelected:(long)selected {
	
	NSDictionary *currentObject = [[self menuItems] objectAtIndex:selected];
	NSLog(@"item selected: %@", currentObject);
	
	
}

/*
 
 Here we handle what kind of items are displayed in our list, we set the title from our [self menuItems] variable and add different accessories (think of UITableView item accessories, same kind of idea)
 
 */

%new - (id)itemForRow:(long)row {
	if(row > [[self menuItems] count])
		return nil;

	id  result = [[%c(BRMenuItem) alloc] init];
	NSString *theTitle = [[self menuItems] objectAtIndex:row];
	[result setText:theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];
	
	switch (row) {
				
		case 0:
			
			[result addAccessoryOfType:0];
			
			break;
	
		case 1: 
			
			[result addAccessoryOfType:1]; //add a > to the menuItem on the far right.
			break;
			
		default:
			
			[result addAccessoryOfType:0];
			break;
	}
	
	return [result autorelease];
}

%new - (BOOL)rowSelectable:(long)selectable {
	return TRUE;
}

%new - (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [[self menuItems] count];
}



%new - (id)titleForRow:(long)row {
	return [[self menuItems] objectAtIndex:row];
}

-(void)dealloc
{
	//[[self menuItems] release];
	
	%orig;
}


//@end

%end
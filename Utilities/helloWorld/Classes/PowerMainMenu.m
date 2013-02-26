//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

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
#define BRLocalizedString(key, comment) \
[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, table, comment) \
[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(table)]

//to get system commandss working
#include <notify.h>
#import <UIKit/UIKit.h>
#import <NSTask.h>



@class BRWebView;

@implementation PowerMainMenu

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
		[self setListTitle:APPLIANCE_MODULE_NAME]; //@property(retain) id listTitle;
		BRImage *sp = [[BRThemeInfo sharedTheme] previewActionImage];
		[self setListIcon:sp horizontalOffset:0.0 kerningFactor:0.15];
		
		_names = [[NSMutableArray alloc] init];
		[_names addObject:@"menuTitleSubtextAttributes 0"];
        [_names addObject:@"smallMenuTitleTextAttributes 1"];
        [_names addObject:@"menuItemSmallTextAttributes 2"];
        [_names addObject:@"menuItemBoldTextAttributes 3"];
        [_names addObject:@"NSLog 4"];
        [_names addObject:@"NSlog~ 5"];
        [_names addObject:@"menuTitleTextAttributes 6"];
        [_names addObject:@"setDetailedText 7"];
        [_names addObject:@"menuItemTextAttributes 8"];
        [_names addObject:@"smallHeightListDividerLabelAttributes 9"];
        [_names addObject:@"menuItemSmallTextAttributes 10*"];
        [_names addObject:@"Reboot(1) 11"];
        [_names addObject:@"reboot RB_AUTOBOOT - turn off 12*"];
        [_names addObject:@"killall -HUP SpringBoard  13"];
        [_names addObject:@"sbreload 14"];
        [_names addObject:@"reboot(0) 15"];
        [_names addObject:@"reboot(RB_HALT) 16*"];
        [_names addObject:@"echo reboot 17"];
        [_names addObject:@"killall system 18"];
        [_names addObject:@"Halt 19"];
        [_names addObject:@"screencapture 20"];
        [_names addObject:@"mdir it_works 21"];
        [_names addObject:@"write logname 22"];
        [_names addObject:@"sbreload zonder system 23"];
		
		[[self list] setDatasource:self];
        
        [[self list] addDividerAtIndex:2 withLabel:BRLocalizedString(@"Divider op 2",@"Featured menu item divider in software section")];
		[[self list] addDividerAtIndex:5 withLabel: @"Divider op 5"];
        
        [[self list] addDividerAtIndex:[_names count] withLabel:@"onder aan de lijst"];
        
        
        
		return self;
    }
    
    return self;
}

-(void)dealloc {
	[_names release];
	[super dealloc];
}


- (id)previewControlForItem:(long)item {
	BRImage* previewImage = nil;
	
	/*switch (item) {
		case 0:
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HelloWorldMainMenu class]] pathForResource:@"360iDev" ofType:@"png"]];
			break;
		case 1:
			previewImage = [[BRThemeInfo sharedTheme] largeGeniusIconWithReflection];
			break;
		case 2:
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[HelloWorldMainMenu class]] pathForResource:@"CrownePlaza" ofType:@"png"]];
			break;
	}*/
	
	BRImageAndSyncingPreviewController *controller = [[BRImageAndSyncingPreviewController alloc] init];
	[controller setImage:previewImage];
	
	return controller;
}


//#define RB_AUTOBOOT	0	/* flags for system auto-booting itself */

//#define RB_ASKNAME	0x01	/* ask for file name to reboot from */
//#define RB_SINGLE	0x02	/* reboot to single user only */
//#define RB_NOSYNC	0x04	/* dont sync before reboot */
//#define RB_KDB		0x04	/* load kernel debugger */
//#define RB_HALT		0x08	/* don't reboot, just halt */
//#define RB_INITNAME	0x10	/* name given for /etc/init */
//#define RB_DFLTROOT	0x20	/* use compiled-in rootdev */
//#define RB_ALTBOOT	0x40	/* use /boot.old vs /boot */
//#define RB_UNIPROC	0x80	/* don't start slaves */
//#define RB_SAFEBOOT	0x100	/* booting safe */
//#define RB_UPSDELAY 0x200   /* Delays restart by 5 minutes */
//#define RB_QUICK	0x400	/* quick and ungraceful reboot with file system caches flushed*/
//#define RB_PANIC	0	/* reboot due to panic */
//#define RB_BOOT		1	/* reboot due to boot() */





//next setup a method to call NSTask
-(NSString *) runThisCmd:(NSString *) runString withArgs:(NSArray *)runArgs  {
	
	NSTask *task = [NSTask new];
	[task setLaunchPath:runString];
	[task setArguments:runArgs];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardInput: [NSPipe pipe]];
	[task setStandardError: [task standardOutput]];
	[task launch];
	
	
	NSData *stdOuput = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];

	NSString *outputString = [[NSString alloc] initWithData:stdOuput encoding:NSUTF8StringEncoding];
	return outputString;

}	


-(NSString *) runForOutput:(NSString *)command {
	
	//initialize the command line to run
	//NSString *runCmd = [[NSString alloc] initWithString:@"/usr/sbin"];
	//NSArray *runArgs = [[NSArray alloc] initWithObjects:@"-c",command,nil];
	NSString *runCmd = [[NSString alloc] initWithString:@"/bin/bash"];
	NSArray *runArgs = [[NSArray alloc] initWithObjects:@"-c",@"mkdir",@"it_worksx",nil];
	
	//update proper label
	return [self runThisCmd:runCmd withArgs:runArgs];
	
	//update proper label
	//NSString *output;
	//output =  [self runThisCmd:runCmd withArgs:runArgs];
}





//Now run a bunch of commands
- (void) runSomething {
	
// NSString *hostnameLong = [self runForOutput:@"mdir it_tests"];
//   NSString *hostnameShort = [self runForOutput:@"hostname -s"];
 

   // NSString *startDate = [self runForOutput:@"date '+Start Date: %Y-%m-%d'"];
//    NSString *startTime = [self runForOutput:@"date '+Start Time: %H:%M:%S'"];
	
}


//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification


//{

	//Reboot
	/*
	NSTask *task;
	task = [NSTask launchedTaskWithLaunchPath: @"/bin/bash"
									arguments:[NSArray arrayWithObjects: scriptPath, nil]
			];
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/bin/true"];
	[task launch];
	
	
	
	
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/bin/true"];
	[task launch];
	*/
	
	
	
	//   [NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject:@"hostname -a"]]; 
	
	
	/*
	
	{
		BRAlertController *alert = [BRAlertController alertOfType:0
														   titled:@"Rebooting TV..."
													  primaryText:nil
													secondaryText:nil];
		[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"reboot -q",nil]];
		return alert;
	}
	*/
	
//}	



- (void)itemSelected:(long)selected; {
	
	//NSDictionary *currentObject = [_names objectAtIndex:selected];
	//NSLog(@"%s (%d) item selected: %@", __PRETTY_FUNCTION__, __LINE__, currentObject);

	///////////////////
	
	
	

	
	
	
	
	/////////////////////
	
	
	if (selected == 0) //Deze werkt
    {
		int result = system("killall -9 AppleTV");
    }
	else if (selected == 1) {
        
        
				NSTask *task1;
		task1 =[NSTask launchedTaskWithLaunchPath:@"/bin" arguments:[NSArray arrayWithObject:@"mkdir it_works1"]];
		[task1 setLaunchPath:@"~/"];
		[task1 launch];

        
    }
    else if (selected == 2) {
				NSTask *task3;
		task3 =[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject:@"mkdir it_works2"]]; 
		[task3 setLaunchPath:@"~/"];
		[task3 launch];
    }
    else if (selected == 3) {
				NSTask *task4;
		task4 =[NSTask launchedTaskWithLaunchPath:@"/usr/sbin" arguments:[NSArray arrayWithObject:@"mkdir it_works3"]]; 
		[task4 setLaunchPath:@"~/"];
		[task4 launch];
    }
    else if (selected == 4) 
	{
		
		
		NSTask *task = [[NSTask alloc]init]; 
		NSArray *arr = [[NSArray alloc]initWithObjects:@"/sbin/reboot",nil]; 
		[task setArguments:arr]; 
		[task launch];    
	
	
	
	}
    else if (selected == 5) {
      
		NSTask *task2;
		//task = [NSTask launchedTaskWithLaunchPath: @"/sbin/bash" arguments:[NSArray arrayWithObjects: scriptPath, nil]
		//		];
		
		task2 = [NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject:@"touch hoi"]]; 

		
		//NSTask *task2 = [[NSTask alloc] init];
		[task2 setLaunchPath:@"~/"];
		[task2 launch];
		
		
    }
    else if (selected == 6) {
        system("halt");
    }
    else if (selected == 7) {
         system("halt");
    }
    else if (selected == 8) {
        system("halt");
    }
    else if (selected == 9) {
        system("halt");
    }
    else if (selected == 10) {
        system("halt");
    }
    else if (selected == 11) {
        reboot(1);
    }
    else if (selected == 12) 
    {
        system("halt");
    }
    else if (selected == 13) {
        //system("killall -HUP SpringBoard ");
    }
    else if (selected == 14) {
        system("sbreload");
    }
    else if (selected == 15) {
        reboot(0);
    }
    else if (selected == 16) {
     //  reboot(RB_HALT);    
    }
    else if (selected == 17) {
        system("echo reboot");
    }
    else if (selected == 18)// DEZE werkt
    {
        
        NSString *exec = [NSString stringWithFormat:@"killall %s", " -9 AppleTV"];
        system([exec UTF8String]);
        
    }
    else if (selected == 19) {
        system("halt");
    }
    else if (selected == 20) {
        //system("screencapture");
		[self runForOutput: @"mdir it_tests20"];
    }
    else if (selected == 21) {
		//runForOutput:@"mdir it_tests21";
		//[self runForOutput:@"mdir it_tests"];
       // system("mkdir it_works");
    }
    else if (selected == 22) {
		[self runForOutput:@"mdir it_tests22"];
       // system("logname >logname.txt");
    }
    else if (selected == 23) 
    {
		[self runForOutput:@"system(mdir it_tests23)"];
        //system("ls");
    }
}


- (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [_names count];
}

- (id)itemForRow:(long)row {
	
    NSString *subText=@"subText"; //test waarde
   

	//NSString *hostnameShort = [self runForOutput:@"hostname -s"];
	//NSString *subText1 = hostnameShort;
	 NSString* subText1 = @"myText";

    
    
	if(row > [_names count])
		return nil;
	
	BRMenuItem* menuItem	= [[BRMenuItem alloc] init];
    

    
	NSString* menuTitle		= [_names objectAtIndex:row];
	
	[menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
        
    
	switch (row) {
			
		case 0:
			//[menuItem addAccessoryOfType:0];
			
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] menuTitleSubtextAttributes]];
            break;
		case 1: 
			//[menuItem addAccessoryOfType:1];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] smallMenuTitleTextAttributes]];

			break;
			
		case 2: 
			//[menuItem addAccessoryOfType:2];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];

			break;
		case 3: 
			//[menuItem addAccessoryOfType:3];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemBoldTextAttributes]];

			break;
		case 4: 
			//[menuItem addAccessoryOfType:4];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] metadataTitleSubtextAttributes]];

			break;
        case 5: 
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] dividerLabelAttributes]];
			//[menuItem addAccessoryOfType:5];
			break;
        case 6: //
			//[menuItem addAccessoryOfType:6];
            [menuItem setText:@"Error, " withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
            break;
        case 7: //
			[menuItem addAccessoryOfType:7];
            
            
            //[menuItem setText:@"tt" withAttributes:[[BRThemeInfo sharedTheme] boxTitleAttributesForRelated:NO ]];
           // [dividerLine setLabel:menuTitle withAttributes:[[BRThemeInfo sharedTheme] boxTitleAttributesForRelated:NO]];
            
        
            
            
			break;
        case 8: //
			//[menuItem addAccessoryOfType:8];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
			break;
        case 9: 
			//[menuItem addAccessoryOfType:9];
            [menuItem setText:menuTitle withAttributes:[[BRThemeInfo sharedTheme] smallHeightListDividerLabelAttributes]];
			break;
        case 10: 
			//[menuItem addAccessoryOfType:10];
            [menuItem setRightJustifiedText:subText withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
			break;
        case 11: 
			//[menuItem addAccessoryOfType:11];         
            [menuItem setText:subText1 withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
			break;
        case 12: 
			[menuItem addAccessoryOfType:10];
			break;
        case 13: 
			[menuItem addAccessoryOfType:25];
			break;
        case 14: 
			[menuItem addAccessoryOfType:26];
			break;
        case 15: 
			[menuItem addAccessoryOfType:27];
			break;
        case 16: 
			[menuItem addAccessoryOfType:28];
			break;
        case 17: 
			[menuItem addAccessoryOfType:29];
			break;        
        case 18: 
			[menuItem addAccessoryOfType:30];
			break;        
        case 19: 
			[menuItem addAccessoryOfType:31];
			break;        
        case 20: 
			[menuItem addAccessoryOfType:32];
			break;        
        case 21: 
			[menuItem addAccessoryOfType:33];
			break;        
        case 99: 
			[menuItem addAccessoryOfType:34];
			break;        
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

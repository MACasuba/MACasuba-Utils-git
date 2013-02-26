//
//  HelloWorldMainMenu.m
//  atvHelloWorld
//
//  Created by Michael Gile on 9/11/11.
//  Copyright 2011 Michael Gile. All rights reserved.
//

#import "LogMainMenu.h"
#import "ApplianceConfig.h"
#import "BRImageManager.h"

#include <Foundation/Foundation.h>
//#import <Foundation/NSFileManager.h>
//#import <Foundation/Foundation.h>
//#import <AVFoundation/AVFoundation.h>

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
#import <SystemConfiguration/SystemConfiguration.h>

#import <stdint.h>

#import <UIKit/UIKit.h>
#import <IOKit/IOKitLib.h>


@class BRWebView;

@implementation   LogMainMenu


- (id)init

{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
    

	self = [super init];
	if (self)
	{
		// Initialization code here.
		[self setListTitle:LOG_CATEGORY_NAME];
		
		BRImage *sp = [[BRThemeInfo sharedTheme] folderIcon];
		[self setListIcon:sp horizontalOffset:1.0 kerningFactor:1.0];
		
		_names = [[NSMutableArray alloc] init];




      //  [_names addObject: [NSString stringWithFormat: @"0- Devices JB: %c", [self JB]]];
        //[_names addObject: [NSString stringWithFormat: @"3- Jailbroken: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey: @"SignerIdentity"]]];
//        [_names addObject: [NSString stringWithFormat: @"askPassPath: %@", [self askPassPath]]];
        //[_names addObject: [NSString stringWithFormat: @"4- Jailbroken: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey: @"SignerIdentity"]]];
        //[_names addObject: [NSString stringWithFormat: @"5- Devices JB: %c", [self JB]]];
        
       // [_names addObject:[NSString stringWithFormat: @"file : %@",[self myFileName]]];
        
        [_names addObject: [NSString stringWithFormat: @"Account file: %@", [self accountname]]];
        [_names addObject: [NSString stringWithFormat: @"Account file: %@", [self accountid]]];

        [_names addObject: [NSString stringWithFormat: @"account group name: %@", [self accountnamegroup]]];//10
        [_names addObject: [NSString stringWithFormat: @"account group ID  : %@", [self accountidgroup]]];//11
        
        
        //maakt de deviders tussen de menu keuzes
		[[self list] setDatasource:self];
        
        [[self list] addDividerAtIndex:2 withLabel:[NSString stringWithFormat: @"file : %@",[self myFileName]]];
        
        [[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Divider op 0",@"Featured menu item divider in software section")];
        
        
        
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
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[LogMainMenu class]] pathForResource:@"spec_raspberrypi_png_128_outline_transp_by_durio-d4mnble" ofType:@"png"]];
			break;
		case 1://product
			//previewImage = [[BRThemeInfo sharedTheme] appleTVIconOOB];
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[LogMainMenu class]] pathForResource:@"301" ofType:@"png"]];
			break;
		case 2://ATV
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[LogMainMenu class]] pathForResource:@"302" ofType:@"png"]];
			break;
		case 3://Machine
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[LogMainMenu class]] pathForResource:@"303" ofType:@"png"]];
			break;
		case 4://ID
			previewImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[LogMainMenu class]] pathForResource:@"304" ofType:@"png"]];
			break;

	}
	
	BRImageAndSyncingPreviewController *controller = [[BRImageAndSyncingPreviewController alloc] init];
	[controller setImage:previewImage];
	
	return controller;
}

///////////////////////////////


- (NSString *) accountname
{
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDictionary *attr = [fm attributesOfItemAtPath:@"/var/log/syslog" error:&error];
	NSString *fileOwnerAccountName = [attr objectForKey:NSFileOwnerAccountName];
	return [NSString stringWithFormat:@"%@", fileOwnerAccountName ];
}

- (NSString *) accountid
{
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDictionary *attr = [fm attributesOfItemAtPath:@"/var/log/syslog" error:&error];
	NSString *fileOwnerAccountID = [attr objectForKey:NSFileOwnerAccountID];
	return [NSString stringWithFormat:@"%@", fileOwnerAccountID ];
}

- (NSString *) accountidgroup
{
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDictionary *attr = [fm attributesOfItemAtPath:@"/var/log/syslog" error:&error];
	NSString *fileGroupOwnerAccountID = [attr objectForKey:NSFileGroupOwnerAccountID];
    return [NSString stringWithFormat:@"%@", fileGroupOwnerAccountID ];
    
}

- (NSString *) accountnamegroup
{
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDictionary *attr = [fm attributesOfItemAtPath:@"/var/log/syslog" error:&error];
	NSString *fileGroupOwnerAccountName = [attr objectForKey:NSFileGroupOwnerAccountName];
	return [NSString stringWithFormat:@"%@", fileGroupOwnerAccountName ];
}


//geeft de string van de betreffende filenaam
- (NSString *) myFileName
{
    NSString *path = @"/var/log/syslog";
    NSString *logfilename = [[NSFileManager defaultManager] displayNameAtPath:path];
    return logfilename;
}


/////////////////////

- (BOOL) JB
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    if ([info objectForKey: @"SignerIdentity"] != nil){
        //am i jailbroken?
        return YES;}// Jailbroken
    {return NO;}
}

+ (void)changePermissions:(NSString *)perms onFile:(NSString *)theFile isRecursive:(BOOL)isR
{
    NSTask *permTask = [[NSTask alloc] init];
    NSMutableArray *permArgs = [[NSMutableArray alloc] init];
    if (isR)
        [permArgs addObject:@"-R"];
    [permArgs addObject:perms];
    [permArgs addObject:theFile];
    
    [permTask setLaunchPath:@"/bin/chmod"];
    
    [permTask setArguments:permArgs];
    
    //NSLog(@"chmod %@", [[permTask arguments] componentsJoinedByString:@" "]);
    [permTask launch];
    [permTask waitUntilExit];
    [permTask release];
    permTask = nil;
}

+ (void)changeOwner:(NSString *)theOwner onFile:(NSString *)theFile isRecursive:(BOOL)isR
{
    NSTask *ownTask = [[NSTask alloc] init];
    NSMutableArray *ownArgs = [[NSMutableArray alloc] init];
    [ownTask setLaunchPath:@"/usr/sbin/chown"];
    if (isR)
        [ownArgs addObject:@"-R"];
    [ownArgs addObject:theOwner];
    [ownArgs addObject:theFile];
    
    [ownTask setArguments:ownArgs];
    
    //NSLog(@"chown %@", [ownArgs componentsJoinedByString:@" "]);
    [ownArgs release];
    [ownTask launch];
    [ownTask waitUntilExit];
    [ownTask release];
    ownTask = nil;
}


- (void) setEnv
{    
    // Get the path of the Askpass program, which is
    // setup to be included as part of the main application bundle
    NSString *askPassPath = [NSBundle pathForResource:@"Askpass"
                                               ofType:@""
                                          inDirectory:[[NSBundle mainBundle] bundlePath]];
    
    //bundelPath is /Applications/AppleTV.app/Appliances/ATV2_Utils.frappliance
    
    
    NSDictionary *dict = [[NSProcessInfo processInfo] environment];
    NSString *usernameString = [dict valueForKey:@"AUTH_USERNAME"];
    NSString *hostnameString = [dict valueForKey:@"AUTH_HOSTNAME"];
    
    [[[NSProcessInfo processInfo] arguments] objectAtIndex:1];
    
    NSTask *task = [[NSTask alloc] init];
    
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    // Environment variables needed for password based authentication
    NSMutableDictionary *env = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"NONE", @"DISPLAY",
                                askPassPath, @"SSH_ASKPASS",
                                usernameString,@"AUTH_USERNAME",
                                hostnameString,@"AUTH_HOSTNAME",
                                nil];
    
    
    // Environment variable needed for key based authentication
    [env setObject:[environmentDict objectForKey:@"SSH_AUTH_SOCK"] forKey:@"SSH_AUTH_SOCK"];
    // Setting the task's environment
    [task setEnvironment:env];
    
}



- (void)itemSelected:(long)selected;{
	
	NSDictionary *currentObject = [_names objectAtIndex:selected];
	NSLog(@"%s (%d) item selected: %@", __PRETTY_FUNCTION__, __LINE__, currentObject);
	

////////////////////////
////
////  methodes hieronder werken nog niet
////
////////////////////////
    
	if (selected == 0) {
        /*

        if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            if (!success) {
                NSLog(@"Error removing file at path:");
            }
        }
        */
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/usr/bin/openssl"];
        [task setArguments:[NSArray arrayWithObjects:@"yourScript.sh", nil]];
        [task setStandardOutput:[NSPipe pipe]];
        [task setStandardInput:[NSPipe pipe]];
        
        [task launch];
        [task release];
    }
	else if (selected == 1) {
		//int result = system("hostname > File.txt");
        
        self.fileManager = [[NSFileManager alloc] init];
        NSString *path = @"/private/var/root/sample1.txt";
        NSString *contentsOfFile = @"Sample text";
        // Write File
        [contentsOfFile writeToFile:path atomically:YES
        encoding:NSUTF8StringEncoding error:nil];
    }
    
    else if (selected == 2){
        
        NSString *file = @"/var/log/test.mho";
        
        [LogMainMenu changeOwner:@"root:staff" onFile:file isRecursive:YES];

    }
    
    /*
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *path = @"/var/log/test2.mho";
        [fileManager removeItemAtPath:path error:NULL];
    }
     */
    
    else if (selected ==3)
    {
        NSString *theFile = @"/var/log/test.mho";
        
        [LogMainMenu changePermissions:@"+x" onFile:theFile isRecursive:YES];
    }
    
    
    /*
     {
        
        NSTask *task = [[NSTask alloc] init];
        
        [task setLaunchPath: @"/private/var/root"];
        NSArray *args = [NSArray arrayWithObjects:@"touch imho3.txt", nil];
        
        [task setArguments: args];
        
        NSPipe *pipe;
        pipe = [NSPipe pipe];
        [task setStandardOutput: pipe];
        
        NSFileHandle *file;
        file = [pipe fileHandleForReading];
        
        [task launch];
        
        NSData *data;
        data = [file readDataToEndOfFile];
        
        NSString *string;
        string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSLog (@"grep returned:\n%@", string);
    }
     */
    
    else if (selected ==4) {
        

        NSTask *permTask = [[NSTask alloc] init];

        [permTask setArguments:nil];
        
        [permTask setLaunchPath:@"/bin/chmod +x /var/log/test.mho"];
        
        
        //NSLog(@"chmod %@", [[permTask arguments] componentsJoinedByString:@" "]);
        [permTask launch];
       // [permTask waitUntilExit];
        //[permTask release];
       // permTask = nil;
    }
    
    
        else if (selected ==5){
            
            NSString *command = [NSString stringWithFormat:@"/bin/chmod +x /var/log/test.mho" ];
            system([command UTF8String]);
        }
    
        else if (selected ==6) {


            
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



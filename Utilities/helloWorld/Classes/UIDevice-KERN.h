//
//  UIDevice-KERN.h
//  ATV2utils
//
//  Created by admin on 20-06-12.
//  Copyright 2012 MACasuba. All rights reserved.
//

#import <Foundation/Foundation.h>

	
@interface UIDevice (KERN)
	

	
	- (NSUInteger) cpuFrequency;
	- (NSUInteger) busFrequency;
	- (NSUInteger) clockFrequency;
	
	- (NSUInteger) totalMemory;
	- (NSUInteger) userMemory;
	- (NSUInteger) imhoMemory; //test werkt
	
	- (NSUInteger) maxSocketBufferSize;
	
	- (NSUInteger) userPOSIX; //test werkt 
	- (NSTimeInterval) kernBOOT; //test werkt

	- (NSUInteger) myHostID;
	- (NSUInteger) myHostName;
	- (NSUInteger) printClockInfo;
    -(NSUInteger) printClockInfo2;

@end

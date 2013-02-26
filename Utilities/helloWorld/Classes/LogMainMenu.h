//
//  test.h
//  ATV2utils
//
//  Created by admin on 14-02-13.
//  Copyright (c) 2013 MACasuba. All rights reserved.
//

#import "BRMediaMenuController.h"
#include <Foundation/Foundation.h>
//#import <Foundation/NSFileManager.h>
//#import <Foundation/Foundation.h>
//#import <AVFoundation/AVFoundation.h>

@interface LogMainMenu : BRMediaMenuController {
	NSMutableArray		*_names;

}
//list provider
- (float)heightForRow:(long)row;
- (long)itemCount;
- (id)itemForRow:(long)row;
- (BOOL)rowSelectable:(long)selectable;
- (id)titleForRow:(long)row;
- (void) setEnv;
- (BOOL) JB;

@property (nonatomic, strong) NSFileManager *fileManager;

- (NSString *) accountid;
- (NSString *) accountname;
- (NSString *) askPassPath;
- (NSString *) accountnamegroup;
- (NSString *) accountidgroup;

@end

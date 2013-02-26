
//staat wel in mijn code
/*
#import "BRMediaMenuController.h"
#import "BRController.h"
#import "BRAXTitleChangeProtocol.h"
#import <Foundation/Foundation.h>
*/

#import "BRMediaMenuController.h"

@interface PowerMainMenu : BRMediaMenuController {
	NSMutableArray		*_names;
}
//list provider
- (float)heightForRow:(long)row;
- (long)itemCount;
- (id)itemForRow:(long)row;
- (BOOL)rowSelectable:(long)selectable;
- (id)titleForRow:(long)row;



@end

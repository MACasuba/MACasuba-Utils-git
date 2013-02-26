//
//  UISplitViewController.h
//  UIKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import <UIKit/UIKit.h>

@protocol UISplitViewControllerDelegate;

UIKIT_EXTERN_CLASS @interface UISplitViewController : UIViewController {
  @package
    id                      _delegate;
    NSMutableArray          *_viewControllers;
    UIBarButtonItem         *_barButtonItem;
    UIPopoverController     *_hiddenPopoverController;
    UIView                  *_rotationSnapshotView;
    float                   _masterColumnWidth;
    float                   _gutterWidth;
    float                   _cornerRadius;
    
    NSArray                 *_cornerImageViews;
    
    unsigned int            _isLandscape:1;
    unsigned int            _hidesMasterViewInPortrait:1;
    unsigned int            _rotatingClockwise:1;
}

@property(nonatomic,copy)       NSArray *viewControllers;  
@property(nonatomic, assign)    id <UISplitViewControllerDelegate> delegate;
@end


@protocol UISplitViewControllerDelegate

@optional

// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc;

// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;

// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
- (void)splitViewController: (UISplitViewController*)svc popoverController: (UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController;

@end


@interface UIViewController (UISplitViewController)

@property(nonatomic,readonly,retain) UISplitViewController *splitViewController; // If the view controller has a split view controller as its ancestor, return it. Returns nil otherwise.

@end

#endif // __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

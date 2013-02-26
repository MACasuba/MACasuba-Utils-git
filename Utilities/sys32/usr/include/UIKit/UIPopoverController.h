//
//  UIPopoverController.h
//  UIKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>

@class UIBarButtonItem, UIView;
@protocol UIPopoverControllerDelegate;

enum {
    UIPopoverArrowDirectionUp = 1UL << 0,
    UIPopoverArrowDirectionDown = 1UL << 1,
    UIPopoverArrowDirectionLeft = 1UL << 2,
    UIPopoverArrowDirectionRight = 1UL << 3,
    UIPopoverArrowDirectionAny = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight,
    UIPopoverArrowDirectionUnknown = NSUIntegerMax
};
typedef NSUInteger UIPopoverArrowDirection;

UIKIT_EXTERN_CLASS
@interface UIPopoverController : NSObject {
  @private
    id _delegate;
    UIViewController *_contentViewController;
    UIView *_popoverView;
    NSArray *_passthroughViews;
    UIPopoverArrowDirection _popoverArrowDirection;
    NSUInteger _popoverBackgroundStyle;
    CGSize _popoverContentSize;
    UIBarButtonItem *_targetBarButtonItem;
    UIViewAutoresizing _toViewAutoResizingMask;
    UIViewController *_modalPresentationFromViewController;
    UIViewController *_modalPresentationToViewController;
    UIViewController *_slidingViewController;
    id _target;
    SEL _didEndSelector;
    struct {
	unsigned int isPresentingOrDismissing:1;
        unsigned int isPresentingModalViewController:1;
        unsigned int isPresentingActionSheet:1;
        unsigned int needsRepresentAfterRotation:1;
	unsigned int dimsWhenModal:1;
    } _popoverControllerFlags;
}

/* The view controller provided becomes the content view controller for the UIPopoverController. This is the designated initializer for UIPopoverController.
 */
- (id)initWithContentViewController:(UIViewController *)viewController;

@property (nonatomic, assign) id <UIPopoverControllerDelegate> delegate;

/* The content view controller is the `UIViewController` instance in charge of the content view of the displayed popover. This property can be changed while the popover is displayed to allow different view controllers in the same popover session.
 */
@property (nonatomic, retain) UIViewController *contentViewController;
- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated;

/* This property allows direction manipulation of the content size of the popover. Changing the property directly is equivalent to animated=YES. The content size is limited to a minimum width of 320 and a maximum width of 600.
 */
@property (nonatomic) CGSize popoverContentSize;
- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated;

/* Returns whether the popover is visible (presented) or not.
 */
@property (nonatomic, readonly, getter=isPopoverVisible) BOOL popoverVisible;

/* Returns the direction the arrow is pointing on a presented popover. Before presentation, this returns UIPopoverArrowDirectionUnknown.
 */
@property (nonatomic, readonly) UIPopoverArrowDirection popoverArrowDirection;

/* By default, a popover disallows interaction with any view outside of the popover while the popover is presented. This property allows the specification of an array of UIView instances which the user is allowed to interact with while the popover is up.
 */
@property (nonatomic, copy) NSArray *passthroughViews;

/* -presentPopoverFromRect:inView:permittedArrowDirections:animated: allows you to present a popover from a rect in a particular view. `arrowDirections` is a bitfield which specifies what arrow directions are allowed when laying out the popover; for most uses, `UIPopoverArrowDirectionAny` is sufficient.
 */
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

/* Like the above, but is a convenience for presentation from a `UIBarButtonItem` instance. arrowDirection limited to UIPopoverArrowDirectionUp/Down
 */
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

/* Called to dismiss the popover programmatically. The delegate methods for "should" and "did" dismiss are not called when the popover is dismissed in this way.
 */
- (void)dismissPopoverAnimated:(BOOL)animated;

@end

@protocol UIPopoverControllerDelegate <NSObject>
@optional

/* Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the dismissal of the view.
 */
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController;

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;

@end

@interface UIViewController (UIPopoverController)

/* contentSizeForViewInPopover allows you to set the size of the content from within the view controller. This property is read/write, and you should generally not override it.
 */
@property (nonatomic,readwrite) CGSize contentSizeForViewInPopover __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);

/* modalInPopover is set on the view controller when you wish to force the popover hosting the view controller into modal behavior. When this is active, the popover will ignore events outside of its bounds until this is set to NO.
 */
@property (nonatomic,readwrite,getter=isModalInPopover) BOOL modalInPopover __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);

@end

#endif

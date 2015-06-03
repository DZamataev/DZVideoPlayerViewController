//
//  DZVideoPlayerViewControllerContainerView.h
//  Pods
//
//  Created by Denis Zamataev on 01/06/15.
//
//

#import <UIKit/UIKit.h>
#import "DZVideoPlayerViewController_constants.h"
@class DZVideoPlayerViewController;

@interface DZVideoPlayerViewControllerContainerView : UIView
/*
 Use this property to pick one of the suggested styles.
 One of the existing nib's will be used.
 */
@property (assign, nonatomic) DZVideoPlayerViewControllerStyle style;

/*
 Set this property to provide your own nib to provide custom view.
 Setting this property will result in ignoring 'style' property
 */
@property (assign, nonatomic) NSString *nibNameToInitControllerWith;

/*
 The controller will be created on Init, get it using this property.
 */
@property (strong, nonatomic) DZVideoPlayerViewController *videoPlayerViewController;

- (instancetype)initWithStyle:(DZVideoPlayerViewControllerStyle)style;
- (instancetype)initWithNibNameToInitControllerWith:(NSString *)nibNameToInitControllerWith;
@end

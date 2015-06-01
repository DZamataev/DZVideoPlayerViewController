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
@property (assign, nonatomic) DZVideoPlayerViewControllerStyle style;
@property (strong, nonatomic) DZVideoPlayerViewController *videoPlayerViewController;
- (instancetype)initWithStyle:(DZVideoPlayerViewControllerStyle)style;
@end

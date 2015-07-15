//
//  DZVideoPlayerViewControllerConfiguration.h
//  Pods
//
//  Created by Denis Zamataev on 15/07/15.
//
//

#import <Foundation/Foundation.h>

@interface DZVideoPlayerViewControllerConfiguration : NSObject

@property (assign, nonatomic) BOOL isBackgroundPlaybackEnabled; // defaults to NO
@property (strong, nonatomic) NSMutableArray *viewsToHideOnIdle; // has topToolbarView and bottomToolbarView by default
@property (assign, nonatomic) NSTimeInterval delayBeforeHidingViewsOnIdle; // defaults to 3 seconds
@property (assign, nonatomic) BOOL isShowFullscreenExpandAndShrinkButtonsEnabled; // defaults to YES
@property (assign, nonatomic) BOOL isHideControlsOnIdleEnabled; // defaults to YES

@end

//
//  DZVideoPlayerViewController.h
//  OhMyTube
//
//  Created by Denis Zamataev on 29/05/15.
//  Copyright (c) 2015 Mysterious Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DZVideoPlayerViewControllerDelegate.h"
#import "DZPlayerView.h"
#import "DZProgressIndicatorSlider.h"

@interface DZVideoPlayerViewController : UIViewController
@property (weak, nonatomic) id<DZVideoPlayerViewControllerDelegate> delegate;

@property (strong, nonatomic) NSURL *videoURL;
@property (assign, nonatomic) BOOL isBackgroundPlaybackEnabled; // defaults to NO
@property (strong, nonatomic) NSMutableArray *viewsToHideOnIdle; // has toolbarView by default
@property (assign, nonatomic) NSTimeInterval delayBeforeHidingViewsOnIdle; // defaults to 3 seconds

// Readonly properties
@property (readonly, nonatomic) NSTimeInterval currentPlaybackTime;
@property (readonly, nonatomic) NSTimeInterval availableDuration;
@property (readonly, nonatomic) BOOL isPlaying;

// Interface Builder Outlets
@property (weak, nonatomic) IBOutlet DZPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet DZProgressIndicatorSlider *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenShrinkButton;
//

- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically;

- (void)play;

- (void)pause;

- (void)stop;

- (void)syncUI;

- (void)toggleFullscreen:(id)sender;

- (void)seek:(UISlider *)slider;

- (void)startSeeking:(id)sender;

- (void)endSeeking:(id)sender;

- (void)updateProgressIndicator:(id)sender;

- (void)startIdleCountdown;

- (void)stopIdleCountdown;

- (void)hideControls;

- (void)showControls;

- (void)updateNowPlayingInfo;

- (NSMutableDictionary *)gatherNowPlayingInfo;
@end

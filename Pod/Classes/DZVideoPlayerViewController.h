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

#import "DZVideoPlayerViewController_constants.h"
#import "DZVideoPlayerViewControllerDelegate.h"
#import "DZVideoPlayerViewControllerConfiguration.h"
#import "DZPlayerView.h"
#import "DZProgressIndicatorSlider.h"
#import "DZVideoPlayerViewControllerContainerView.h"


@interface DZVideoPlayerViewController : UIViewController
@property (weak, nonatomic) id<DZVideoPlayerViewControllerDelegate> delegate;

@property (strong, nonatomic) DZVideoPlayerViewControllerConfiguration *configuration;

@property (strong, nonatomic) NSURL *videoURL;

// Readonly properties
@property (readonly, nonatomic) NSTimeInterval currentPlaybackTime;
@property (readonly, nonatomic) NSTimeInterval availableDuration;
@property (readonly, nonatomic) BOOL isPlaying;
@property (readonly, nonatomic) BOOL isFullscreen;

// Interface Builder Outlets
@property (weak, nonatomic) IBOutlet DZPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIView *topToolbarView;
@property (weak, nonatomic) IBOutlet UIView *bottomToolbarView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet DZProgressIndicatorSlider *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenShrinkButton;
//

+ (NSBundle*)bundle;

+ (NSString *)nibNameForStyle:(DZVideoPlayerViewControllerStyle)style;

- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically;

- (void)play;

- (void)pause;

- (void)togglePlayPause;

- (void)stop;

- (void)syncUI;

- (void)toggleFullscreen:(id)sender;

- (void)seek:(UISlider *)slider;

- (void)seekToTime:(NSTimeInterval)newPlaybackTime;

- (void)startSeeking:(id)sender;

- (void)endSeeking:(id)sender;

- (void)updateProgressIndicator:(id)sender;

- (void)startIdleCountdown;

- (void)stopIdleCountdown;

- (void)hideControls;

- (void)showControls;

- (void)updateNowPlayingInfo;

- (void)resetNowPlayingInfo;

- (NSMutableDictionary *)gatherNowPlayingInfo;
@end

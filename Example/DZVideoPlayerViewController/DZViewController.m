//
//  DZViewController.m
//  DZVideoPlayerViewController
//
//  Created by Denis Zamataev on 06/03/2015.
//  Copyright (c) 2014 Denis Zamataev. All rights reserved.
//

#import "DZViewController.h"

NSString *const kVideoFileName = @"Star Wars  Episode VII - The Force Awakens Official Teaser Trailer #1 (2015) - J.J. Abrams Movie HD";
NSString *const kVideoFileExtension = @"mp4";

@interface DZViewController () <DZVideoPlayerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewAspectRatioConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomSpaceConstraint;

@property (strong, nonatomic) IBOutlet DZVideoPlayerViewControllerContainerView *videoContainerView;
@property (strong, nonatomic) DZVideoPlayerViewController *videoPlayerViewController;

@end

@implementation DZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.videoPlayerViewController = self.videoContainerView.videoPlayerViewController;
    self.videoPlayerViewController.delegate = self;
//    self.videoPlayerViewController.configuration.isBackgroundPlaybackEnabled = NO;
//    self.videoPlayerViewController.configuration.isShowFullscreenExpandAndShrinkButtonsEnabled = NO;
//    self.videoPlayerViewController.configuration.isHideControlsOnIdleEnabled = NO;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:kVideoFileName withExtension:kVideoFileExtension];
    self.videoPlayerViewController.videoURL = fileURL;
    [self.videoPlayerViewController prepareAndPlayAutomatically:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return self.videoPlayerViewController.isFullscreen;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - <DZVideoPlayerViewControllerDelegate>

- (void)playerFailedToLoadAssetWithError:(NSError *)error {
    
}

- (void)playerDidPlay {
    
}

- (void)playerDidPause {
    
}

- (void)playerDidStop {
    
}

- (void)playerDidToggleFullscreen {
    if (self.videoPlayerViewController.isFullscreen) {
        // expand videoPlayerViewController to fullscreen
        self.contentViewAspectRatioConstraint.priority = UILayoutPriorityDefaultLow;
        self.contentViewBottomSpaceConstraint.priority = UILayoutPriorityDefaultHigh;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.contentView layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        // shrink videoPlayerViewController from fullscreen
        self.contentViewBottomSpaceConstraint.priority = UILayoutPriorityDefaultLow;
        self.contentViewAspectRatioConstraint.priority = UILayoutPriorityDefaultHigh;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.contentView layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)playerDidPlayToEndTime {
}

- (void)playerFailedToPlayToEndTime {
    
}

- (void)playerPlaybackStalled {
    
}

- (void)playerDoneButtonTouched {
    
}

- (void)playerGatherNowPlayingInfo:(NSMutableDictionary *)nowPlayingInfo {
    //    [nowPlayingInfo setObject:self.video.author forKey:MPMediaItemPropertyArtist];
    [nowPlayingInfo setObject:kVideoFileName forKey:MPMediaItemPropertyTitle];
}

@end

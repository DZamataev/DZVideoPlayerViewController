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

@property (strong, nonatomic) DZVideoPlayerViewController *videoPlayerViewController;

@property (weak, nonatomic) IBOutlet DZVideoPlayerViewControllerContainerView *videoContainerView;

@end

@implementation DZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.videoPlayerViewController = self.videoContainerView.videoPlayerViewController;
    self.videoPlayerViewController.delegate = self;
    self.videoPlayerViewController.isBackgroundPlaybackEnabled = YES;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:kVideoFileName withExtension:kVideoFileExtension];
    self.videoPlayerViewController.videoURL = fileURL;
    [self.videoPlayerViewController prepareAndPlayAutomatically:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
    }
    else {
        // shrink videoPlayerViewController from fullscreen
        
    }
    [self.videoPlayerViewController syncUI];
}

- (void)playerDidPlayToEndTime {
}

- (void)playerFailedToPlayToEndTime {
    
}

- (void)playerPlaybackStalled {
    
}

- (void)playerGatherNowPlayingInfo:(NSMutableDictionary *)nowPlayingInfo {
    //    [nowPlayingInfo setObject:self.video.author forKey:MPMediaItemPropertyArtist];
    [nowPlayingInfo setObject:kVideoFileName forKey:MPMediaItemPropertyTitle];
}

@end

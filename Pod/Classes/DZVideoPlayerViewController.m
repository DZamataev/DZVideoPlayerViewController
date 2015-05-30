//
//  DZVideoPlayerViewController.m
//  OhMyTube
//
//  Created by Denis Zamataev on 29/05/15.
//  Copyright (c) 2015 Mysterious Organization. All rights reserved.
//

#import "DZVideoPlayerViewController.h"

static const NSString *ItemStatusContext;
static const NSString *PlayerRateContext;
static const NSString *PlayerStatusContext;

@interface DZVideoPlayerViewController ()
{
    BOOL _isFullscreen;
}
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (assign, nonatomic) BOOL isSeeking;
@property (assign, nonatomic) BOOL isControlsHidden;
@property (assign, nonatomic) CGRect initialFrame;
@property (strong, nonatomic) NSTimer *idleTimer;

// Player time observer target
@property (strong, nonatomic) id playerTimeObservationTarget;

// Remote command center targets
@property (strong, nonatomic) id playCommandTarget;
@property (strong, nonatomic) id pauseCommandTarget;

@end

@implementation DZVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initialFrame = self.view.frame;
    self.viewsToHideOnIdle = [NSMutableArray new];
    [self.viewsToHideOnIdle addObject:self.toolbarView];
    self.delayBeforeHidingViewsOnIdle = 3.0;
    
    [self setupActions];
    [self setupNotifications];
    [self setupAudioSession];
    [self setupPlayer];
    [self setupRemoteCommandCenter];
    [self syncUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self resignNotifications];
    [self resignKVO];
    [self resignRemoteCommandCenter];
    [self resignPlayer];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - Properties

- (NSTimeInterval)availableDuration {
    NSTimeInterval result = 0;
    NSArray *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
    
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        result = startSeconds + durationSeconds;
    }
    
    return result;
}

- (NSTimeInterval)currentPlaybackTime {
    CMTime time = self.player.currentTime;
    if (CMTIME_IS_VALID(time)) {
        return time.value / time.timescale;
    }
    return 0;
}

- (BOOL)isPlaying {
    return [self.player rate] > 0.0f;
}

- (BOOL)isFullscreen {
    return _isFullscreen;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


#pragma mark - Public Actions

- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically {
    
    [self.activityIndicatorView startAnimating];
    
    if (self.player) {
        [self stop];
    }
    
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status" context:&ItemStatusContext];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    NSString *playableKey = @"playable";
    
    [asset loadValuesAsynchronouslyForKeys:@[playableKey] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:playableKey error:&error];
            
            if (status == AVKeyValueStatusLoaded) {
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                // ensure that this is done before the playerItem is associated with the player
                [self.playerItem addObserver:self forKeyPath:@"status"
                                     options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                     context:&ItemStatusContext];
                
                [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                
                if (playAutomatically) {
                    [self play];
                }
            }
            else {
                // You should deal with the error appropriately.
                NSLog(@"Error, the asset is not playable: %@", error);
                [self onFailedToLoadAssetWithError:error];
            }
        });
        
    }];
}

- (void)play {
    [self.player play];
    [self startIdleCountdown];
    [self syncUI];
    [self onPlay];
    [self updateNowPlayingInfo];
}

- (void)pause {
    [self.player pause];
    [self stopIdleCountdown];
    [self syncUI];
    [self onPause];
    [self updateNowPlayingInfo];
}

- (void)stop {
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
    [self stopIdleCountdown];
    [self syncUI];
    [self onStop];
    [self updateNowPlayingInfo];
}

- (void)syncUI {
    if ([self isPlaying]) {
        self.playButton.hidden = YES;
        self.playButton.enabled = NO;
        
        self.pauseButton.hidden = NO;
        self.pauseButton.enabled = YES;
    }
    else {
        self.playButton.hidden = NO;
        self.playButton.enabled = YES;
        
        self.pauseButton.hidden = YES;
        self.pauseButton.enabled = NO;
    }
    
    if (self.isFullscreen) {
        self.fullscreenExpandButton.hidden = YES;
        self.fullscreenExpandButton.enabled = NO;
        
        self.fullscreenShrinkButton.hidden = NO;
        self.fullscreenShrinkButton.enabled = YES;
    }
    else {
        self.fullscreenExpandButton.hidden = NO;
        self.fullscreenExpandButton.enabled = YES;
        
        self.fullscreenShrinkButton.hidden = YES;
        self.fullscreenShrinkButton.enabled = NO;
    }
}

- (void)toggleFullscreen:(id)sender {
    _isFullscreen = !_isFullscreen;
    [self onToggleFullscreen];
    [self startIdleCountdown];
}

- (void)seek:(UISlider *)slider {
    int timescale = self.playerItem.asset.duration.timescale;
    float time = slider.value * (self.playerItem.asset.duration.value / timescale);
    [self.player seekToTime:CMTimeMakeWithSeconds(time, timescale)];
}

- (void)startSeeking:(id)sender {
    [self stopIdleCountdown];
    self.isSeeking = YES;
}

- (void)endSeeking:(id)sender {
    [self startIdleCountdown];
    self.isSeeking = NO;
}

- (void)updateProgressIndicator:(id)sender {
    CGFloat duration = CMTimeGetSeconds(self.playerItem.asset.duration);
    
    if (duration == 0 || isnan(duration)) {
        // Video is a live stream
        self.progressIndicator.hidden = YES;
        [self.currentTimeLabel setText:nil];
        [self.remainingTimeLabel setText:nil];
    }
    else {
        self.progressIndicator.hidden = NO;
        
        CGFloat current;
        if (self.isSeeking) {
            current = self.progressIndicator.value * duration;
        }
        else {
            // Otherwise, use the actual video position
            current = CMTimeGetSeconds(self.player.currentTime);
        }
        
        [self.progressIndicator setValue:(current / duration)];
        [self.progressIndicator setSecondaryValue:([self availableDuration] / duration)];
        
        // Set time labels
        
        NSString *currentTimeString = [self stringFromTimeInterval:current];
        NSString *remainingTimeString = [self stringFromTimeInterval:duration];
        
        [self.currentTimeLabel setText:currentTimeString];
        [self.remainingTimeLabel setText:[NSString stringWithFormat:@"-%@", remainingTimeString]];
        
    }
}

- (void)startIdleCountdown {
    [self.idleTimer invalidate];
    self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayBeforeHidingViewsOnIdle
                                                      target:self selector:@selector(hideControls)
                                                    userInfo:nil repeats:NO];
}

- (void)stopIdleCountdown {
    [self.idleTimer invalidate];
}

- (void)hideControls {
    NSArray *views = self.viewsToHideOnIdle;
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in views) {
            view.alpha = 0.0;
        }
    }];
    self.isControlsHidden = YES;
}

- (void)showControls {
    NSArray *views = self.viewsToHideOnIdle;
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in views) {
            view.alpha = 1.0;
        }
    }];
    self.isControlsHidden = NO;
}

- (void)toggleControls {
    if (self.isControlsHidden) {
        [self showControls];
    }
    else {
        [self hideControls];
    }
    [self stopIdleCountdown];
}

- (void)updateNowPlayingInfo
{
    NSMutableDictionary *nowPlayingInfo = [self gatherNowPlayingInfo];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
}

- (NSMutableDictionary *)gatherNowPlayingInfo {
    NSMutableDictionary *nowPlayingInfo = [[NSMutableDictionary alloc] init];
    [nowPlayingInfo setObject:[NSNumber numberWithDouble:self.player.rate] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [nowPlayingInfo setObject:[NSNumber numberWithDouble:self.currentPlaybackTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [self onGatherNowPlayingInfo:nowPlayingInfo];
    return nowPlayingInfo;
}

#pragma mark - Private Actions

- (void)setupPlayer {
    self.player = [[AVPlayer alloc] initWithPlayerItem:nil];
    
    [self.player addObserver:self forKeyPath:@"rate"
                     options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:&PlayerRateContext];
    
    [self.player addObserver:self forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:&PlayerStatusContext];
    
    DZVideoPlayerViewController __weak *welf = self;
    self.playerTimeObservationTarget = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)  queue:nil usingBlock:^(CMTime time) {
        [welf updateProgressIndicator:welf];
    }];
    
    self.playerView.player = self.player;
    self.playerView.videoFillMode = AVLayerVideoGravityResizeAspect;
    
}

- (void)resignPlayer {
    [self.player removeTimeObserver:self.playerTimeObservationTarget];
    self.playerTimeObservationTarget = nil;
}

- (void)setupAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) { /* handle the error condition */ }
}

- (void)setupActions {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
    [self.playerView addGestureRecognizer:tapGR];
    
    [self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fullscreenShrinkButton addTarget:self action:@selector(toggleFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenExpandButton addTarget:self action:@selector(toggleFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.progressIndicator addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
    [self.progressIndicator addTarget:self action:@selector(startSeeking:) forControlEvents:UIControlEventTouchDown];
    [self.progressIndicator addTarget:self action:@selector(endSeeking:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)resignKVO {
    [self.playerItem removeObserver:self forKeyPath:@"status" context:&ItemStatusContext];
    [self.player removeObserver:self forKeyPath:@"rate" context:&PlayerRateContext];
    [self.player removeObserver:self forKeyPath:@"status" context:&PlayerStatusContext];
}

- (void)setupRemoteCommandCenter {
    DZVideoPlayerViewController __weak *welf = self;
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    self.playCommandTarget = [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [welf play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    self.pauseCommandTarget = [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [welf pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)resignRemoteCommandCenter {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand removeTarget:self.playCommandTarget];
    [commandCenter.pauseCommand removeTarget:self.pauseCommandTarget];
    self.playCommandTarget = nil;
    self.pauseCommandTarget = nil;
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemFailedToPlayToEndTime:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemPlaybackStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)resignNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Helpers

- (NSString *)stringFromTimeInterval:(NSTimeInterval)time {
    NSString *string = [NSString stringWithFormat:@"%02li:%02li:%02li",
                        lround(floor(time / 3600.)) % 100,
                        lround(floor(time / 60.)) % 60,
                        lround(floor(time)) % 60];
    
    NSString *extraZeroes = @"00:";
    
    if ([string hasPrefix:extraZeroes]) {
        string = [string substringFromIndex:extraZeroes.length];
    }
    
    return string;
}

#pragma mark - Notification Handlers

- (void)handleAVPlayerItemDidPlayToEndTime:(NSNotification *)notification {
    [self stop];
    [self onDidPlayToEndTime];
}

- (void)handleAVPlayerItemFailedToPlayToEndTime:(NSNotification *)notification {
    [self stop];
    [self onFailedToPlayToEndTime];
}

- (void)handleAVPlayerItemPlaybackStalled:(NSNotification *)notification {
    [self pause];
    [self.activityIndicatorView startAnimating];
    [self onPlaybackStalled];
}

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
    if (self.isBackgroundPlaybackEnabled) {
        self.playerView.player = nil;
    }
}

- (void)handleApplicationDidBecomeActive:(NSNotification *)notification {
    if (self.isBackgroundPlaybackEnabled) {
        self.playerView.player = self.player;
    }
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &ItemStatusContext) {
//        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self syncUI];
                       });
    }
    else if (context == &PlayerRateContext) {
        float rate = [change[NSKeyValueChangeNewKey] floatValue];
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           if (rate > 0) {
                               [self.activityIndicatorView stopAnimating];
                           }
                       });
        
    }
    else if (context == &PlayerStatusContext) {
//        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self syncUI];
                       });
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Delegate invocations

- (void)onFailedToLoadAssetWithError:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(playerFailedToLoadAssetWithError:)]) {
        [self.delegate playerFailedToLoadAssetWithError:error];
    }
}

- (void)onPlay {
    if ([self.delegate respondsToSelector:@selector(playerDidPlay)]) {
        [self.delegate playerDidPlay];
    }
}

- (void)onPause {
    if ([self.delegate respondsToSelector:@selector(playerDidPause)]) {
        [self.delegate playerDidPause];
    }
}

- (void)onStop {
    if ([self.delegate respondsToSelector:@selector(playerDidStop)]) {
        [self.delegate playerDidStop];
    }
}

- (void)onDidPlayToEndTime {
    if ([self.delegate respondsToSelector:@selector(playerDidPlayToEndTime)]) {
        [self.delegate playerDidPlayToEndTime];
    }
}

- (void)onFailedToPlayToEndTime {
    if ([self.delegate respondsToSelector:@selector(playerFailedToPlayToEndTime)]) {
        [self.delegate playerFailedToPlayToEndTime];
    }
}

- (void)onToggleFullscreen {
    if ([self.delegate respondsToSelector:@selector(playerDidToggleFullscreen)]) {
        [self.delegate playerDidToggleFullscreen];
    }
}

- (void)onPlaybackStalled {
    if ([self.delegate respondsToSelector:@selector(playerPlaybackStalled)]) {
        [self.delegate playerPlaybackStalled];
    }
}

- (void)onGatherNowPlayingInfo:(NSMutableDictionary *)nowPlayingInfo {
    if ([self.delegate respondsToSelector:@selector(playerGatherNowPlayingInfo:)]) {
        [self.delegate playerGatherNowPlayingInfo:nowPlayingInfo];
    }
}

@end
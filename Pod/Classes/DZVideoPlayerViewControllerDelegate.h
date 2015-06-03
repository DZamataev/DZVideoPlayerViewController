//
//  DZVideoPlayerViewControllerDelegate.h
//  OhMyTube
//
//  Created by Denis Zamataev on 29/05/15.
//  Copyright (c) 2015 Mysterious Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZVideoPlayerViewControllerDelegate <NSObject>

@optional

- (void)playerFailedToLoadAssetWithError:(NSError *)error;
- (void)playerDidPlay;
- (void)playerDidPause;
- (void)playerDidStop;
- (void)playerDidPlayToEndTime;
- (void)playerFailedToPlayToEndTime;
- (void)playerPlaybackStalled;
- (void)playerDoneButtonTouched;

/*
 Check isFullscreen property and animate view controller's view appropriately.
 If you don't want to support fullscreen please provide custom user interface which does not have fullscreenExpandButton and fullscreenShrinkButton, or hide the buttons in default user interface.
 */
- (void)playerDidToggleFullscreen;

/*
 Provide now playing info like this:
 [nowPlayingInfo setObject:track.artistName forKey:MPMediaItemPropertyArtist];
 [nowPlayingInfo setObject:track.trackTitle forKey:MPMediaItemPropertyTitle];
 */
- (void)playerGatherNowPlayingInfo:(NSMutableDictionary *)nowPlayingInfo;
@end

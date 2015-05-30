# DZVideoPlayerViewController

[![CI Status](http://img.shields.io/travis/Denis Zamataev/DZVideoPlayerViewController.svg?style=flat)](https://travis-ci.org/Denis Zamataev/DZVideoPlayerViewController)
[![Version](https://img.shields.io/cocoapods/v/DZVideoPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/DZVideoPlayerViewController)
[![License](https://img.shields.io/cocoapods/l/DZVideoPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/DZVideoPlayerViewController)
[![Platform](https://img.shields.io/cocoapods/p/DZVideoPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/DZVideoPlayerViewController)

##What is it

iOS Video Player control, implemented with AVPlayer.

##Screenshots

![image](https://raw.githubusercontent.com/DZamataev/DZVideoPlayerViewController/master/Screenshots/screenshot1.1.png)

![image](https://raw.githubusercontent.com/DZamataev/DZVideoPlayerViewController/master/Screenshots/screenshot2.1.png)

##About

iOS Video Player control with playback controls, remote control center commands, background playback, now playing info updates. Implemented with AVPlayer, supports both online and offline videos. Highly customizable with Interface Builder.

## Usage

This pod contains no Example project. You can find example usage of this control here at [OhMyTube github page.](https://github.com/DZamataev/OhMyTube)

Basic snippet to start with:

``` ObjC
    self.videoPlayerViewController.delegate = self;
    self.videoPlayerViewController.videoURL = [NSURL URLWithString:@"http://distilleryvesper7-3.ak.instagram.com/fdc51d8ea73611e3a15612e740d32ce3_101.mp4"];
    self.videoPlayerViewController.isBackgroundPlaybackEnabled = YES;
    [self.videoPlayerViewController prepareAndPlayAutomatically:YES];
```

Implement DZVideoPlayerViewControllerDelegate

``` ObjC
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
        // TODO: implement expand videoPlayerViewController to fullscreen
    }
    else {
        // TODO: implement shrink videoPlayerViewController from fullscreen
    }
}

- (void)playerDidPlayToEndTime {
    
}

- (void)playerFailedToPlayToEndTime {
    
}

- (void)playerPlaybackStalled {
    
}

- (void)playerGatherNowPlayingInfo:(NSMutableDictionary *)nowPlayingInfo {
//    [nowPlayingInfo setObject:self.video.author forKey:MPMediaItemPropertyArtist];
    [nowPlayingInfo setObject:self.video.title forKey:MPMediaItemPropertyTitle];
}
```

## Requirements

Runs on iOS 7.0 and later

## Customization

There are at least 3 ways to customize this control.

1. Create custom XIB and hook up the Outlets as they appear in default XIB ```(DZVideoPlayerViewController.xib)```. No need to hook actions, because they will be added programmatically in the ```DZVideoPlayerViewController``` class.
2. Subclass ```DZVideoPlayerViewController``` and provide your overrides for different methods.
3. Manipulate views by their public properties. Set images for ```playButton``` and ```pauseButton```, change tint color on ```progressIndicator```, hide ```fullscreenExpandButton``` and ```fullscreenShrink``` button if you don't want that feature.

Feel free to provide Pull Requests with custom XIBs you create. Good luck!

## Installation

DZVideoPlayerViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DZVideoPlayerViewController"
```

## Author

Denis Zamataev, denis.zamataev@gmail.com

## License

DZVideoPlayerViewController is available under the MIT license. See the LICENSE file for more info.

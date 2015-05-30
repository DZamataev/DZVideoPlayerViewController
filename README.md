# DZVideoPlayerViewController

[![CI Status](http://img.shields.io/travis/Denis Zamataev/DZVideoPlayerViewController.svg?style=flat)](https://travis-ci.org/Denis Zamataev/DZVideoPlayerViewController)
[![Version](https://img.shields.io/cocoapods/v/DZVideoPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/DZVideoPlayerViewController)
[![License](https://img.shields.io/cocoapods/l/DZVideoPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/DZVideoPlayerViewController)
[![Platform](https://img.shields.io/cocoapods/p/DZVideoPlayerViewController.svg?style=flat)](http://cocoapods.org/pods/DZVideoPlayerViewController)

##What is it

iOS Video Player control, implemented with AVPlayer.

##Screenshots

![image](https://raw.githubusercontent.com/DZamataev/DZVideoPlayerViewController/master/Screenshots/screenshot1.png)

![image](https://raw.githubusercontent.com/DZamataev/DZVideoPlayerViewController/master/Screenshots/screenshot2.png)

##About

iOS Video Player control with playback controls, remote control center commands, background playback, now playing info updates. Implemented with AVPlayer, supports both online and offline videos. Highly customizable with Interface Builder.

## Usage

This pod contains no Example project. You can find example usage of this control here at [OhMyTube github page.](https://github.com/DZamataev/OhMyTube)

Basic snippet to start with:

``` ObjC
    self.videoPlayerViewController.videoURL = [NSURL URLWithString:@"http://distilleryvesper7-3.ak.instagram.com/fdc51d8ea73611e3a15612e740d32ce3_101.mp4"];
    self.videoPlayerViewController.isBackgroundPlaybackEnabled = YES;
    [self.videoPlayerViewController prepareAndPlayAutomatically:YES];
```

## Requirements

Runs on iOS 8.0 and later

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

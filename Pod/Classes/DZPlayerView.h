//
//  DZPlayerView.h
//  OhMyTube
//
//  Created by Denis on 5/29/15.
//  Copyright (c) 2015 Mysterious Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DZPlayerView : UIView
@property (nonatomic) AVPlayer *player;
@property (nonatomic, readonly) AVPlayerLayer *playerLayer;

// defaults to AVLayerVideoGravityResizeAspect
@property (nonatomic, readwrite) NSString *videoFillMode;
@end

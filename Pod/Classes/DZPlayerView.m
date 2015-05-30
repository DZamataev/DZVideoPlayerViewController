//
//  DZPlayerView.m
//  OhMyTube
//
//  Created by Denis on 5/29/15.
//  Copyright (c) 2015 Mysterious Organization. All rights reserved.
//

#import "DZPlayerView.h"

@implementation DZPlayerView

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

#pragma mark - getters/setters

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (AVPlayerLayer *)playerLayer
{
    return (AVPlayerLayer *)self.layer;
}

- (void)setVideoFillMode:(NSString *)videoFillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[self layer];
    playerLayer.videoGravity = videoFillMode;
}

- (NSString *)videoFillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[self layer];
    return playerLayer.videoGravity;
}

@end

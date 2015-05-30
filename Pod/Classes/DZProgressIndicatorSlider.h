//
//  DZProgressIndicatorSlider.h
//  OhMyTube
//
//  Created by Denis Zamataev on 29/05/15.
//  Copyright (c) 2015 Mysterious Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZProgressIndicatorSlider : UISlider

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (void)setSecondaryValue:(float)value;
- (void)setSecondaryTintColor:(UIColor *)tintColor;
@end

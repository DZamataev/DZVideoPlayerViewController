//
//  DZPlayerButton.m
//  Pods
//
//  Created by Denis Zamataev on 03/06/15.
//
//

#import "DZPlayerButton.h"

@implementation DZPlayerButton
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    UIImage *image = [self imageForState:UIControlStateNormal];
    if (image) {
        //prepare and set image for normal state and highlighted state
        
        UIColor *normalTintColor = [self titleColorForState:UIControlStateNormal];
        UIImage *imageForNormalState = [self tintedImage:image withColor:normalTintColor];
        [self setImage:imageForNormalState forState:UIControlStateNormal];
        
        UIColor *highlightedTintColor = [self titleColorForState:UIControlStateHighlighted];
        UIImage *imageForHighlightedState = [self tintedImage:image withColor:highlightedTintColor];
        [self setImage:imageForHighlightedState forState:UIControlStateHighlighted];
        
    }
}

- (UIImage*)tintedImage:(UIImage*)image withColor:(UIColor*)color
{
    if (!color)
        return image;
    
    CGFloat scale = image.scale;
    CGSize size = CGSizeMake(scale * image.size.width, scale * image.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // ---
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    // ---
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:bitmapContext scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapContext);
    
    UIGraphicsEndImageContext();
    
    return coloredImage;
}

@end

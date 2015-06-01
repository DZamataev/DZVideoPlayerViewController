//
//  DZVideoPlayerViewControllerContainerView.m
//  Pods
//
//  Created by Denis Zamataev on 01/06/15.
//
//

#import "DZVideoPlayerViewControllerContainerView.h"
#import "DZVideoPlayerViewController.h"

@implementation DZVideoPlayerViewControllerContainerView

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

- (instancetype)initWithStyle:(DZVideoPlayerViewControllerStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    NSBundle *bundle = [DZVideoPlayerViewController bundle];
    NSString *nibName = [DZVideoPlayerViewController nibNameForStyle:self.style];
    self.videoPlayerViewController = [[DZVideoPlayerViewController alloc] initWithNibName:nibName
                                                                                   bundle:bundle];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoPlayerViewController.view.frame = self.bounds;
    [self addSubview:self.videoPlayerViewController.view];
    
    NSDictionary *viewsDictionary = @{@"view":self.videoPlayerViewController.view};
    NSMutableArray *constraintsArray = [NSMutableArray new];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"H:|[view]|"
                                           options:0 metrics:nil
                                           views:viewsDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|[view]|"
                                           options:0 metrics:nil
                                           views:viewsDictionary]];
    [self addConstraints:constraintsArray];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

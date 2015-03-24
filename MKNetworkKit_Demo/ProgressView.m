//
//  ProgressView.m
//  MKNetworkKit_Demo
//
//  Created by bella_zeng on 14-8-12.
//  Copyright (c) 2014年 Weichunhang. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"ProgressView.bundle/progress_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        UIImage *foregroundImage = [[UIImage imageNamed:@"ProgressView.bundle/progress_fg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = backgroundImage;
        
        foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        foregroundImageView.image = foregroundImage;
        
        [self addSubview:backgroundImageView];
        [self addSubview:foregroundImageView];
        
        UIEdgeInsets insets = foregroundImage.capInsets;
        minimumForegroundWidth = insets.left + insets.right;
        availableWidth = self.bounds.size.width - minimumForegroundWidth;
        
        [self changeProgressValue:0.0];
    }
    return self;
}

- (void)changeProgressValue:(float)progress {
    CGRect frame = foregroundImageView.frame;
    frame.size.width = roundf(minimumForegroundWidth + availableWidth * progress);
    foregroundImageView.frame = frame;
}

@end

//
//  ProgressView.h
//  MKNetworkKit_Demo
//
//  Created by bella_zeng on 14-8-12.
//  Copyright (c) 2014年 Weichunhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView {
    UIImageView * backgroundImageView;
    UIImageView * foregroundImageView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;
}

- (id)initWithFrame:(CGRect)frame;
- (void)changeProgressValue:(float)progress;

@end

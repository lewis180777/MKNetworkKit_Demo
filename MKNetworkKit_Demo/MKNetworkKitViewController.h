//
//  MKNetworkKitViewController.h
//  MKNetworkKit_Demo
//
//  Created by bella_zeng on 14-8-12.
//  Copyright (c) 2014年 Weichunhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"
#import <AVFoundation/AVFoundation.h>

#define HOST_NAME @"localhost:8888"
#define SUCCESS   @"1"
#define ERROR     @"2"
#define DOWNLOAD_HOST_NAME @"yinyueshiting.baidu.com"

@interface MKNetworkKitViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate> {
    NSMutableString *logOne;
    ProgressView *progressView;
    
    AVAudioPlayer *myPlayer;
    
    int last;
    int next;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextView *mainTextView;

- (IBAction)doGet:(id)sender;
- (IBAction)doPost:(id)sender;
- (IBAction)doDownload:(id)sender;

@end

//
//  MKNetworkKitViewController.m
//  MKNetworkKit_Demo
//
//  Created by bella_zeng on 14-8-12.
//  Copyright (c) 2014年 Weichunhang. All rights reserved.
//

#import "MKNetworkKitViewController.h"
#import "MKNetworkKit.h"

@interface MKNetworkKitViewController ()

@end

@implementation MKNetworkKitViewController
@synthesize nameTextField;
@synthesize passwordTextField;
@synthesize mainTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"MKNetworkKit_Demo";
    
    progressView = [[ProgressView alloc] initWithFrame:CGRectMake(20.0, 280.0,self.view.frame.size.width - 40.0, 20.0)];
    [self.view addSubview:progressView];
    
    nameTextField.returnKeyType = passwordTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.delegate = passwordTextField.delegate = self;
    mainTextView.delegate = self;
    
    logOne = [NSMutableString string];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

//    GET请求
- (IBAction)doGet:(id)sender {
    [logOne setString:@""];
    
    NSString *name = nameTextField.text;
    NSString *password = passwordTextField.text;
    if ([name isEqualToString:@""] || [password isEqualToString:@""]) {
        return;
    }
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_NAME];
    NSString *path = [NSString stringWithFormat:@"/index.php/users/login?name=%@&password=%@",nameTextField.text,passwordTextField.text];
    MKNetworkOperation *operation = [engine operationWithPath:path];
    
    [engine enqueueOperation:operation];
    [logOne appendString:[NSString stringWithFormat:@"%@\nGET请求开始\n",[[NSDate date] description]]];
    mainTextView.text = logOne;
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [logOne appendString:[NSString stringWithFormat:@"%@\nGET请求完成\n",[[NSDate date] description]]];
        NSString *result = [completedOperation responseString];
        if ([result isEqualToString:SUCCESS]) {
            [logOne appendString:[NSString stringWithFormat:@"%@\n账号密码正确\n",[[NSDate date] description]]];
        }
        else if ([result isEqualToString:ERROR]) {
            [logOne appendString:[NSString stringWithFormat:@"%@\n账号密码错误\n",[[NSDate date] description]]];
        }
        else {
            [logOne appendString:[NSString stringWithFormat:@"%@\n发生未知错误\n",[[NSDate date] description]]];
        }
        mainTextView.text = logOne;
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [logOne appendString:[NSString stringWithFormat:@"%@\nMKNetwork GET请求错误,错误原因:%@\n",[[NSDate date] description],[error description]]];
        mainTextView.text = logOne;
    }];
}

//    POST请求
- (IBAction)doPost:(id)sender {
    [logOne setString:@""];
    
    NSString *name = nameTextField.text;
    NSString *password = passwordTextField.text;
    if ([name isEqualToString:@""] || [password isEqualToString:@""]) {
        return;
    }
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_NAME];
    NSString *path = [NSString stringWithFormat:@"/index.php/users/regedit"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:name forKey:@"name"];
    [params setValue:password forKey:@"password"];
    
    MKNetworkOperation *operation = [engine operationWithPath:path params:params httpMethod:@"POST"];
    
    [engine enqueueOperation:operation];
    [logOne appendString:[NSString stringWithFormat:@"%@\nPOST请求开始\n",[[NSDate date] description]]];
    mainTextView.text = logOne;
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [logOne appendString:[NSString stringWithFormat:@"%@\nPOST请求完成\n",[[NSDate date] description]]];
        NSString *result = [completedOperation responseString];
        if ([result isEqualToString:SUCCESS]) {
            [logOne appendString:[NSString stringWithFormat:@"%@\n注册成功\n",[[NSDate date] description]]];
        }
        else if ([result isEqualToString:ERROR]) {
            [logOne appendString:[NSString stringWithFormat:@"%@\n注册失败\n",[[NSDate date] description]]];
        }
        else {
            [logOne appendString:[NSString stringWithFormat:@"%@\n发生未知错误\n",[[NSDate date] description]]];
        }
        mainTextView.text = logOne;
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [logOne appendString:[NSString stringWithFormat:@"%@\nMKNetwork POST请求错误,错误原因:%@\n",[[NSDate date] description],[error description]]];
        mainTextView.text = logOne;
    }];
}

- (IBAction)doDownload:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [logOne setString:@""];
    NSString *urlPath = @"/data2/music/41876520/1472890208800128.mp3?xcode=26ac141645adfa639cd0bb5d88ac20be5b91088bc733ce68";
	NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"笔记.mp3"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:DOWNLOAD_HOST_NAME];
    MKNetworkOperation *operation = [engine operationWithPath:urlPath];
    [operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath append:YES]];
    [engine enqueueOperation:operation];
    [logOne appendString:[NSString stringWithFormat:@"%@\n下载请求开始\n",[[NSDate date] description]]];
    mainTextView.text = logOne;
    
    [operation onDownloadProgressChanged:^(double progress) {
        button.userInteractionEnabled = NO;
        
        [progressView changeProgressValue:progress];
        next = progress * 100;
        if (next > last) {
            [button setTitle:[NSString stringWithFormat:@"已下载:%d%%\n",next] forState:UIControlStateNormal];
            last = next;
        }
    }];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        last = next = 0;
        [logOne appendString:[NSString stringWithFormat:@"%@\n下载请求已完成\n",[[NSDate date] description]]];
        mainTextView.text = logOne;
        
        [self startTimer:filePath];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [logOne appendString:[NSString stringWithFormat:@"%@\nMKNetwork POST请求错误,错误原因:%@\n",[[NSDate date] description],[error description]]];
        mainTextView.text = logOne;
    }];
}

//    5秒倒计时
- (void)startTimer:(NSString *)songPath {
    [logOne setString:@""];
    [logOne appendString:[NSString stringWithFormat:@"%@\n5S后开始下载的播放音乐\n",[[NSDate date] description]]];
    mainTextView.text = logOne;
    
    __block int timeout = 5;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:songPath] error:nil];
                [myPlayer prepareToPlay];
                [myPlayer play];
                
                [logOne appendString:[NSString stringWithFormat:@"\n正在播放音乐:周笔畅 - 笔记\n"]];
                mainTextView.text = logOne;
                
                [self performSelector:@selector(thanksObjective_C) withObject:nil afterDelay:3];
            });
        }
        else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [logOne appendString:[NSString stringWithFormat:@"=>%@ ",strTime]];
                mainTextView.text = logOne;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}

- (void)thanksObjective_C {
    [logOne appendString:@"\n=====(^_^)====="];
    mainTextView.text = logOne;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(stopMusic:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)stopMusic:(UIBarButtonItem *)button {
    [myPlayer stop];
    self.navigationItem.rightBarButtonItem = nil;
}

@end

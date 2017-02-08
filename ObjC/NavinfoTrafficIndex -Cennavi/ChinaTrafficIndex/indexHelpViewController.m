//
//  indexHelpViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-12-2.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "indexHelpViewController.h"

@interface indexHelpViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)back:(id)sender;

@end

@implementation indexHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"index_help_navinfo.html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    self.webview.scalesPageToFit = YES;
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = [request URL];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL];
    }
    
    NSString *urlString = [[request URL] absoluteString];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@":??"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":?"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if([funcStr isEqualToString:@"gotoPrePage"])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

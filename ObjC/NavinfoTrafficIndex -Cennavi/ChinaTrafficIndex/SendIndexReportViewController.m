//
//  SendIndexReportViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-12-2.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "SendIndexReportViewController.h"
#import "MBProgressHUD.h"
@interface SendIndexReportViewController ()
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)back:(id)sender;

@end

@implementation SendIndexReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DontShowReportAlert"];
    
    
    NSString* path = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"ad_invite.html"];
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
        
        if([funcStr isEqualToString:@"showAlert:"])
        {
            NSString *message = [self decodeFromPercentEscapeString:[arrFucnameAndParameter objectAtIndex:1]];
            if ([message isEqualToString:@"Start"])
            {
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                [HUD show:YES];
            }
            else
            {
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    return YES;
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

//
//  officialWebsiteViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-29.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "officialWebsiteViewController.h"

@interface officialWebsiteViewController ()

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation officialWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url =[NSURL URLWithString:@"http://nitrafficindex.com"];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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

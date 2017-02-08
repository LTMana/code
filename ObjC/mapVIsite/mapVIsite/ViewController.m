//
//  ViewController.m
//  mapVIsite
//
//  Created by 刘博通 on 16/8/3.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mapWebVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   NSString *path =   [[NSBundle mainBundle] pathForResource:@"trafficPic/transfromIndex.html" ofType:nil];
//   NSString *path=@"https://www.mapbox.com/api-documentation/?language=Objective-C#introduction";
    
//    NSString* path = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"index1.html"];
    
    NSURL *url =[NSURL URLWithString:path];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [self.mapWebVIew loadRequest:request];

}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    return YES;
}

//简图的缩放
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.mapWebVIew.scalesPageToFit = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

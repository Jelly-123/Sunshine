//
//  WebViewController.m
//  Scan Miam
//
//  Created by 秦焕 on 2018/6/28.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "ToolHeader.h"
@interface WebViewController ()

@end

@implementation WebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self load];

}
-(void)load{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navigationHeight+statusBarFrame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view = webView;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

    
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

@end

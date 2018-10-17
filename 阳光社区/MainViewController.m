//
//  MainViewController.m
//  阳光社区
//
//  Created by 秦焕 on 2018/9/12.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "MainViewController.h"
#import <WebKit/WebKit.h>
#import "ScanCodeViewController.h"
#import "ToolHeader.h"
#import "DaRenViewController.h"
#import "QuestionViewController.h"
#import "Photo_uploadViewController.h"
#import "redandblackViewController.h"
#import "WebViewController.h"


@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    WKWebView * webView;
    WKWebView * lunbo_webView;
    WKUserContentController* userContentController;
}
@end

@implementation MainViewController
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    //注册方法
    [userContentController addScriptMessageHandler:self name:@"woyaofanhui"];
    [userContentController addScriptMessageHandler:self name:@"saoyisao"];
    [userContentController addScriptMessageHandler:self name:@"tianjiadaren"];
    [userContentController addScriptMessageHandler:self name:@"redAndBlack"];
    [userContentController addScriptMessageHandler:self name:@"daiban"];
    [userContentController addScriptMessageHandler:self name:@"questionFeedback"];
    [userContentController addScriptMessageHandler:self name:@"luobotu"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航控制器的代理为self
    [self setStatusBarBackgroundColor:RGB(181,0,14,1)];
    self.navigationController.navigationBar.barTintColor = RGB(181,0,14,1);
    [self.navigationController.navigationBar setTranslucent:NO];
    //配置环境
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:configuration];
    
   
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://223.75.12.177:8188/SmartHotelInterface/shiyan_ios/index.html"]]];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    
//    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//    if (@available(iOS11.0, *)) {
//        
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        
//    } else {
//        
//        self.automaticallyAdjustsScrollViewInsets =NO;
//        
//    }
    

}
#pragma mark -- WKScriptMessageHandler
/**
 *  JS 调用 OC 时 webview 会调用此方法
 *
 *  @param userContentController  webview中配置的userContentController 信息
 *  @param message                JS执行传递的消息
 */

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"saoyisao"]) {
        NSLog(@"扫一扫");
        ScanCodeViewController * scanVC = [[ScanCodeViewController alloc]init];
        scanVC.appUserId = [message.body objectForKey:@"appUserId"];
        [self.navigationController pushViewController:scanVC animated:YES];
    } else if ([message.name isEqualToString:@"tianjiadaren"]) {
   
        DaRenViewController * darenVC =[[DaRenViewController alloc]init];
        darenVC.appUserId = [message.body objectForKey:@"appUserId"];
        darenVC.hotelId =[message.body objectForKey:@"hotelId"];
        [self.navigationController pushViewController:darenVC animated:YES];
        
    } else if ([message.name isEqualToString:@"redAndBlack"]) {
        NSLog(@"红黑榜单");
        redandblackViewController * red  = [[redandblackViewController alloc]init];
        red.categroyId = [message.body objectForKey:@"categroyId"];
        red.functionID =[message.body objectForKey:@"functionID"];
        red.hotelId =[message.body objectForKey:@"hotelId"];
        
        [self.navigationController pushViewController:red animated:YES];
        
    } else if ([message.name isEqualToString:@"daiban"]) {
        NSLog(@"社区代办");
      
        Photo_uploadViewController * daiban = [[Photo_uploadViewController alloc]init];
        daiban.appUserId = [message.body objectForKey:@"appUserId"];
        daiban.kindsCategroyId =[message.body objectForKey:@"kindsCategroyId"];
        daiban.hotelId =[message.body objectForKey:@"hotelId"];
        [self.navigationController pushViewController:daiban animated:YES];
        
    } else if ([message.name isEqualToString:@"questionFeedback"]) {
         NSLog(@"问题反馈");
        QuestionViewController * question = [[QuestionViewController alloc]init];
        question.appUserId =[message.body objectForKey:@"appUserId"];
        question.hotelId = [message.body objectForKey:@"hotelId"];
        question.type = [message.body objectForKey:@"type"];
        [self.navigationController pushViewController:question animated:YES];
        
    } else if([message.name isEqualToString:@"luobotu"]){
        NSLog(@"轮播图");
        WebViewController * web = [[WebViewController alloc]init];
        web.url =[message.body objectForKey:@"URL"];
        [self.navigationController pushViewController:web animated:YES];
    }else{
        if([message.name isEqualToString:@"woyaofanhui"]){
            NSLog(@"返回上一页");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}
//// 在请求开始加载之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"url%@",url);
    
    if ([navigationAction.request.URL.absoluteString containsString:@"alipays:"]) {
        NSLog(@"我要跳转了");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
//    if([navigationAction.request.URL.absoluteString hasPrefix:@"https://"]){
//        NSLog(@"咋没跳到这儿");
//
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
    if ([navigationAction.request.URL.absoluteString containsString:@"http:"]) {
        NSLog(@"我是http");

        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

   
}
-(NSString *)encodeString:(NSString*)unencodedString{
        
        // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
        
        // CharactersToLeaveUnescaped = @"[].";
        
        NSString *encodedString = (NSString *)
        
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)unencodedString,
                                                                  
                                                                  NULL,
                                                                  
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  
                                                                  kCFStringEncodingUTF8));
        
        return encodedString;
        
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // 因此这里要记得移除handlers
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"saoyisao"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"tianjiadaren"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"redAndBlack"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"daiban"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"questionFeedback"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"woyaofanhui"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"luobotu"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

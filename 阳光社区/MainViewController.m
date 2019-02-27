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
#import "RegisterViewController.h"

@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    WKWebView * webView;
    WKWebView * lunbo_webView;
//    WKNavigation * backNavigation;
    WKUserContentController* userContentController;
}
@property(nonatomic,strong)WKNavigation * backNavigation;
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
    [userContentController addScriptMessageHandler:self name:@"saoyisao"];  //扫一扫部分
    [userContentController addScriptMessageHandler:self name:@"tianjiadaren"];
    [userContentController addScriptMessageHandler:self name:@"redAndBlack"];
    [userContentController addScriptMessageHandler:self name:@"daiban"];
    [userContentController addScriptMessageHandler:self name:@"questionFeedback"];
    [userContentController addScriptMessageHandler:self name:@"luobotu"];   //首页轮播图部分
    [userContentController addScriptMessageHandler:self name:@"ganjinhao"];
    [userContentController addScriptMessageHandler:self name:@"registerdangyuan"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    webView = [[WKWebView alloc]initWithFrame:self.view.frame];
//    NSString *documentPath=[[NSBundle mainBundle] bundlePath];
//    NSString *filePath = [NSString stringWithFormat:@"%@%@",documentPath,@"/css/login.html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"file:///工具类/"]];
//    [self.view addSubview:webView];
//
    
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
    
//    WKProcessPool * processPool =[[WKProcessPool alloc]init];
//    configuration.processPool = processPool;
//    WKUserScript * cookieScript = [[WKUserScript alloc]initWithSource:[self ] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    configuration.preferences.javaScriptEnabled = YES;//是否支持javaScript
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;//是否能自动打开窗口

    webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:configuration];
    webView.allowsBackForwardNavigationGestures=YES;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://58.19.198.120:8188/SmartHotelInterface/shiyan_ios/index.html"]]];
//
//    NSString *documentPath=[[NSBundle mainBundle] bundlePath];
//    NSString *filePath = [NSString stringWithFormat:@"%@%@",documentPath,@"/css/login.html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"file:///工具类/"]];
//    NSString * jsStr = [NSString stringWithFormat:@"bixuhao"];
//    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"==%@----%@",result,error);
//    }];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;//在这个代理相应的协议方法可以监听加载网页的周期和结果
    [self.view addSubview:webView];
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
        
    }
    else if([message.name isEqualToString:@"luobotu"]){
        NSLog(@"轮播图");
        WebViewController * web = [[WebViewController alloc]init];
        web.url =[message.body objectForKey:@"URL"];

        [self.navigationController pushViewController:web animated:YES];

        
    }
    else if([message.name isEqualToString:@"woyaofanhui"]){
            NSLog(@"返回上一页");
            [self.navigationController popViewControllerAnimated:YES];
    }else if([message.name isEqualToString:@"ganjinhao"]) {
            NSLog(@"将收到的用户名和密码存在本地");
            self.UserName = [message.body objectForKey:@"userName"];
            self.PassWord = [message.body objectForKey:@"userPass"];
            self.appUserId = [message.body objectForKey:@"appUserId"];
            [self saveAddr:@"UserName.plist" saveKey:@"UserName" saveValue:self.UserName];
            [self saveAddr:@"UserPass.plist" saveKey:@"UserPass" saveValue:self.PassWord];
            [self saveAddr:@"appUserId.plist" saveKey:@"appUserId" saveValue:self.appUserId];
    }else if([message.name isEqualToString:@"registerdangyuan"]) {
        RegisterViewController * registerVC =[[RegisterViewController alloc]init];
        registerVC.appUserId =[message.body objectForKey:@"appUserId"];
        registerVC.areaId = [message.body objectForKey:@"areaId"];
        [self.navigationController pushViewController:registerVC animated:YES];
        
    }
    
    

}
// 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
////    [SVProgressHUDdismiss];
//
//    NSString * para = [NSString stringWithFormat:@"UserName:%@+UserPass:%@+appUserId:%@",[self saveAddr:@"UserName.plist" getKey:@"UserName"],[self saveAddr:@"UserPass.plist" getKey:@"UserPass"],[self saveAddr:@"appUserId.plist" getKey:@"appUserId"]];
//    NSLog(@"准备要给前端传了,看看我传的是什么：%@",para);
//    NSString * jsStr = [NSString stringWithFormat:@"bixuhao('%@')",para];
//    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"==%@----%@",result,error);
//    }];
//}


// 在请求开始加载之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"url%@",url);

    if ([navigationAction.request.URL.absoluteString containsString:@"alipays:"]) {
        NSLog(@"我要跳转了");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
//    if ([navigationAction.request.URL.absoluteString containsString:@"http:"]) {
//        NSLog(@"我是http");
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)saveAddr:(NSString *)addr saveKey:(NSString *)key saveValue:(NSString *)value{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *filename = [documentsPath stringByAppendingPathComponent:addr];
    NSMutableDictionary *saveDic = [[NSMutableDictionary alloc]init];
    [saveDic setObject:value forKey:key];
    [saveDic writeToFile:filename atomically:YES];
}

- (NSString *)saveAddr:(NSString *)addr getKey:(NSString *)key{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *filename = [documentsPath stringByAppendingPathComponent:addr];
    
    NSMutableDictionary *saveDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filename];
    return saveDic[key];
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
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"ganjinhao"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"registerdangyuan"];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

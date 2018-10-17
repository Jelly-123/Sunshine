//
//  ScanCodeViewController.m
//  scanmiam
//
//  Created by 秦焕 on 2018/6/18.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "ToolHeader.h"
#import <AVFoundation/AVFoundation.h>
#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "DIYAFNetworking.h"
#import "NewAdressViewController.h"

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    WKWebView * webView;
}

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, weak) UIImageView * line;
@property (nonatomic, assign) NSInteger distance;

@end

@implementation ScanCodeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //设置backBarButtonItem即可
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //初始化信息
    [self initInfo];
    
    //创建控件
    [self creatControl];
    
    //设置参数
    [self setupCamera];
    
    //添加定时器
    [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}

- (void)initInfo
{
    //backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];
    
    //navigation title
    self.navigationItem.title = @"扫一扫";
    
}
//创建控件
- (void)creatControl
{
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    CGFloat scanW =  SCREEN_WIDTH* 0.65;
    CGFloat padding = 10.0f;    //label用的时候往右挪10
    CGFloat labelH = 20.0f;     //The QR code can be ...height那行字的高度
  //  CGFloat tabBarH = 64.0f;    // 可扩展的选项栏高度
    CGFloat cornerW = 26.0f;
    CGFloat marginX = (SCREEN_WIDTH - scanW) * 0.5;
    CGFloat marginY = (SCREEN_HEIGHT - scanW - padding - labelH) * 0.5;

    //遮盖视图
    for (int i = 0; i < 4; i++) {
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, (marginY + scanW) * i, SCREEN_WIDTH, marginY + (padding + labelH) * i)];
        if (i == 2 || i == 3) {
            cover.frame = CGRectMake((marginX + scanW) * (i - 2), marginY, marginX, scanW);
        }
        cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:cover];
    }
    //这段代码很精辟，当i=0时，是框的上方。i=1时，是框的下方。i=2时，是框的左边。i=3时，是框的右边

    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY, scanW, scanW)];
    [self.view addSubview:scanView];
    
    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanW, 2)];
    [self drawLineForImageView:line]; //？
    [scanView addSubview:line]; //将线添加到框里面
    self.line = line;   //？
    
    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanW, scanW)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1.0f;
    [scanView addSubview:borderView];   //给扫描视图加上边框，边框设置颜色和宽度即可
    
    //扫描视图四个角
    for (int i = 0; i < 4; i++) {
        CGFloat imgViewX = (scanW - cornerW) * (i % 2);
        CGFloat imgViewY = (scanW - cornerW) * (i / 2);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, cornerW, cornerW)];
        if (i == 0 || i == 1) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * i);
        }else {
            imgView.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (i - 1));
        }
        [self drawImageForImageView:imgView];
        [scanView addSubview:imgView];
    }
    
    //提示标签 okay，y的坐标确定？
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scanView.frame) + padding, SCREEN_WIDTH, labelH)];
    label.text = @"将二维码放入框中,即可自动扫描。";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];

    //开启照明按钮  okay
//    UIButton * photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 550, 80, 80)];
//    [photoBtn setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
//    [photoBtn addTarget:self action:@selector(photoBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:photoBtn];
//
//    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 560, 60, 60)];
//    lightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    [lightBtn setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
//
//    [lightBtn addTarget:self action:@selector(lightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:lightBtn];
}

- (void)setupCamera
{
    //二维码扫描功能的实现步骤是创建好回话对象，用来获取从硬件设备输入的数据，并实时显示在界面上，在扫描到形影图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
    //1、创建设备会话对象，用来设置设备数据输入
//    2、获取摄像头，并且将摄像头对象加入当前会话中
//    3、实时获取摄像头原始数据显示在屏幕上
//    4、扫描到二维码/条形码数据，通过协议方法回调
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化相机设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //初始化输入流
        //AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        //初始化输出流
        //AVCaptureMetadataOutput输出类。这个支持二维码、条形码等图像数据的识别
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理，主线程刷新  设置好扫描成功回调代理以及回调线程
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        //AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
        self.session= [[AVCaptureSession alloc] init];
        //高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([self.session canAddInput:input]) [self.session addInput:input];
        if ([self.session canAddOutput:output]) [self.session addOutput:output];
        
        //条码类型（二维码/条形码）
        output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        //更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            //AVCaptureVideoPreviewLayer图层类。用来快速呈现摄像头获取的原始数据
            self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.view.layer insertSublayer:self.preview atIndex:0];
            [self.session startRunning];
        });
    });
}

- (void)addTimer
{
    _distance = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if (_distance++ > SCREEN_WIDTH * 0.65) _distance = 0;
    _line.frame = CGRectMake(0, _distance, SCREEN_WIDTH * 0.65, 2);
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

//照明按钮点击事件
- (void)lightBtnOnClick:(UIButton *)btn
{
    if(!_device.hasTorch){
        [self showAlertWithTitle:@"此设备无手电筒" message:nil sureHandler:nil cancelHandler:nil];
        return;
    }
   
    btn.selected = !btn.selected;
    [_device lockForConfiguration:nil];
    if(btn.selected){
        [_device setTorchMode:AVCaptureTorchModeOn];
    }else{
        [_device setTorchMode:AVCaptureTorchModeOff];
    }
}

//进入相册
- (void)photoBtnOnClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        [self showAlertWithTitle:@"当前设备不支持访问相册" message:nil sureHandler:nil cancelHandler:nil];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描完成
    if ([metadataObjects count] > 0) {
        //停止扫描
        NSString * scan_information = [[metadataObjects firstObject] stringValue];
        if([scan_information containsString:@"addNewLocation.html"]){
            NewAdressViewController * new = [[NewAdressViewController alloc]init];
            new.appUserId = self.appUserId;
            [self.navigationController pushViewController:new animated:YES];
             [self stopScanning];
//            NSString *path = @"http://59.152.38.197:8991/shiyan_ios/convenient/addNewLocation.html";
//            WebViewController * web =[[WebViewController alloc]init];
//            web.url = path;
//            web.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:web animated:YES];
//            [self stopScanning];
            //加载页面
//                webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://59.152.38.197:8991/shiyan/convenient/addNewLocation.html"]]];
//            [self.view addSubview:webView];
        }else{
            //发送请求
            NSLog(@"scan_information:%@",scan_information);
            NSString * scan = [[scan_information description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
            NSLog(@"2,%@",scan);
            NSArray * scan_array = [scan componentsSeparatedByString:@","];

            NSString * hotelID = [scan_array[0] substringFromIndex:10];
            NSString * roomID = [scan_array[1] substringFromIndex:9];
       
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.appUserId,@"appUserId",hotelID,@"hotelId",roomID,@"roomId",nil,@"provinceId",nil,@"stayId",nil];
               NSString * url = [NSString stringWithFormat:@"%@//SmartHotelInterface/api/appUser/scanQrCode?%@",URL,para];
          
                NSLog(@"url:%@",url);
                [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
                    NSLog(@"成功失败：%@",responseObject);
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"绑定成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:sureAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    [self stopScanning];
                    //若成功修改，则跳转至登录界面重新登录
                } FailureBlock:^(id error) {
                    NSLog(@"%@",error);
                }];
            });
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"完成发送");

            });
        }
    }
}

- (void)stopScanning
{
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [self removeTimer];
}

#pragma mark - UIImagePickerControllrDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //获取相册图片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //识别图片
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        //识别结果
        if (features.count > 0) {
            //在这里对扫描结果进行处理

            [self showAlertWithTitle:@"扫描结果" message:[[features firstObject] messageString] sureHandler:nil cancelHandler:nil];


        }else{
            [self showAlertWithTitle:@"没有识别到二维码或条形码" message:nil sureHandler:nil cancelHandler:nil];
        }
    }];
}

//提示弹窗
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sureHandler:(void (^)(void))sureHandler cancelHandler:(void (^)(void))cancelHandler
{


    if([message containsString:@"addNewLocation.html"]){
//        NSString *path = @"http://59.152.38.197:8991/shiyan/convenient/addNewLocation.html";
//        WebViewController * web =[[WebViewController alloc]init];
//        web.url = path;
//        web.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:web animated:YES];
//        [self stopScanning];
        
    }else{
        
    }
}
//绘制角图片  no
- (void)drawImageForImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//绘制线图片  no
- (void)drawLineForImageView:(UIImageView *)imageView
{
    CGSize size = imageView.bounds.size;  //线的宽、高
    UIGraphicsBeginImageContext(size);
    //创建一个基于位图的上下文，并将其设置为当前上下文
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor greenColor] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end

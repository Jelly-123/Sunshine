//
//  DaRenViewController.m
//  阳光社区
//
//  Created by 秦焕 on 2018/9/9.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "DaRenViewController.h"
#import "BRPlaceholderTextView.h"
#import "ToolHeader.h"
#import "DIYAFNetworking.h"
#import "AFNetworking.h"
#define iphone4 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#define iphone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size))
#define iphone6 (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size))
#define iphone6plus (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size))
//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300
#define margin 15
#define space 30
#define HeightVC [UIScreen mainScreen].bounds.size.height//获取设备高度
#define WidthVC [UIScreen mainScreen].bounds.size.width//获取设备宽度
@interface DaRenViewController ()<UIScrollViewDelegate,UITextViewDelegate>
{
    float _TimeNUMX;
    float _TimeNUMY;
    int _FontSIZE;
    float allViewHeight;
    //备注文本View高度
    float noteTextHeight;
}
@property(nonatomic,strong)UITextField * userName;
@property(nonatomic,strong)UITextField * name;
@property(nonatomic,strong)UITextField * yiming;
@property(nonatomic,strong)UITextField * mobile;
@property(nonatomic,strong)UITextField * address;

@property(nonatomic,strong)UILabel * userName_label;
@property(nonatomic,strong)UILabel * name_label;
@property(nonatomic,strong)UILabel * yiming_label;
@property(nonatomic,strong)UILabel * mobile_label;
@property(nonatomic,strong)UILabel * address_label;
@property(nonatomic,strong)UILabel *fengcai_label;
@property(nonatomic,strong)UILabel *techang;
/**
 *  主视图-
 */
@property (nonatomic, strong) UIScrollView *mianScrollView;
@property (nonatomic, strong) BRPlaceholderTextView *noteTextView;
//背景
@property (nonatomic, strong)UITextView * techang_textview;
@property (nonatomic, strong) UIView *noteTextBackgroudView;
//文字个数提示label
@property (nonatomic, strong) UILabel *textNumberLabel;

//文字介绍
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSString *upPeople;

@property (nonatomic,strong) UIView * lineVCThree;
@property (nonatomic,strong) UIButton * sureBtn;
@property (nonatomic,strong) NSMutableDictionary * upDic;
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic,copy)   NSString * photoStr;

@property (nonatomic,copy)   NSString * modelUrl;

@end



@implementation DaRenViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"添加达人";
    
    self.modelUrl = @"图片地址";
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    
    //监听键盘出现和消失

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _TimeNUMX = [self BackTimeNUMX];
    _TimeNUMY = [self BackTimeNUMY];
    
    [self createUI];
    
   
}

/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
//    self.view.frame = CGRectMake(0, 0-200*_TimeNUMY, WidthVC,HeightVC);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 64, WidthVC, HeightVC);
}

- (void)createUI{
    _mianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WidthVC, HeightVC)];
    _mianScrollView.contentSize =CGSizeMake(WidthVC, HeightVC);
    _mianScrollView.bounces =YES;
    _mianScrollView.showsVerticalScrollIndicator = false;
    _mianScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mianScrollView];
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
    
    /** 初始化collectionView */
    [self initPickerView];
    
    [self initViews];
}

/**
 *  初始化视图
 */
- (void)initViews{
    
    self.userName_label = [[UILabel alloc]init];
    self.userName_label.text = @"用户名:";
    self.userName_label.frame = CGRectMake(10,margin,SCREEN_WIDTH*0.25, space);
    [_mianScrollView addSubview: self.userName_label];
    
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH*0.2,margin, SCREEN_WIDTH*0.7, space)];
    self.userName.placeholder = @"  请输入用户名";
    self.userName.layer.cornerRadius = 5.0;
    [self.userName.layer setMasksToBounds:YES];
    self.userName.layer.borderColor = Color.CGColor;
    self.userName.layer.borderWidth = 1.0f;
    
    [_mianScrollView addSubview:self.userName];
    
    self.name_label = [[UILabel alloc]init];
    self.name_label.text = @"姓名:";
    self.name_label.frame = CGRectMake(10,margin*2+space,SCREEN_WIDTH*0.25, space);
    [_mianScrollView addSubview: self.name_label];
    
    self.name = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH*0.2,margin*2+space,SCREEN_WIDTH*0.7, space)];
    self.name.placeholder = @"  请输入姓名（必填）";
    self.name.layer.cornerRadius = 5.0;
    [self.name.layer setMasksToBounds:YES];
    self.name.layer.borderColor = Color.CGColor;
    self.name.layer.borderWidth = 1.0f;
    
    [_mianScrollView addSubview:self.name];
    
    self.yiming_label = [[UILabel alloc]init];
    self.yiming_label.text = @"艺名:";
    self.yiming_label.frame = CGRectMake(10,margin*3+space*2,SCREEN_WIDTH*0.25, space);
    [_mianScrollView addSubview: self.yiming_label];
    
    self.yiming = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH*0.2,margin*3+space*2, SCREEN_WIDTH*0.7, space)];
    self.yiming.placeholder = @"  请输入艺名";
    self.yiming.layer.cornerRadius = 5.0;
    [self.yiming.layer setMasksToBounds:YES];
    self.yiming.layer.borderColor = Color.CGColor;
    self.yiming.layer.borderWidth = 1.0f;
    [_mianScrollView addSubview:self.yiming];
    
    
    self.mobile_label = [[UILabel alloc]init];
    self.mobile_label.text = @"电话号码:";
    self.mobile_label.frame = CGRectMake(10,margin*4+space*3,SCREEN_WIDTH*0.25, space);
    [_mianScrollView addSubview: self.mobile_label];
    
    self.mobile = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH*0.2,margin*4+space*3,SCREEN_WIDTH*0.7, space)];
    self.mobile.placeholder = @"  请输入电话号码（必填）";
    self.mobile.layer.cornerRadius = 5.0;
    [self.mobile.layer setMasksToBounds:YES];
    self.mobile.layer.borderColor = Color.CGColor;
    self.mobile.layer.borderWidth = 1.0f;
    
    [_mianScrollView addSubview:self.mobile];
    
    
    self.address_label = [[UILabel alloc]init];
    self.address_label.text = @"家庭地址:";
    self.address_label.frame = CGRectMake(10,margin*5+space*4,SCREEN_WIDTH*0.25, space);
    [_mianScrollView addSubview: self.address_label];
    
    self.address = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH*0.2, margin*5+space*4,SCREEN_WIDTH*0.7, space)];
    self.address.placeholder = @"  请输入家庭地址";
    self.address.layer.cornerRadius = 5.0;
    [self.address.layer setMasksToBounds:YES];
    self.address.layer.borderColor = Color.CGColor;
    self.address.layer.borderWidth = 1.0f;
    
    [_mianScrollView addSubview:self.address];
    
    
//    self.fengcai_label = [[UILabel alloc]init];
//    self.fengcai_label.text = @"个人风采:";
//    self.fengcai_label.frame = CGRectMake(10,margin*7+space*5+noteTextHeight, WidthVC-20, space);
//    [_mianScrollView addSubview: self.fengcai_label];
    

    

    
    //文本输入框
//    self.techang_textview = [[UITextView alloc] initWithFrame:CGRectMake(10, margin*7+space*5+120,SCREEN_WIDTH*0.7, 100)];
//    self.techang_textview.backgroundColor = [UIColor whiteColor];
//    self.techang_textview.delegate = self;
//     self.techang_textview.scrollEnabled = NO;
//    self.techang_textview.editable = YES;
//    self.techang_textview.layer.borderWidth = 3.0;
//    self.techang_textview.layer.borderColor = Color.CGColor;
//    self.techang_textview.font = [UIFont systemFontOfSize:14];
//    // 将 textView 添加到 view
//    [_mianScrollView addSubview:self.techang_textview];
    

    _noteTextView = [[BRPlaceholderTextView alloc]init];
//    _noteTextView.frame = CGRectMake(10+SCREEN_WIDTH*0.2, margin*7+space*5+120,SCREEN_WIDTH*0.7, 100);
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    _noteTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _noteTextView.layer.borderWidth = 1.0;
    _noteTextView.maxTextLength = kMaxTextCount;
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    _noteTextView.placeholder= @" 特长介绍（必填）";
    self.noteTextView.returnKeyType = UIReturnKeyDone;
    [self.noteTextView setPlaceholderColor:[UIColor grayColor]];
    [self.noteTextView setPlaceholderOpacity:1];
//    [[NSNotificationCenter defaultCenter]addObserver:self.noteTextView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [self.noteTextView addTarget:self action:@selector(Rigist_textFiledChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    
    
    UIButton * re_setting = [UIButton buttonWithType:UIButtonTypeCustom];
    re_setting = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [re_setting setTitle:@"发表" forState:UIControlStateNormal];
   re_setting.titleLabel.font = [UIFont systemFontOfSize:17.0+_FontSIZE];
    [re_setting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    re_setting.layer.masksToBounds = YES;
    re_setting.layer.cornerRadius = 5.0;
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:re_setting];
    self.navigationItem.rightBarButtonItem = rightitem;
    [re_setting addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
//    [_mianScrollView addSubview:re_setting];

    

    [_mianScrollView addSubview:_noteTextView];
    [_mianScrollView addSubview:_textNumberLabel];

    
    [self updateViewsFrame];
    
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    self.view.frame = CGRectMake(0, 0-200*_TimeNUMY, WidthVC,HeightVC);
//    return YES;
//
//}


/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100*_TimeNUMY;
    }
    

    
//    _noteTextBackgroudView.frame = CGRectMake(0, 0, WidthVC, 70*_TimeNUMY);
    
    //文本编辑框
    //_noteTextView.frame = CGRectMake(10,self.fengcai_label.frame.origin.y+120, WidthVC-20, noteTextHeight);
    _noteTextView.frame = CGRectMake(10,margin*6+space*5,SCREEN_WIDTH-20, noteTextHeight);
    
    //文字个数提示Label
//    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15*_TimeNUMY, WidthVC-10*_TimeNUMX, 15*_TimeNUMY);
    
    
    //photoPicker
    [self updatePickerViewFrameY:margin*6+space*5+noteTextHeight-10];
    
//    self.sureBtn.frame = CGRectMake(20*_TimeNUMX, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+30*_TimeNUMY, WidthVC-40*_TimeNUMX, 40*_TimeNUMY);
    
    allViewHeight = self.noteTextView.frame.origin.y+self.noteTextView.frame.size.height+10*_TimeNUMY;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}
/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, WidthVC, 200*_TimeNUMY);
    //文本编辑框
    _noteTextView.frame = CGRectMake(0, 40*_TimeNUMY, WidthVC, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15*_TimeNUMY      , WidthVC-10*_TimeNUMX, 15*_TimeNUMY);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    [self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 100;
    }
    
    [self updateViewsFrame];
}

#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
}

#pragma mark 点击出大图方法
- (void)ClickImage:(UIButton *)sender{
    
}

#pragma mark 确定评价的方法
- (void)change{
    NSLog(@"fefew:%@",self.noteTextView.text);
    if (self.noteTextView.text.length == 0 ) {
        NSLog(@"您的评价描述字数不够哦!");
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"添加达人" message:@"您的描述字数不够哦!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
                    }];
                    [alert addAction:sureAction];
                    [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.noteTextView.text.length > kMaxTextCount) {
        NSLog(@"您的评价描述字数太多了哦!");
        return;
    }
    
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
    
    if (self.photoArr.count >9){
        NSLog(@"最多上传4张照片!");
        
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"okay");
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒"
//                                                                       message:@"发表成功"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        //取消支付
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            //这里应该接后台api 将数据输过去，等待平台管理人员确认，再在订单页面显示
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        
//        [alert addAction:cancelAction];
//        
//        
//        [self presentViewController:alert animated:YES completion:nil];
    });
    
}
-(void)request{
    //网络请求推荐餐馆
    NSLog(@"cewfe:%@",self.photoArr);
    //js调用添加达人时需要传给客户端appUserId、hotelId
            NSString * url = [NSString stringWithFormat:@"%@/ShoppingInterface/hscm/common/addFindTalent?%@",darenurl,para];
    NSLog(@"ddddddddd:%@",url);
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.name.text, @"realName",self.mobile.text,@"phone",self.noteTextView.text,@"introduction",self.address.text,@"address",self.appUserId,@"appUserId",self.hotelId,@"hotelId",self.yiming.text,@"stageName",self.userName.text,@"name",nil];
    
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < self.photoArr.count; i++) {
            
            UIImage *image = self.photoArr[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"Images" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"```上传成功``` %@",responseObject);
        NSString * resultCode = [responseObject objectForKey:@"resultDesc"];
        NSLog(@"```resultCode``` %@",resultCode);
        if ([resultCode isEqualToString:@"操作成功"]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提交失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"xxx上传失败xxx %@", error);
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"上传失败，请重新上传" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }];
}

#pragma mark 返回不同型号的机器的倍数值
- (float)BackTimeNUMX {
    float numX = 0.0;
    if (iphone4) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone5) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone6) {
        return 1.0;
    }
    if (iphone6plus) {
        numX = 414 / 375.0;
        return numX;
    }
    return numX;
}
- (float)BackTimeNUMY {
    float numY = 0.0;
    if (iphone4) {
        numY = 480 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone5) {
        numY = 568 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone6) {
        _FontSIZE = 0;
        return 1.0;
    }
    if (iphone6plus) {
        numY = 736 / 667.0;
        _FontSIZE = 2;
        return numY;
    }
    return numY;
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

//
//  QuestionViewController.m
//  阳光社区
//
//  Created by 秦焕 on 2018/9/11.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "QuestionViewController.h"
#import "BRPlaceholderTextView.h"
#import "ToolHeader.h"
#import "DIYAFNetworking.h"
#import "AFNetworking.h"
#import "HWDownSelectedView.h"
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
@interface QuestionViewController ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,HWDownSelectedViewDelegate>
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


@property(nonatomic,strong)UILabel * userName_label;
@property(nonatomic,strong)UILabel * name_label;

/**
 *  主视图-
 */
@property (nonatomic, strong) UIScrollView *mianScrollView;
@property (nonatomic, strong) BRPlaceholderTextView *noteTextView;
//背景
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
@property(nonatomic,strong)UILabel * louhaoLabel;
@property(nonatomic,strong)UILabel * danyunhao;
@property(nonatomic,strong)UILabel * fangjianhao;
@property(nonatomic,strong)UILabel * time;
@property(nonatomic,strong)UITextField *roomTF;
@property(nonatomic,strong)UITextField * timeTF;
@property(nonatomic,strong)UIDatePicker * datepicker;
@property(nonatomic,strong)UIToolbar * toolBar;
@property (nonatomic, weak) HWDownSelectedView * louhaoDown;   //民族
@property (nonatomic, weak) HWDownSelectedView * danyuanDown;   //民族
@property(nonatomic,strong)NSMutableArray *FloorNumArray;
@property(nonatomic,strong)NSMutableArray *FloorCellArray;
@end



@implementation QuestionViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @" 问题反馈";
    self.modelUrl = @"图片地址";
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _TimeNUMX = [self BackTimeNUMX];
    _TimeNUMY = [self BackTimeNUMY];
    
    _FloorNumArray = [NSMutableArray arrayWithCapacity:1];
    _FloorCellArray =[NSMutableArray arrayWithCapacity:1];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self requestLouhao];
        
    });
//    dispatch_group_notify(group, queue, ^{
//         [self requestdanyuan:self.danyuanhaoStr];
//    });
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
    self.userName_label.text = @"标题:";
    self.userName_label.frame = CGRectMake(10,margin,SCREEN_WIDTH*0.2, space);
    [_mianScrollView addSubview: self.userName_label];
    
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(10+SCREEN_WIDTH*0.2,margin, SCREEN_WIDTH*0.7, space)];
    self.userName.placeholder = @"  ";
    self.userName.layer.cornerRadius = 5.0;
    [self.userName.layer setMasksToBounds:YES];
    self.userName.layer.borderColor = Color.CGColor;
    self.userName.layer.borderWidth = 1.0f;
    [self.userName addTarget:self action:@selector(Rigist_textFiledChange:) forControlEvents:UIControlEventEditingDidEnd];
    [_mianScrollView addSubview:self.userName];
    
    self.louhaoLabel  = [[UILabel alloc]init];
    self.louhaoLabel.text = @"楼号:";
    self.louhaoLabel.frame = CGRectMake(10,margin*2+space,SCREEN_WIDTH*0.2, space);
    [_mianScrollView addSubview: self.louhaoLabel];
    
    HWDownSelectedView * louhao = [[HWDownSelectedView alloc]init];
    louhao.backgroundColor = [UIColor whiteColor];
    louhao.listArray = self.FloorNumArray;
    louhao.delegate = self;
    louhao.frame = CGRectMake(10+SCREEN_WIDTH *0.2, margin*2+space,SCREEN_WIDTH*0.7,space);
    
    self.louhaoDown = louhao;
    [_mianScrollView addSubview:self.louhaoDown];

    self.danyunhao  = [[UILabel alloc]init];
    self.danyunhao.text = @"单元号:";
    self.danyunhao.frame = CGRectMake(10,margin*3+space*2,SCREEN_WIDTH*0.2, space);
    [_mianScrollView addSubview: self.danyunhao];
    
    HWDownSelectedView * danyuan = [HWDownSelectedView new];
    danyuan.backgroundColor = [UIColor whiteColor];
//    danyuan.listArray = self.FloorCellArray;
    danyuan.delegate = self;
    danyuan.frame = CGRectMake(10+SCREEN_WIDTH *0.2, margin*3+space*2,SCREEN_WIDTH*0.7,space);
    [_mianScrollView addSubview:danyuan];
    self.danyuanDown = danyuan;
    
    self.fangjianhao  = [[UILabel alloc]init];
    self.fangjianhao.text = @"房间号:";
    self.fangjianhao.frame = CGRectMake(10,margin*4+space*3,SCREEN_WIDTH*0.2, space);
    [_mianScrollView addSubview: self.fangjianhao];
    
    self.roomTF = [[UITextField alloc]initWithFrame:CGRectMake(10+SCREEN_WIDTH*0.2,margin*4+space*3,SCREEN_WIDTH*0.7,space)];
    self.roomTF.layer.cornerRadius = 5.0;
    self.roomTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.roomTF.layer setMasksToBounds:YES];
    self.roomTF.layer.borderColor = Color.CGColor;
    self.roomTF.layer.borderWidth = 1.0f;
    [_mianScrollView addSubview:self.roomTF];
    
    self.time  = [[UILabel alloc]init];
    self.time.text = @"发生时间:";
    self.time.frame = CGRectMake(10,margin*5+space*4,SCREEN_WIDTH*0.2, space);
    [_mianScrollView addSubview: self.time];
    
    self.timeTF = [[UITextField alloc]initWithFrame:CGRectMake(10+SCREEN_WIDTH*0.2,margin*5+space*4,SCREEN_WIDTH*0.7,space)];
    self.timeTF.delegate = self;
    self.timeTF.layer.cornerRadius = 5.0;
    [self.timeTF.layer setMasksToBounds:YES];
    self.timeTF.layer.borderColor = Color.CGColor;
    self.timeTF.layer.borderWidth = 1.0f;
    [_mianScrollView addSubview:self.timeTF];

    self.toolBar = [[UIToolbar alloc]init];
    self.toolBar.frame =CGRectMake(0, 0, SCREEN_WIDTH, 44);
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.toolBar.items =@[item];
    
    self.datepicker = [[UIDatePicker alloc]init];
    self.datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    self.datepicker.locale = locale;
    
    self.name_label = [[UILabel alloc]init];
    self.name_label.text = @"内容:";
    self.name_label.frame = CGRectMake(10,margin*6+space*5,SCREEN_WIDTH*0.2, space);
    [_mianScrollView addSubview: self.name_label];
    
    
    //文本输入框
    _noteTextView = [[BRPlaceholderTextView alloc]init];
    _noteTextView.frame = CGRectMake(10+SCREEN_WIDTH*0.2,margin*6+space*5,SCREEN_WIDTH*0.7, space*5);
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    _noteTextView.layer.borderColor = Color.CGColor;
    _noteTextView.layer.borderWidth = 1.0;
    _noteTextView.maxTextLength = kMaxTextCount;
    _noteTextView.layer.cornerRadius = 5.0;
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    _noteTextView.placeholder= @" ";
    _noteTextView.backgroundColor = [UIColor whiteColor];
    self.noteTextView.returnKeyType = UIReturnKeyDone;
    [self.noteTextView setPlaceholderColor:[UIColor groupTableViewBackgroundColor]];
    [self.noteTextView setPlaceholderOpacity:1];
    _noteTextView.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
    [_mianScrollView addSubview:_noteTextView];
    
    
    //确定按钮
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:17.0+_FontSIZE];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5.0;
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:self.sureBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    [self.sureBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    
    [_mianScrollView addSubview:_noteTextBackgroudView];
    [_mianScrollView addSubview:_noteTextView];
    
    [self updateViewsFrame];
    
}
- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    if (selectedView == self.louhaoDown) {
        self.louhaoStr =self.louhaoDown.listArray[indexPath.row];
        
    
        //3.分隔字符串
   
        
        NSArray *array = [self.louhaoStr componentsSeparatedByString:@"号"]; //从字符A中分隔成2个元素的数组
           NSLog(@"楼号选择的是:%@",array[0]);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self requestdanyuan:array[0]];
            
        });
        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.danyuanDown.listArray = self.FloorCellArray;
        });
    }else if(selectedView == self.danyuanDown){
        self.danyuanhaoStr =self.danyuanDown.listArray[indexPath.row];

        NSLog(@"单元选择的是:%@",self.danyuanDown.listArray[indexPath.row]);
    }
}
-(void)requestLouhao{
    //问题反馈 需要参数：hotelId  appUserId  type
    
    
    NSString * url = [NSString stringWithFormat:@"%@/SmartHotelInterface/api/appUser/queryFloorNum?%@",dangyuanURL,para];
    [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:nil SuccessBlock:^(id responseObject) {
        if ([responseObject[@"resultDesc"] isEqualToString:@"操作成功"]) {
            for (NSDictionary * dic in responseObject[@"dataList"]) {
                NSString * str = [NSString stringWithFormat:@"%@号楼",dic[@"floorNum"]];
                [self.FloorNumArray addObject:str];
            }

        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"获取楼号失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } FailureBlock:^(id error) {
        //        NSLog(@"error",error);
    }];
}
-(void)requestdanyuan:(NSString *)danyuan{
    NSString * url = [NSString stringWithFormat:@"%@/SmartHotelInterface/api/appUser/queryFloorCell?%@",dangyuanURL,para];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:danyuan,@"floorNum",nil];
    [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject) {
        NSLog(@"11111%@",responseObject);
        if ([responseObject[@"resultDesc"] isEqualToString:@"操作成功"]) {
            NSLog(@"ddd:%@",responseObject[@"dataList"]);

            for (NSDictionary * dic in responseObject[@"dataList"]) {
                NSString * str = [NSString stringWithFormat:@"%@单元",dic[@"floorCell"]];
                [self.FloorCellArray addObject:str];
            }
            if (self.FloorCellArray.count == 0) {
                self.danyuanDown.placeholder = @"暂无数据";
            }else{
                self.danyuanDown.placeholder = @"点击选择";
                 self.danyuanDown.listArray = self.FloorCellArray;
            }
           
            NSLog(@"33333%@",self.FloorCellArray);
            
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"获取支部失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } FailureBlock:^(id error) {
        //        NSLog(@"error",error);
    }];
}
-(void)click{
    NSData * selected = [self.datepicker date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dataString = [formatter stringFromDate:selected];
    self.timeTF.text = dataString;
    [self.timeTF resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == self.timeTF){
        self.timeTF.inputView = self.datepicker;
        self.timeTF.inputAccessoryView =self.toolBar;
    }
    return YES;
}



/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    
    
    
    //photoPicker
    [self updatePickerViewFrameY:self.noteTextView.frame.origin.y+self.noteTextView.frame.size.height+margin];
    
    //    self.sureBtn.frame = CGRectMake(20*_TimeNUMX, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+30*_TimeNUMY, WidthVC-40*_TimeNUMX, 40*_TimeNUMY);
    
    
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,SCREEN_HEIGHT+100);
}


- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}



#pragma mark 确定评价的方法
- (void)change{
    NSLog(@"fefew:%@",self.noteTextView.text);
    if (self.noteTextView.text.length == 0 ) {
        NSLog(@"您的描述字数不够哦!");
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"问题反馈" message:@"您的描述字数不够哦!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.noteTextView.text.length > kMaxTextCount) {
        NSLog(@"您的描述字数太多了哦!");
        return;
    }
    
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
    
    if (self.photoArr.count >9){
        NSLog(@"最多上传9张照片!");
        
    }
    self.activity_indicator_view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.activity_indicator_view.center = _mianScrollView.center;
    [self.activity_indicator_view setUserInteractionEnabled:YES];//点击不传递事件到button
    [self.activity_indicator_view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activity_indicator_view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activity_indicator_view setBackgroundColor:[UIColor lightGrayColor]];
    [_mianScrollView addSubview:self.activity_indicator_view];
    [self.activity_indicator_view startAnimating];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.activity_indicator_view stopAnimating];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒"
//                                                                       message:@"发表成功"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
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
-(void)Rigist_textFiledChange:(UITextField *)theTextFiled{
    
    
    if(theTextFiled == self.userName){
        //NSLog(@"%@",theTextFiled.text);
        self.title1 = self.userName.text;
    }
    NSLog(@"%@",self.title1);
}
-(void)request{
    //问题反馈 需要参数：hotelId  appUserId  type

    NSLog(@"cewfe:%@",self.photoArr);

    NSString * url = [NSString stringWithFormat:@"%@/SmartHotelInterface/api/appUser/addCommunityQuestion?%@",URL,para];
    NSArray *array = [self.louhaoStr componentsSeparatedByString:@"号"];
    NSArray *array1 = [self.danyuanhaoStr componentsSeparatedByString:@"单"];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.hotelId,@"hotelId",self.title1,@"title",self.noteTextView.text,@"content",self.appUserId,@"appUserId",[NSString stringWithFormat:@"%@",self.type],@"type",self.appUserId,@"appUserId",array[0],@"floorNum",array1[0],@"floorCell",self.roomTF.text,@"roomNum",self.timeTF.text,@"happenTime",nil];
    NSLog(@"问题反馈url:%@",url);
    NSLog(@"问题反馈参数:%@",dic);

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
            NSLog(@"fileName:%@",fileName);
            [formData appendPartWithFileData:imageData name:@"images" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@",responseObject);
        [self.activity_indicator_view stopAnimating];
        NSString * resultCode = [responseObject objectForKey:@"resultDesc"];
        if ([resultCode isEqualToString:@"操作成功"]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"进行后续操作");
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
         [self.activity_indicator_view stopAnimating];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.louhaoDown close];
    [self.danyuanDown close];

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


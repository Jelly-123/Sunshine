//
//  RegisterViewController.m
//  阳光社区
//
//  Created by 秦焕 on 2018/12/20.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "RegisterViewController.h"
#import "ToolHeader.h"
#import "HWDownSelectedView.h"
#import "DIYAFNetworking.h"
#import "AFNetworking.h"
#import "HWPublishBaseController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#define margin 15
#define space 30
@interface RegisterViewController ()<HWDownSelectedViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    NSInteger genderint;
    NSInteger Flowint;
    id zhibuID;
    NSInteger successful1;
    NSInteger successful2;
}
@property(nonatomic,strong)UIScrollView * scrollerView;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UITextField * userNameTF;
@property(nonatomic,strong)UITextField * birthdayTF;
@property(nonatomic,strong)UITextField * phoneTF;
@property(nonatomic,strong)UITextField * dangyuanTF;
@property(nonatomic,strong)UITextField * starTF;
@property(nonatomic,strong)UIButton * ManButton;
@property(nonatomic,strong)UIButton * FemaleButton;
@property(nonatomic,strong)UIButton * dangyuanButton;
@property(nonatomic,strong)UIButton * IsFlowButton;
@property(nonatomic,strong)UIButton * NotFlowButton;
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic, weak) HWDownSelectedView * xueliDown;   //学历
@property (nonatomic, weak) HWDownSelectedView * minzuDown;   //民族
@property (nonatomic, weak) HWDownSelectedView * zhibuDown;   //民族

@property(nonatomic,strong)NSMutableArray * zhibuArray;
@property(nonatomic,strong)NSMutableArray * zhibuIDArray;
@property(nonatomic,strong)UIDatePicker * datepicker;
@property(nonatomic,strong)UIToolbar * toolBar;
@end

@implementation RegisterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"党员注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    genderint = 0;
    Flowint = 0;
    _zhibuArray = [NSMutableArray arrayWithCapacity:1];
    _zhibuIDArray = [NSMutableArray arrayWithCapacity:1];
    _photoArr = [NSMutableArray arrayWithCapacity:1];
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, queue, ^{
        [self request];
    });
    [self initUI];
//    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
//        [self initUI];
//    });
    // Do any additional setup after loading the view.
}
- (void)initUI{
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+150);
    [self.view addSubview:_scrollerView];
    NSArray * array = [NSArray arrayWithObjects:@"姓名:",@"性别:",@"民族:",@"生日:",@"学历:",@"政治面貌:",@"电话号码:", @"支部名称:",@"党员积分:",@"星级:",@"是否流动:",@"上传头像:",nil];
    for(int i=0;i<12;i++){
        UILabel * tmpLabel = [[UILabel alloc]init];
        tmpLabel.text = array[i];
        tmpLabel.frame = CGRectMake(15, margin*(i+1)+space*i, SCREEN_WIDTH*0.2, space);
        [_scrollerView addSubview:tmpLabel];
    }
    
    
    self.userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH *0.2, margin, SCREEN_WIDTH*0.7, space)];
    self.userNameTF.placeholder = @"必填";
    self.userNameTF.delegate = self;
    self.userNameTF.layer.cornerRadius = 5.0;
    [self.userNameTF.layer setMasksToBounds:YES];
    self.userNameTF.layer.borderColor = Color.CGColor;
    self.userNameTF.layer.borderWidth = 1.0f;
    [_scrollerView addSubview:self.userNameTF];
    
    NSArray * genderarray = [NSArray arrayWithObjects:@"女",@"男",nil];
    for (int i =0; i<2; i++) {
        UILabel * genderLabel = [[UILabel alloc]init];
        genderLabel.frame = CGRectMake(50+SCREEN_WIDTH *0.2 + 100 *i,  margin*2+space, space, space)
        ;
                                       genderLabel.text = genderarray[i];
                                       [_scrollerView addSubview:genderLabel];
    }
    
    self.ManButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ManButton.tag = 100;
    self.ManButton.frame = CGRectMake(20+SCREEN_WIDTH *0.2, margin*2+space, 25, 25);
    [self.ManButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.ManButton setBackgroundImage:[UIImage imageNamed:@"shixincircle"] forState:UIControlStateSelected];
    self.ManButton.selected = YES;
    [self.ManButton addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:self.ManButton];
    
    self.FemaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.FemaleButton.tag = 101;
    self.FemaleButton.frame = CGRectMake(SCREEN_WIDTH *0.5, margin*2+space, 25, 25);
    [self.FemaleButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.FemaleButton setBackgroundImage:[UIImage imageNamed:@"shixincircle"] forState:UIControlStateSelected];
    [self.FemaleButton addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:self.FemaleButton];
    
    NSString * jsonpath = [[NSBundle mainBundle]pathForResource:@"56个民族" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonpath];
    NSArray * jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    HWDownSelectedView * minzu = [HWDownSelectedView new];
    minzu.backgroundColor = [UIColor whiteColor];
    minzu.listArray = jsonDic;
    minzu.delegate = self;
    minzu.frame = CGRectMake(20+SCREEN_WIDTH *0.2, margin*3+space*2,SCREEN_WIDTH*0.7,space);
    [_scrollerView addSubview:minzu];
    self.minzuDown = minzu;
    
    self.birthdayTF = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH *0.2, margin*4+space*3, SCREEN_WIDTH*0.7, space)];
    self.birthdayTF.placeholder = @"必填";
     self.birthdayTF.delegate = self;
    self.birthdayTF.layer.cornerRadius = 5.0;
    [self.birthdayTF.layer setMasksToBounds:YES];
    self.birthdayTF.layer.borderColor = Color.CGColor;
    self.birthdayTF.layer.borderWidth = 1.0f;
    [_scrollerView addSubview:self.birthdayTF];
    
    self.toolBar = [[UIToolbar alloc]init];
    self.toolBar.frame =CGRectMake(0, 0, SCREEN_WIDTH, 44);
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.toolBar.items =@[item];
    
    self.datepicker = [[UIDatePicker alloc]init];
    self.datepicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    self.datepicker.locale = locale;
    
    //学历下拉框
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    down.listArray = @[@"博士",@"研究生", @"本科生",@"专科",@"高中", @"初中"];
    down.delegate = self;
    down.frame = CGRectMake(20+SCREEN_WIDTH *0.2, margin*5+space*4,SCREEN_WIDTH*0.7,space);
    [_scrollerView addSubview:down];
    self.xueliDown = down;
    
    self.dangyuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dangyuanButton.frame = CGRectMake(20+SCREEN_WIDTH *0.2, margin*6+space*5, 25, 25);
    [self.dangyuanButton setBackgroundImage:[UIImage imageNamed:@"shixincircle"] forState:UIControlStateNormal];
    self.dangyuanButton.userInteractionEnabled = NO;
    [_scrollerView addSubview:self.dangyuanButton];
    
    //支部名称
    HWDownSelectedView * zhibu = [HWDownSelectedView new];
    zhibu.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@",self.zhibuArray);
    zhibu.listArray = self.zhibuArray;
    zhibu.delegate = self;
    zhibu.frame = CGRectMake(20+SCREEN_WIDTH *0.2, margin*8+space*7,SCREEN_WIDTH*0.7,space);
    [_scrollerView addSubview:zhibu];
    self.zhibuDown = zhibu;
    UILabel * dangyuanLabel = [[UILabel alloc]init];
    dangyuanLabel.text = @"党员";
    dangyuanLabel.frame = CGRectMake(50+SCREEN_WIDTH *0.2 , margin*6+space*5, 100, space);
    [_scrollerView addSubview:dangyuanLabel];
    
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH *0.2, margin*7+space*6, SCREEN_WIDTH*0.7, space)];
    self.phoneTF.layer.cornerRadius = 5.0;
    self.phoneTF.delegate =self;
    self.phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneTF.placeholder = @"必填";
    [self.phoneTF.layer setMasksToBounds:YES];
    self.phoneTF.layer.borderColor = Color.CGColor;
    self.phoneTF.layer.borderWidth = 1.0f;
    [_scrollerView addSubview:self.phoneTF];
    
 
    self.dangyuanTF = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH *0.2, margin*9+space*8, SCREEN_WIDTH*0.7, space)];
    self.dangyuanTF.placeholder = @"选填";
    self.dangyuanTF.delegate =self;
    self.dangyuanTF.layer.cornerRadius = 5.0;
    [self.dangyuanTF.layer setMasksToBounds:YES];
    self.dangyuanTF.layer.borderColor = Color.CGColor;
    self.dangyuanTF.layer.borderWidth = 1.0f;
    [_scrollerView addSubview:self.dangyuanTF];
    
    self.starTF = [[UITextField alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH *0.2, margin*10+space*9, SCREEN_WIDTH*0.7, space)];
    self.starTF.layer.cornerRadius = 5.0;
    self.starTF.delegate =self;
    [self.starTF.layer setMasksToBounds:YES];
    self.starTF.placeholder = @"选填";
    self.starTF.layer.borderColor = Color.CGColor;
    self.starTF.layer.borderWidth = 1.0f;
    [_scrollerView addSubview:self.starTF];
    NSArray * Flowarray = [NSArray arrayWithObjects:@"是",@"否",nil];
    for (int i =0; i<2; i++) {
        UILabel * flowLabel = [[UILabel alloc]init];
        flowLabel.frame = CGRectMake(50+SCREEN_WIDTH *0.2 + 100 *i, margin*11+space*10, space, space)
        ;
        flowLabel.text = Flowarray[i];
        [_scrollerView addSubview:flowLabel];
    }
    
    self.IsFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.IsFlowButton.tag = 200;
    self.IsFlowButton.frame = CGRectMake(20+SCREEN_WIDTH *0.2, margin*11+space*10, 25, 25);
    [self.IsFlowButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.IsFlowButton setBackgroundImage:[UIImage imageNamed:@"shixincircle"] forState:UIControlStateSelected];
    self.IsFlowButton.selected = YES;
    [self.IsFlowButton addTarget:self action:@selector(Flow:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:self.IsFlowButton];
    
    self.NotFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.NotFlowButton.tag = 201;
    self.NotFlowButton.frame = CGRectMake(SCREEN_WIDTH *0.5,margin*11+space*10, 25, 25);
    [self.NotFlowButton setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [self.NotFlowButton setBackgroundImage:[UIImage imageNamed:@"shixincircle"] forState:UIControlStateSelected];
    [self.NotFlowButton addTarget:self action:@selector(Flow:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:self.NotFlowButton];
    
    self.addImage =[UIButton buttonWithType:UIButtonTypeCustom];
//    addImage.backgroundColor =[UIColor redColor];
    self.addImage.frame = CGRectMake(15, margin*13+space*12,100,100);
    [self.addImage setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];

    [self.addImage addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:self.addImage];
    
    //确定按钮
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5.0;
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:self.sureBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    [self.sureBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
}

//点击男女按钮
-(void)press:(UIButton *)sender{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (sender.tag == 100) {
        [[self.view viewWithTag:61]removeFromSuperview];
        button = (UIButton *)[self.view viewWithTag:101];
        genderint = 1;
    }else{
        [[self.view viewWithTag:61]removeFromSuperview];
        button = (UIButton *)[self.view viewWithTag:100];
        genderint = 0;
    }
    sender.selected = !sender.selected;
    button.selected = !button.selected;
    sender.userInteractionEnabled = NO;
    button.userInteractionEnabled = YES;
  
}
-(void)click{
    NSData * selected = [self.datepicker date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * dataString = [formatter stringFromDate:selected];
    self.birthdayTF.text = dataString;
    [self.birthdayTF resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == self.birthdayTF){
        self.birthdayTF.inputView = self.datepicker;
        self.birthdayTF.inputAccessoryView =self.toolBar;
    }
    return YES;
}
-(void)Flow:(UIButton *)sender{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (sender.tag == 200) {
        [[self.view viewWithTag:61]removeFromSuperview];
        button = (UIButton *)[self.view viewWithTag:201];
        Flowint = 0;
    }else{
        [[self.view viewWithTag:61]removeFromSuperview];
        button = (UIButton *)[self.view viewWithTag:200];
        Flowint = 1;
    }
    sender.selected = !sender.selected;
    button.selected = !button.selected;
    sender.userInteractionEnabled = NO;
    button.userInteractionEnabled = YES;
}
- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    if (selectedView == self.xueliDown){
        self.xueliStr =self.xueliDown.listArray[indexPath.row];
        NSLog(@"学历选择的是:%@",self.xueliDown.listArray[indexPath.row]);
    }else if(selectedView == self.zhibuDown){
        self.zhibuStr =self.zhibuDown.listArray[indexPath.row];
        zhibuID = self.zhibuIDArray[indexPath.row];
        NSLog(@"支部选择的是:%@",self.zhibuDown.listArray[indexPath.row]);
    }else if(selectedView == self.minzuDown){
        self.MinzuStr = self.minzuDown.listArray[indexPath.row];
        NSLog(@"民族选择的是:%@",self.minzuDown.listArray[indexPath.row]);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.userNameTF) {
        self.userName = self.userNameTF.text;
    }else if(textField == self.birthdayTF){
        self.birthday = self.birthdayTF.text;
    }else if(textField == self.phoneTF){
        self.phone = self.phoneTF.text;
    }else if(textField == self.dangyuanTF){
        self.partyPoint = self.dangyuanTF.text;
    }else if (textField == self.starTF){
        self.starStr = self.starTF.text;
    }
}
-(void)chooseImage{
    UIAlertController * actionsheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takephoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取摄像头，修改info.plist
        [self takePhoto];
    }];
    UIAlertAction * photoFlow = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取手机相册，修改info.plist
        [self localPhoto];
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionsheetController addAction:takephoto];
    [actionsheetController addAction:photoFlow];
    [actionsheetController addAction:cancell];
    [self presentViewController:actionsheetController animated:YES completion:^{
        
    }];
    
}
//开始拍照
-(void)takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        //先检查相机是否可以使用
        BOOL camerIsAvailable = [self checkCamera];
        if (YES == camerIsAvailable) {
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许本应用程序访问你的相机。" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
-(BOOL)checkCamera{
    NSString * mediaType =AVMediaTypeVideo;
    AVAuthorizationStatus anthstatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (AVAuthorizationStatusRestricted == anthstatus || AVAuthorizationStatusDenied == anthstatus) {
        return NO;
    }
    return YES;
}
-(void)localPhoto{
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}
#pragma mark UIImagePickerControllerDelegate Call back Implementation
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    NSString * type = [info objectForKey:@"UIImagePickerControllerMediaType"];
    //当选择的类型是图片时
    if ([type isEqualToString:@"public.image"]) {
        NSString * key = nil;
        if (picker.allowsEditing) {
            key = UIImagePickerControllerEditedImage;
        }else{
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage * image = [info objectForKey:key];
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            //压缩图片质量
            image =[self reduceImage:image percent:0.1];
            CGSize imageSize =image.size;
            imageSize.height = 320;
            imageSize.width = 320;
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }
        //上传到服务器
        
        [self.addImage setImage:image forState:UIControlStateNormal];
        [_photoArr addObject:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
//2.当用户取消选取时调用；
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage *)reduceImage:(UIImage *)image percent:(float)persent{
    NSData * imageData = UIImageJPEGRepresentation(image,persent);
    UIImage * newImage = [UIImage imageWithData:imageData];
    return newImage;
}
-(UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.minzuDown close];
    [self.zhibuDown close];
    [self.xueliDown close];
    [self.userNameTF resignFirstResponder];
    [self.birthdayTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.dangyuanTF resignFirstResponder];
    [self.starTF resignFirstResponder];
}
-(void)request{
    //问题反馈 需要参数：hotelId  appUserId  type

    
    NSString * url = [NSString stringWithFormat:@"%@/SmartHotelInterface/api/appUser/queryBranchList?%@",dangyuanURL,para];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.areaId,@"areaId",nil];
    [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"resultDesc"] isEqualToString:@"操作成功"]) {
            for (NSDictionary * dic in responseObject[@"dataList"]) {
                [self.zhibuArray addObject:dic[@"name"]];
                [self.zhibuIDArray addObject:dic[@"id"]];
            }
           
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
-(void)publish{

    if([self.userNameTF.text isEqualToString:@""] || [self.MinzuStr isEqualToString:@""] || [self.birthdayTF.text isEqualToString:@""] || [self.xueliStr isEqualToString:@""] || [self.phoneTF.text isEqualToString:@""] || [self.zhibuStr isEqualToString:@""] ){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请补充完整您的信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"进行后续操作");
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        self.activity_indicator_view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.activity_indicator_view.center = _scrollerView.center;
        [self.activity_indicator_view setUserInteractionEnabled:YES];//点击不传递事件到button
        [self.activity_indicator_view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.activity_indicator_view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activity_indicator_view setBackgroundColor:[UIColor lightGrayColor]];
        [_scrollerView addSubview:self.activity_indicator_view];
        [self.activity_indicator_view startAnimating];
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);

        dispatch_group_t group = dispatch_group_create();

        dispatch_group_async(group, queue, ^{
            [self requestPublish];
        });


    }
}
-(void)requestPublish{
    NSString * url = [NSString stringWithFormat:@"%@/SmartHotelInterface/api/appUser/addPartyMemInfo?%@",URL,para];
    NSLog(@"username:%@",self.userName);
    NSLog(@"genderint:%ld",(long)genderint);
    NSLog(@"MinzuStr:%@",self.MinzuStr);
    NSLog(@"birthday:%@",self.birthday);
    NSLog(@"xueliStr:%@",self.xueliStr);
    NSLog(@"zhibuID:%@",zhibuID);
    NSLog(@"phone:%@",self.phone);
    NSLog(@"starStr:%@",self.starStr);
    NSLog(@"Flowint:%ld",(long)Flowint);
    NSLog(@"self.appUserId:%@",self.appUserId);
    if (self.starStr == NULL) {
        self.starStr = @"0";
    }
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.userName,@"name",[NSString stringWithFormat:@"%ld",genderint],@"sex",self.MinzuStr,@"nation",self.birthday,@"birthDate",self.xueliStr,@"education",@"dangyuan",@"politicalOutlook",zhibuID,@"partyBranchId",self.zhibuStr,@"parchName",self.phone,@"phone",@"0",@"integral",self.starStr,@"starRank",[NSString stringWithFormat:@"%ld",Flowint],@"isFlowParty",self.appUserId,@"appUserId",nil];
    NSLog(@"党员注册url:%@",url);
    NSLog(@"党员注册参数:%@",dic);
    [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:dic SuccessBlock:^(id responseObject) {
        if([responseObject[@"resultDesc"]isEqualToString:@"操作成功"]){
            if (self.photoArr[0]==NULL) {
                return ;
            }else{
                dispatch_queue_t queue = dispatch_get_global_queue(0,0);
                
                dispatch_group_t group = dispatch_group_create();
                
                dispatch_group_async(group, queue, ^{
                    [self requestImage];
                });
            }
        }
        
    } FailureBlock:^(id error) {
        NSLog(@"%@",error);

    }];
}
-(void)requestImage{
        // 基于AFN3.0+ 封装的HTPPSession句柄
    UIImage *image = self.photoArr[0];

    NSString * url = [NSString stringWithFormat:@"%@/SmartHotelInterface/api/appUser/addUserIcon?%@",URL,para];
        
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.appUserId,@"id",nil];
    NSLog(@"党员注册url:%@",url);
    NSLog(@"党员注册参数:%@",dic);
    
    NSData *data = [[NSData alloc]init];
    
    data = UIImagePNGRepresentation(image);

    //创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    //上传文件
    

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件
        [formData appendPartWithFileData:data name:@"icon" fileName:@"userhader.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf",progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功后
        NSLog(@"请求成功：%@",responseObject);
        [self.activity_indicator_view stopAnimating];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"进行后续操作");
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败后
        [self.activity_indicator_view stopAnimating];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"进行后续操作");
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    
    }];
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

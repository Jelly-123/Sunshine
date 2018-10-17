//
//  NewAdressViewController.m
//  阳光社区
//
//  Created by 秦焕 on 2018/9/26.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "NewAdressViewController.h"
#import "ToolHeader.h"
#import "ManageAddressTableViewController.h"
#import "DIYAFNetworking.h"
@interface NewAdressViewController ()
@property(strong , nonatomic)UITextField *nameTextFiled;
@property(strong , nonatomic)UITextField *phoneTextFiled;
@property(strong , nonatomic)UITextField *addressFiled;

//属性值
@property(strong , nonatomic) NSString *phoneText;
@property(strong , nonatomic) NSString *nameText;
@property(strong , nonatomic) NSString *addressText;
@end

@implementation NewAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增地址";
    //回收键盘
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //设置backBarButtonItem即可
    self.navigationItem.backBarButtonItem = backItem;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBG:)];
    [self.view addGestureRecognizer:tapGesture];

    self.view.backgroundColor = RGB(220, 220, 220, 1);
    [self initUI];
    // Do any additional setup after loading the view.
}
//回收键盘
-(void)tapBG:(UITapGestureRecognizer *)gesture{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
-(void)initUI{
    UIView * background_view = [[UIView alloc]init];
    background_view.backgroundColor = [UIColor whiteColor];
    background_view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    [self.view addSubview:background_view];
    /*****************************************************/
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,50, [UIScreen mainScreen].bounds.size.width, 1)];
    UIImage * line1 = [UIImage imageNamed:@"line_1px.png"];
    image1.image = line1;
    [background_view addSubview:image1];
    
    UILabel * name_label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,70,40)];
    name_label.text = @"姓名";

    name_label.textColor = [UIColor blackColor];

    [background_view addSubview:name_label];
    
    self.nameTextFiled = [[UITextField alloc]init];
    self.nameTextFiled.frame = CGRectMake(85, 10,SCREEN_WIDTH-20-70, 40);
    self.nameTextFiled.enabled = YES;
    self.nameTextFiled.placeholder = @"请输入真实姓名";
    self.nameTextFiled.textColor = [UIColor grayColor];
    [self.nameTextFiled addTarget:self action:@selector(Rigist_textFiledChange:) forControlEvents:UIControlEventEditingDidEnd];
    [background_view addSubview:self.nameTextFiled];
    
       /*****************************************************/
    UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,100, [UIScreen mainScreen].bounds.size.width, 1)];
    UIImage * line2 = [UIImage imageNamed:@"line_1px.png"];
    image2.image = line2;
    [background_view addSubview:image2];
    
    UILabel * phone_label = [[UILabel alloc]initWithFrame:CGRectMake(10,60,70,40)];
    phone_label.text = @"电话";
 
    phone_label.textColor = [UIColor blackColor];
    [background_view addSubview:phone_label];
    
    self.phoneTextFiled = [[UITextField alloc]init];
    self.phoneTextFiled.frame = CGRectMake(85, 60,SCREEN_WIDTH-20-70, 40);
    self.phoneTextFiled.enabled = YES;
    self.phoneTextFiled.placeholder = @"请输入真实电话";
    self.phoneTextFiled.textColor = [UIColor grayColor];
    [self.phoneTextFiled addTarget:self action:@selector(Rigist_textFiledChange:) forControlEvents:UIControlEventEditingDidEnd];
    [background_view addSubview:self.phoneTextFiled];
       /*****************************************************/
    UIImageView * image3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,150, [UIScreen mainScreen].bounds.size.width, 1)];
    UIImage * line3 = [UIImage imageNamed:@"line_1px.png"];
    image3.image = line3;
    [background_view addSubview:image3];
    
    UILabel * address_label = [[UILabel alloc]initWithFrame:CGRectMake(10,110,70,40)];
    address_label.text = @"详细地址";

    address_label.textColor = [UIColor blackColor];
    [background_view addSubview:address_label];
    
    
    self.addressFiled = [[UITextField alloc]init];
    self.addressFiled.frame = CGRectMake(85, 110,SCREEN_WIDTH-20-70, 40);
    self.addressFiled.enabled = YES;
    self.addressFiled.placeholder = @"请输入详细地址";
    self.addressFiled.textColor = [UIColor grayColor];
    [self.addressFiled addTarget:self action:@selector(Rigist_textFiledChange:) forControlEvents:UIControlEventEditingDidEnd];
    [background_view addSubview:self.addressFiled];
       /*****************************************************/
    UILabel * beizhu = [[UILabel alloc]initWithFrame:CGRectMake(10,160,SCREEN_WIDTH-20,80)];
    beizhu.text = @"请问填写真实姓名，联系电话以及收货地址，以免给您带来不必要的损失";

    beizhu.textColor = [UIColor redColor];
    beizhu.numberOfLines=0;
    [background_view addSubview:beizhu];
       /*****************************************************/
    UIButton * save_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [save_btn setTitle:@"保存并使用" forState:UIControlStateNormal];
    [save_btn setFrame:CGRectMake(10,SCREEN_HEIGHT-64-50-10,SCREEN_WIDTH-20,50)];
    [save_btn.layer setMasksToBounds:YES];
    [save_btn.layer setBorderWidth:1.0];
    [save_btn.layer setCornerRadius:20.0];
    [save_btn.layer setBorderColor:Color.CGColor];
    [save_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    save_btn.backgroundColor = Color;
    [save_btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:save_btn];
}
-(void)Rigist_textFiledChange:(UITextField *)theTextFiled{
    

    if(theTextFiled == self.nameTextFiled){
        self.nameText = self.nameTextFiled.text;
    }else if(theTextFiled == self.phoneTextFiled){
       
        self.phoneText = self.phoneTextFiled.text;
    }else if (theTextFiled == self.addressFiled){
        self.addressText =self.addressFiled.text;
    }
    


}
-(void)request{
   
    if(self.addressText==nil||self.phoneText==nil ||self.nameText==nil ){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请填写完整的信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"进行后续操作");
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.appUserId,@"appUserId",self.nameText,@"name",self.phoneText,@"phone",self.addressText,@"address",nil];
        NSString * url = [NSString stringWithFormat:@"%@/ShoppingInterface/hscm/common/addReceiver?%@",shopURL,para];
        NSLog(@"url:%@",url);
        [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        ManageAddressTableViewController * manage = [[ManageAddressTableViewController alloc]init];
        manage.appUserId = self.appUserId;
        [self.navigationController pushViewController:manage animated:YES];
    } FailureBlock:^(id error) {
        NSLog(@"%@",error);

    }];
    }
}
-(void)save{
    NSLog(@"跳转");
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self request];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        ManageAddressTableViewController * manage = [[ManageAddressTableViewController alloc]init];
//        manage.appUserId = self.appUserId;
//        [self.navigationController pushViewController:manage animated:YES];
        
    });

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

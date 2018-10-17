//
//  ManageAddressTableViewController.m
//  阳光社区
//
//  Created by 秦焕 on 2018/9/26.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "ManageAddressTableViewController.h"
#import "ToolHeader.h"
#import "manageTableViewCell.h"
#import "DIYAFNetworking.h"
#import "MJExtension.h"
#import "ReceiverModel.h"
@interface ManageAddressTableViewController ()
@property(nonatomic,strong)NSMutableArray * data_Array;
@property(nonatomic,strong)NSMutableArray * phone_Array;
@property(nonatomic,strong)NSMutableArray * address_Array;
@property(nonatomic,strong)NSMutableArray * default_Array;
@property(nonatomic,strong)NSMutableArray * id_Array;
@end

@implementation ManageAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.navigationController.navigationBar.barTintColor = Color;
    self.title = @"管理收货地址";
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self request];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.sectionHeaderHeight=0;
        self.tableView.sectionFooterHeight = 0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    });
}

-(void)request{
    
        self.data_Array =[[NSMutableArray alloc]initWithCapacity:1];
        self.phone_Array =[[NSMutableArray alloc]initWithCapacity:1];
        self.address_Array =[[NSMutableArray alloc]initWithCapacity:1];
        self.default_Array =[[NSMutableArray alloc]initWithCapacity:1];
     self.id_Array =[[NSMutableArray alloc]initWithCapacity:1];
    NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.appUserId,@"appUserId",nil];
    NSString * url = [NSString stringWithFormat:@"%@/ShoppingInterface/hscm/common/receiverList?%@",shopURL,para];
    NSLog(@"url:%@",url);
    [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
       
            NSLog(@"dddd:%@",[responseObject objectForKey:@"dataList"]);
        
        
            for (NSDictionary * dic in [responseObject objectForKey:@"dataList"])
            {

                    [self.data_Array addObject:[ReceiverModel mj_objectWithKeyValues:dic]];

            }
        
        NSLog(@"self.data_Array:%@",self.data_Array);
        
    } FailureBlock:^(id error) {
        NSLog(@"%@",error);
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //这个数字根据传来的数据发生改变
    return [self.data_Array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //改为以下的方法
     manageTableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[manageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   
ReceiverModel * model = self.data_Array[indexPath.row];
cell.name.text = [NSString stringWithFormat:@"姓名:%@",model.name];;
cell.phone.text = [NSString stringWithFormat:@"电话:%@",model.phone];
cell.address.text = [NSString stringWithFormat:@"收货地址:%@",model.address];
cell.default_label.text = @"设置为默认";
if ([model.isDefault isEqual:@"1"]) {
    [cell.set setImage:[UIImage imageNamed:@"Clickonthe@1x.png"] forState:UIControlStateNormal];
}else{
    [cell.set setImage:[UIImage imageNamed:@"Didnotclick@1x.png"] forState:UIControlStateNormal];
}
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    for (int i = 0; i<[self.data_Array count]; i++) {
        if (i == indexPath.row) {
             manageTableViewCell * cell = (manageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
 
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self rerequest_address:i];
                
            });
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{

                    [cell.set setImage:[UIImage imageNamed:@"Clickonthe@1x.png"] forState:UIControlStateNormal];
            });
            
        }else{
             manageTableViewCell * cell = (manageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            [cell.set setImage:[UIImage imageNamed:@"Didnotclick@1x.png"] forState:UIControlStateNormal];
        }
    }

}
-(void)rerequest_address:(int)receiveId{
        ReceiverModel * model = self.data_Array[receiveId];
    NSDictionary * num_dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.appUserId,@"appUserId",model.id,@"receiverId",nil];
    NSString * url = [NSString stringWithFormat:@"%@/ShoppingInterface/hscm/common/setDefaultReceiver?%@",shopURL,para];
    NSLog(@"url:%@",url);
    [DIYAFNetworking PostHttpDataWithUrlStr:url Dic:num_dic SuccessBlock:^(id responseObject) {
        
        NSLog(@"dddd:%@",responseObject);
        

        
    } FailureBlock:^(id error) {
        NSLog(@"%@",error);
        
    }];
}
#pragma mark indexpath这行的cell有多高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


@end

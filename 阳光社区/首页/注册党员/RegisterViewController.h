//
//  RegisterViewController.h
//  阳光社区
//
//  Created by 秦焕 on 2018/12/20.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property(nonatomic,strong)NSString * areaId;
@property(nonatomic,strong)NSString * appUserId;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * birthday;
@property(nonatomic,strong)NSString * MinzuStr;
@property(nonatomic,strong)NSString * zhibuStr;
@property(nonatomic,strong)NSString * phone;
@property(nonatomic,strong)NSString * partyPoint;
@property(nonatomic,strong)NSString * starStr;

@property(nonatomic,strong)NSString * xueliStr;

@property(nonatomic,strong)UIButton * addImage;
@property(nonatomic,strong)UIActivityIndicatorView * activity_indicator_view;
@end

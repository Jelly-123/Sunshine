//
//  DaRenViewController.h
//  阳光社区
//
//  Created by 秦焕 on 2018/9/9.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "HWPublishBaseController.h"

@interface DaRenViewController : HWPublishBaseController
@property(nonatomic,strong)NSString * appUserId;
@property(nonatomic,strong)NSString * hotelId;
@property(nonatomic,strong)NSString * realName_para;
@property(nonatomic,strong)NSString * Phone_para;
@property(nonatomic,strong)NSString * introduction_para;
@property(nonatomic,strong)NSString * Address_para;
@property(nonatomic,strong)NSString * stageName_para;
@property(nonatomic,strong)NSString * mingzi_para;


@property(nonatomic,strong)UIActivityIndicatorView * activity_indicator_view;
@end

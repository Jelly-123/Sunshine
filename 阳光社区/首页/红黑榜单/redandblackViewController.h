//
//  redandblackViewController.h
//  阳光社区
//
//  Created by 秦焕 on 2018/9/17.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "HWPublishBaseController.h"

@interface redandblackViewController : HWPublishBaseController
@property(nonatomic,strong)NSString * categroyId;
@property(nonatomic,strong)NSString * functionID;
@property(nonatomic,strong)NSString * hotelId;
@property(nonatomic,strong)NSString * title1;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)UIActivityIndicatorView * activity_indicator_view;
@end

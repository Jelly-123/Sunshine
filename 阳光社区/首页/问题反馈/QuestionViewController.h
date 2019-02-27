//
//  QuestionViewController.h
//  阳光社区
//
//  Created by 秦焕 on 2018/9/11.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "HWPublishBaseController.h"

@interface QuestionViewController : HWPublishBaseController
@property(nonatomic,strong)NSString * appUserId;
@property(nonatomic,strong)NSString * hotelId;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * title1;
@property(nonatomic,strong)NSString * question;
@property(nonatomic,strong)NSString * louhaoStr;
@property(nonatomic,strong)NSString * danyuanhaoStr;
@property(nonatomic,strong)UIActivityIndicatorView * activity_indicator_view;
@end

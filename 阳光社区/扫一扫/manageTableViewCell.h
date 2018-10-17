//
//  manageTableViewCell.h
//  阳光社区
//
//  Created by 秦焕 on 2018/9/26.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface manageTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UILabel * phone;         
@property (nonatomic, strong) UILabel * address;
@property (nonatomic, strong) UIButton * set;
@property (nonatomic, strong) UILabel * default_label;
@end

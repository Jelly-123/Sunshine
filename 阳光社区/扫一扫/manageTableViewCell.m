//
//  manageTableViewCell.m
//  阳光社区
//
//  Created by 秦焕 on 2018/9/26.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import "manageTableViewCell.h"
#import "ToolHeader.h"

@implementation manageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,10,SCREEN_WIDTH*0.4,30)];
        self.name.font = [UIFont systemFontOfSize:14];
        self.name.textColor = [UIColor blackColor];
        [self addSubview:self.name];
        
        
        
        self.phone  = [[UILabel alloc] initWithFrame:CGRectMake(10+SCREEN_WIDTH*0.4+10,10,SCREEN_WIDTH*0.4, 30)];
        self.phone.font = [UIFont systemFontOfSize:14];
        self.phone.textColor = [UIColor blackColor];
        [self addSubview:self.phone];
        
        self.address= [[UILabel alloc] initWithFrame:CGRectMake(10, 45,SCREEN_WIDTH*0.7, 30)];
        self.address.font = [UIFont systemFontOfSize:14];
        self.address.textColor = [UIColor blackColor];
        [self addSubview:self.address];
        
        self.set = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.set setFrame:CGRectMake(SCREEN_WIDTH-50,20,30,30)];
        [self.set setImage:[UIImage imageNamed:@"按钮.png"] forState:UIControlStateNormal];
        //        [self.price_btn addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.set];
        
        self.default_label= [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH*0.2), 55,SCREEN_WIDTH*0.2, 30)];
        self.default_label.font = [UIFont systemFontOfSize:12];
        self.default_label.textColor = [UIColor blackColor];
        [self addSubview:self.default_label];
        
        
        
      
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

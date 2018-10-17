//
//  ToolHeader.h
//  阳光社区
//
//  Created by 秦焕 on 2018/8/24.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#ifndef ToolHeader_h
#define ToolHeader_h


#endif /* ToolHeader_h */
static NSString * shopURL = @"http://223.75.12.177:8990";
static NSString * URL = @"http://223.75.12.177:8188";
static NSString * darenurl = @"http://223.75.12.177:8990";
static NSString * baseUrl = @"59.152.38.197"; //远程服务器端口
static NSString * para = @"requestUser=sxbctv&requestPassword=123456";      //固定参数
static NSString * port_1 = @"8188"; //党建和社区
static NSString * port_2 = @"8788"; //商城
static NSString * port_3 = @"8990"; //添加达人
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define  Color  [UIColor colorWithRed:180.0/255.0 green:0.0/255.0 blue:14.0/255.0 alpha:1.0]  //主色调
#define statusBarFrame [[UIApplication sharedApplication] statusBarFrame]//获取顶部状态栏信息,它的长和高
#define navigationHeight self.navigationController.navigationBar.frame.size.height
#define ToolBarHeight self.navigationController.toolbar.frame.size.height
#define RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

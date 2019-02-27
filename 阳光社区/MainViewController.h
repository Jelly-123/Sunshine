//
//  MainViewController.h
//  阳光社区
//
//  Created by 秦焕 on 2018/9/12.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property(nonatomic,strong)NSString * UserName;
@property(nonatomic,strong)NSString * PassWord;
@property(nonatomic,strong)NSString * appUserId;
//-(NSString *)encodeString:(NSString*)unencodedString;

//存入一个key/value值到addr地址中
-(void)saveAddr:(NSString *)addr saveKey:(NSString *)key saveValue:(NSString *)value;
//获取键值为key的值
-(NSString *)saveAddr:(NSString *)addr getKey:(NSString *)key;

@end

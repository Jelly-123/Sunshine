//
//  AppDelegate.h
//  阳光社区
//
//  Created by 秦焕 on 2018/8/24.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;
-(void)shareSuccessByCode:(int) code;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) id<WXDelegate> wxDelegate;
@end


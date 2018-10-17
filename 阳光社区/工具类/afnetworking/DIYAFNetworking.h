//
//  DIYAFNetworking.h
//  Scan Miam
//
//  Created by 秦焕 on 2018/7/3.
//  Copyright © 2018年 秦焕. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock) (id responseObject);
typedef void (^FailedBlock) (id error);
@interface DIYAFNetworking : NSObject

+(void)PostHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

+(void)GetHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

+(void)GetHttpImageDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

@end

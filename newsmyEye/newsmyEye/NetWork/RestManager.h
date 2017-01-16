//
//  RestManager.h
//  newsmy_smarthome_securitydevice_ios
//
//  Created by yangyong on 16/4/12.
//  Copyright © 2016年 EthanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestManager : NSObject
enum{
    requestMethodPOST,//POST
    requestMethodGET,//GET
    requestMethodPUT,//PUT
    requestMethodDELETE//DELETE
};

typedef NSUInteger WWRequestMethodType;


+(NSOperation *)requestWithJson:(NSDictionary *)dicArgs
                  requestMethod:(WWRequestMethodType)requestMethod
                        withUrl:(NSString*)url
                        success:(void(^)(NSDictionary *responseDic))success
                        failure:(void(^)(NSError *error))failure;



@end

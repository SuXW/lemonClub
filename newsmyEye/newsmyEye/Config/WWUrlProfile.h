//
//  WWUrlProfile.h
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#ifndef WWUrlProfile_h
#define WWUrlProfile_h

//服务器地址配置

#ifdef DEBUG
#   define ServiceDomain @"https://device.newsmycloud.cn:9100"
#   define ServicePath   @"/srm/"
#   define LOCALHOST     [NSString stringWithFormat:@"%@%@",ServiceDomain,ServicePath]

#else
#   define ServiceDomain @"https://120.77.210.63"
#   define ServicePath   @"port/lemon/jsoninterface/dealprocess.htm"
#   define LOCALHOST     [NSString stringWithFormat:@"%@%@",ServiceDomain,ServicePath]

#endif

// 短信验证key -- secret
#define SMS_SDK_APPKEY          @"155815f4c51e9"
#define SMS_SDK_APPSECRET       @"1b2f1c7940d89f0cb9bca195589d2089"

//接口地址配置
#define UserLoginApiPath @"account/login"

#endif /* WWUrlProfile_h */

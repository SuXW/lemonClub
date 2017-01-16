//
//  RestManager.m
//  newsmy_smarthome_securitydevice_ios
//
//  Created by yangyong on 16/4/12.
//  Copyright © 2016年 EthanZhang. All rights reserved.
//

#import "RestManager.h"
#import "WWUrlProfile.h"
#import <AdSupport/ASIdentifierManager.h>

#define TIMEOUT 30.0f


@implementation RestManager


+(NSOperation *)requestWithJson:(NSDictionary *)dicArgs
                  requestMethod:(WWRequestMethodType)requestMethod
                        withUrl:(NSString*)url
                        success:(void(^)(NSDictionary *responseDic))success
                        failure:(void(^)(NSError *error))failure{

    
//    //获得当前用户ID
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    NSString * strAccountId = [user objectForKey:@"accountid"];
//    
//    //获得是否登录状态符
//    BOOL isLogin = [user boolForKey:@"loginStatu"];
//
//    //加入默认参数
//    url = [NSString stringWithFormat:@"%@?imei=%@",url,[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
//    
//    if (isLogin) {
//        url = [NSString stringWithFormat:@"%@&accountId=%@",url,strAccountId];
//    }
    
    //导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mykey_server" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate ];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    [securityPolicy setPinnedCertificates:@[certSet]];
    
    //请求体构建
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //增加https支持
    [[self class] resetSetSessuibDudReceiveAutnenticationChakkengeBlock:manager];
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.securityPolicy = securityPolicy;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //设置请求参数类型
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET", @"HEAD"]];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    
    NSString *requestPath = [NSString stringWithFormat:@"%@%@",LOCALHOST,url];

    switch (requestMethod) {
            
        case requestMethodPOST:
        {
            [manager POST:requestPath parameters:dicArgs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSDictionary *JSONDic=(NSDictionary *)responseObject;
                
                success(JSONDic);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case requestMethodGET:
        {
            [manager GET:requestPath parameters:dicArgs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NSDictionary *JSONDic=(NSDictionary *)responseObject;
                success(JSONDic);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
            
        case requestMethodPUT:
        {
            [manager PUT:requestPath parameters:dicArgs success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSDictionary *JSONDic=(NSDictionary *)responseObject;
                success(JSONDic);
                
            } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
                
                
                failure(error);
            }];
            
        }
            break;
            
        case requestMethodDELETE:
        {
            [manager DELETE:requestPath parameters:dicArgs success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSDictionary *JSONDic=(NSDictionary *)responseObject;
                success(JSONDic);
                
            } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
                
                
                failure(error);
            }];
            
        }
            break;
            
        default:
            break;
    }
    return nil;
}


#pragma mark - Https 自签名证书支持
+(void)resetSetSessuibDudReceiveAutnenticationChakkengeBlock:(AFHTTPSessionManager *)manage{
    __weak AFHTTPSessionManager *weakManage = manage;
    __weak typeof(self) weakSelf = self;
    [manage setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([weakManage.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition =NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"mykey_client"ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12])
            {
                DDLogDebug(@"p12证书不存在！");
            }
            else
            {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                
                if ([[weakSelf class]extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
                {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    
                    CFRelease(certArray);
                    disposition =NSURLSessionAuthChallengeUseCredential;

                }
            }
        }
        *_credential = credential;
        
      //  DDLogInfo(@"证书设备完毕");
        return disposition;
    }];
}

+(BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"lemon123"
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        DDLogDebug(@"SSL证书出错 code -> %d",(int)securityError);
        return NO;
    }
    return YES;
}
@end

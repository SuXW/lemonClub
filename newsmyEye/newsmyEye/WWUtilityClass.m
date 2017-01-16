//
//  WWUtilityClass.m
//  WWSampleProject
//
//  Created by push on 15/9/9.
//  Copyright (c) 2015年 苏望. All rights reserved.
//

#import "WWUtilityClass.h"
#import <CommonCrypto/CommonDigest.h>


@implementation WWUtilityClass
//键盘隐藏事件
+ (void)hidderKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


//MD5加密
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

//SHA1加密
+ (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//获得当前时间
+ (NSString *)getTodayTimerWithtDateFormat:(NSString *)str{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:str];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)boundingRectWithSize:(CGSize)size withText:(NSString *)text withFont:(UIFont*)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)saveNSUserDefaults:(NSString *)key value:(id)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (id)getNSUserDefaults:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key] ? [defaults valueForKey:key] : @"";
}

+(NSMutableDictionary *)getParametersDic:(NSString *)funldStr{
    
    //固定参数
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString * app_ver=version;
    
    NSString * platform=@"2";
    
    NSString * os_ver=[NSString stringWithFormat:@"ios%.1f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    
//    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
//    [formatter setDateFormat:@"SSSS"];
//    NSString * date = [formatter stringFromDate:[NSDate date]];
//    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];

    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    // 创建NSDictionary
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //  app版本
    [dict setObject:app_ver forKey:@"appVersion"];
    // ios系统类型
    [dict setObject:platform forKey:@"osType"];
    // 系统版本号
    [dict setObject:os_ver forKey:@"osVersion"];
    // 功能号 标识  暂无
    [dict setObject:funldStr forKey:@"funId"];
    // 系统当前毫秒数
    [dict setObject:[NSString stringWithFormat:@"%llu",recordTime] forKey:@"timestamp"];
    
    //sha1散列加密
    NSString *shaStableParameters = [WWUtilityClass sha1:[NSString stringWithFormat:@"%llu",recordTime]];
    
    NSString *MD_String = [WWUtilityClass md5HexDigest: [WWUtilityClass md5HexDigest: [NSString stringWithFormat:@"%@%@%@%@%@%@",shaStableParameters,platform,os_ver,funldStr,app_ver,@"\"LEMON SECURITY\""]]];
    
    [dict setObject:MD_String forKey:@"ticketValue"];
    
    return dict;
}



@end

@implementation UIView (additional)

- (UIImage *)rn_screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIViewController *)viewController
{
    id nextResponder = [self nextResponder];
    
    while (nextResponder != nil) {
        
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
    }
    
    return nil;
}

@end

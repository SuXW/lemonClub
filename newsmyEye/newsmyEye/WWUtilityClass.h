//
//  WWUtilityClass.h
//  WWSampleProject
//
//  Created by push on 15/9/9.
//  Copyright (c) 2015年 苏望. All rights reserved.
//


@interface WWUtilityClass : NSObject


#pragma mark - 常用方法
//键盘隐藏
+ (void)hidderKeyboard;

//获得当前时间
+ (NSString *)getTodayTimerWithtDateFormat:(NSString *)str;

//颜色转换为图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//计算文字宽高度
+ (CGSize)boundingRectWithSize:(CGSize)size withText:(NSString *)text withFont:(UIFont *)font;

//md5加密
+ (NSString *)md5HexDigest:(NSString*)input;
//SHA1加密
+ (NSString *) sha1:(NSString *)input;

//正则判断手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;

+ (void)saveNSUserDefaults:(NSString *)key value:(NSString *)value;

+ (NSString *)getNSUserDefaults:(NSString *)key;

//返回固定参数字典
+(NSMutableDictionary *)getParametersDic:(NSString *)funldStr;


@end

@interface UIView (additional)

- (UIImage *)rn_screenshot;

- (UIViewController *)viewController;

@end

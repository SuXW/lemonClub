//
//  WWColorProfile.h
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//


//打印命令--请务必使用此命令
#ifdef DEBUG
# define WWLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]\n" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define WWLog(...);
#endif

#define StringAppend(value)     [NSString stringWithFormat:@"%@",value]

//获取网络情况
#define NETWORK [Reachability getNetworkTypeFromStatusBar]

//获取设备机型
#define _DEVICE_SYSTEM_MODEL_ [Reachability platformType]

//获取设备的devicetoken
#define _DEVICE_TOKEN_ [Reachability getDeviceToken]

//获取当前用户的id
#define _DEVICE_USERID [Reachability getShareUserId]
//系统版本号
#define _DEVICE_SYSTEM_VERSION_  [[[UIDevice currentDevice] systemVersion]floatValue]
#define _DEVICE_SYSTEM_NAME_  [[UIDevice currentDevice] systemName] //设备名称
//系统版本号
#define VersionLargerThan5  ([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0)
#define VersionLargerThan6  ([[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
#define VersionLargerThan7  ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)
#define VersionLargerThan8  ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)

#define Version5  ([[[UIDevice currentDevice] systemVersion] floatValue] ==5.0)
#define Version6  ([[[UIDevice currentDevice] systemVersion] floatValue] ==6.0)
#define Version7  ([[[UIDevice currentDevice] systemVersion] floatValue] ==7.0)
#define Version8  ([[[UIDevice currentDevice] systemVersion] floatValue] ==8.0)

//获取设备
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_

//如果为ios7，则返回20的冗余
#ifndef IOS7_Y
#define IOS7_Y              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?20:0)
#endif

#ifndef WWColorProfile_h
#define WWColorProfile_h

//设备屏幕高度
#ifndef MainView_Height
#define MainView_Height    [UIScreen mainScreen].bounds.size.height
#endif

//设备屏幕宽度
#ifndef MainView_Width
#define MainView_Width    [UIScreen mainScreen].bounds.size.width
#endif

//rpg颜色宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define KUIImageViewDefaultImage        createImageWithColor(KUIImageViewDefaultColor)

//转RGB颜色值
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//绿色按钮三态
#define Btn_Blue_Normal_Top UIColorFromRGB(#7accc5)

#define btn_organ   RGBCOLOR(241,213,43)

//工程主调颜色
#define WW_BASE_COLOR RGBCOLOR(242,242,242)

//线条颜色
#define WWPageLineColor                 RGBCOLOR(217,217,217)
//内容颜色
#define WWContentTextColor              RGBCOLOR(51,51,51)
//提示文字颜色
#define WWPlaceTextColor                RGBCOLOR(153,153,153)
//黄色文字
#define WWOrganText                      RGBCOLOR(237,200,30)

//灰色的文字
#define WWGreyText                      RGBCOLOR(102,102,102)

//标题颜色
#define WWTitleTextColor                RGBCOLOR(64,64,64)
//副标题颜色
#define WWSubTitleTextColor             RGBCOLOR(134,134,134)
//按键高亮的显示颜色
#define WWBtnStateHighlightedColor      RGBCOLOR(222,222,222)

#define WWLowGreyText                      RGBCOLOR(170,170,170)

#endif /* WWColorProfile_h */

//
//  CDVVolume.h
//  CDVVol
//
//  Created by Wilson on 2017/8/10.
//
//

#import <Cordova/CDV.h>

@interface CDVUtils : CDVPlugin

/*********** 换肤 ***********/
- (void)transPeeler:(CDVInvokedUrlCommand *)command;

//检测到新版本时，点确定按钮，跳转到应用商店升级
- (void)openURLForUpdate:(CDVInvokedUrlCommand *)command;

//获取皮肤样式
+ (NSDictionary *)getPeeler;

//根据十六进制颜色代码返回UIColor
+ (UIColor*)colorFromColorString:(NSString*)colorString;

+ (void)alertTitle:(NSString *)title content:(NSString *)content showVC:(UIViewController *)vc handler1:(void(^)(UIAlertAction * action))handler1;

@end

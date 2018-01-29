//
//  CDVVolume.m
//  CDVVol
//
//  Created by Wilson on 2017/8/10.
//
//

#import "CDVUtils.h"

@implementation CDVUtils

-(void)transPeeler:(CDVInvokedUrlCommand *)command {
    /*
     {"title":"黑色","url":"images/skin/app-skin2.png","themeColor":"#333333","navBg":"#333333","navIcon":"#FFFFFF","navSearch":"#2D2D2D","navSearchFont":"#999999","navFont":"#FFFFFF","newsBg":"#F56B6B","FooterNavBg":"#FFFFFF","FooterNavBtnBg":"#999999","FooterNavBtnOnBg":"#333333","FooterNavFont":"#777777","FooterNavOnFont":"#333333","channelColor":"#999999","personalTopColor":"#333333"}
     */
    NSString *style = [command argumentAtIndex:0];
    if (style) {
        NSData *styleData = [style dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *peelerStyle = [NSJSONSerialization JSONObjectWithData:styleData options:NSJSONReadingAllowFragments error:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:peelerStyle forKey:@"peelerStyle"];
    }
}

//检测到新版本时，点确定按钮，跳转到应用商店升级
- (void)openURLForUpdate:(CDVInvokedUrlCommand *)command {
    NSString * url = [command argumentAtIndex:0];
    if(!url || ![url length]) {
        //如果传过来的url为异常值，则赋一个默认值给url
        url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id1313669861"];
    }
    //转成oc的url类
    NSURL * URLStr = [NSURL URLWithString:url];
    
    //判断是否可以打开该url
    if([[UIApplication sharedApplication] canOpenURL:URLStr]) {
        [[UIApplication sharedApplication] openURL:URLStr];
        
        CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } else {
        
        CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

+(NSDictionary *)getPeeler {
    //换肤样式
    NSDictionary *peeler = [[NSUserDefaults standardUserDefaults] valueForKey:@"peelerStyle"];
    UIColor *navColor = nil;
    UIColor *themeColor = nil;
    UIColor *navFontColor = nil;
    UIColor *navIconColor = nil;
    if (peeler) {
        navColor = [CDVUtils colorFromColorString:[peeler objectForKey:@"navBg"]];
        themeColor = [CDVUtils colorFromColorString:[peeler objectForKey:@"themeColor"]];
        navFontColor = [CDVUtils colorFromColorString:[peeler objectForKey:@"navFont"]];
        navIconColor = [CDVUtils colorFromColorString:[peeler objectForKey:@"navIcon"]];
    } else {
        navColor = [CDVUtils colorFromColorString:@"#FFFFFF"];
        themeColor = [CDVUtils colorFromColorString:@"#43D2AD"];
        navFontColor = [CDVUtils colorFromColorString:@"#333333"];
        navIconColor = [CDVUtils colorFromColorString:@"#333333"];
    }
    NSDictionary *peelerStyle = [NSDictionary dictionaryWithObjectsAndKeys:navColor,@"navColor",themeColor,@"themeColor",@"navFontColor",navFontColor,@"navIconColor",navIconColor, nil];
    return peelerStyle;
}

+ (UIColor*)colorFromColorString:(NSString*)colorString
{
    // No value, nothing to do
    if (!colorString) {
        return nil;
    }
    
    // Validate format
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^(#[0-9A-F]{3}|(0x|#)([0-9A-F]{2})?[0-9A-F]{6})$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger countMatches = [regex numberOfMatchesInString:colorString options:0 range:NSMakeRange(0, [colorString length])];
    
    if (!countMatches) {
        return nil;
    }
    
    // #FAB to #FFAABB
    if ([colorString hasPrefix:@"#"] && [colorString length] == 4) {
        NSString* r = [colorString substringWithRange:NSMakeRange(1, 1)];
        NSString* g = [colorString substringWithRange:NSMakeRange(2, 1)];
        NSString* b = [colorString substringWithRange:NSMakeRange(3, 1)];
        colorString = [NSString stringWithFormat:@"#%@%@%@%@%@%@", r, r, g, g, b, b];
    }
    
    // #RRGGBB to 0xRRGGBB
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    
    // 0xRRGGBB to 0xAARRGGBB
    if ([colorString hasPrefix:@"0x"] && [colorString length] == 8) {
        colorString = [@"0xFF" stringByAppendingString:[colorString substringFromIndex:2]];
    }
    
    // 0xAARRGGBB to int
    unsigned colorValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:colorString];
    if (![scanner scanHexInt:&colorValue]) {
        return nil;
    }
    
    // int to UIColor
    return [UIColor colorWithRed:((float)((colorValue & 0x00FF0000) >> 16))/255.0
                           green:((float)((colorValue & 0x0000FF00) >>  8))/255.0
                            blue:((float)((colorValue & 0x000000FF) >>  0))/255.0
                           alpha:((float)((colorValue & 0xFF000000) >> 24))/255.0];
}

+(void)alertTitle:(NSString *)title content:(NSString *)content showVC:(UIViewController *)vc handler1:(void (^)(UIAlertAction *))handler1 {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler1) {
            handler1(action);
        }
    }];
    [alertVC addAction:action];
    [vc presentViewController:alertVC animated:YES completion:nil];
}
@end

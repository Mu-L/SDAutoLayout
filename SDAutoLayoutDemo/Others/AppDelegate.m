//
//  AppDelegate.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/10/12.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "AppDelegate.h"

#import "LEETheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configureNavigationBarAppearance];
    [self configTheme];
    
    return YES;
}

/// iOS 15+ 默认导航栏在滚动边缘会变成深色；统一为浅色栏 + 深色标题，并与内容区对齐。
- (void)configureNavigationBarAppearance
{
    UIColor *barColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    UIColor *titleColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    UIColor *tintColor = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1];

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = barColor;
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor};
        appearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: titleColor};
        appearance.shadowColor = [UIColor colorWithWhite:0 alpha:0.12];

        UINavigationBar *navBar = [UINavigationBar appearance];
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance;
        navBar.compactAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            navBar.compactScrollEdgeAppearance = appearance;
        }
        navBar.tintColor = tintColor;
        navBar.translucent = NO;
        navBar.barTintColor = barColor;
        navBar.titleTextAttributes = appearance.titleTextAttributes;
        if (@available(iOS 13.0, *)) {
            navBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
    } else {
        UINavigationBar *navBar = [UINavigationBar appearance];
        navBar.barTintColor = barColor;
        navBar.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor};
        navBar.tintColor = tintColor;
        navBar.translucent = NO;
        navBar.barStyle = UIBarStyleDefault;
    }
}

// 设置LEETheme

- (void)configTheme{
    
    //获取对应主题的json设置数据
    
    NSString *dayjson = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"theme_day_json.json"] encoding:NSUTF8StringEncoding error:nil];
    
    //添加json设置数据 , 设置主题标签 , 设置资源路径
    
    [LEETheme addThemeConfigWithJson:dayjson Tag:@"day" ResourcesPath:nil];
    
    NSString *nightjson = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"theme_night_json.json"] encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigWithJson:nightjson Tag:@"night" ResourcesPath:nil];
    
    //设置默认主题
    
    [LEETheme defaultTheme:@"day"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

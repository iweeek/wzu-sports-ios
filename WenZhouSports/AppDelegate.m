//
//  AppDelegate.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/4/27.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchController.h"
#import "HomeController.h"
#import "LoginController.h"

@interface AppDelegate ()

@property (nonatomic, strong) LaunchController *launchController;
@property (nonatomic, strong) LoginController  *loginController;
@property (nonatomic, strong) HomeController *homeController;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self cocoaLumberJackConfigs];
    [self dataBaseConfigs];
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = AMapKey;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _loginController = [[LoginController alloc] init];
    _homeController = [[HomeController alloc] init];
    
    [UserDefaultsManager sharedUserDefaults].studentId = 3;
    [UserDefaultsManager sharedUserDefaults].universityId = 1;
    if (![UserDefaultsManager sharedUserDefaults].studentId) {//![UserDefaultsManager sharedUserDefaults].studentId
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_loginController];
    } else {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_homeController];
    }
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/**
 进行cocoaLumberjack的配置
 */
- (void)cocoaLumberJackConfigs {
#ifdef DEBUG
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
    //运动信息的文件
    DDFileLogger *sportsFileLogger = [[DDFileLogger alloc] init];
    //文件最大为3MB
    [sportsFileLogger setMaximumFileSize:3 * 1024 * 1024];
    //文件每24小时会生成一个新的
    [sportsFileLogger setRollingFrequency:3600 * 24];
    //最大文件数，这样可以存储最近一周的文件，后面生成文件会自动清楚前面的
    [[sportsFileLogger logFileManager] setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:sportsFileLogger];
}

- (void)dataBaseConfigs {
    NSString *path = [NSString stringWithFormat:@"%@/Documents/user.sqlite", NSHomeDirectory()];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        if (![db executeUpdate:@"create table if not exists acceleration (x real, y real, z real, time integer)"]) {
            DDLogVerbose(@"error");
        }
        if (![db executeUpdate:@"create table if not exists activity (activity text, confidence integer, time integer)"]) {
            DDLogVerbose(@"error");
        }
        if (![db executeUpdate:@"create table if not exists sportsInfo (steps integer, stepDistance integer, mapDistance integer, totalTime integer, time integer)"]) {
            DDLogVerbose(@"error");
        }
    }
    [db close];
}

@end


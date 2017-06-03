//
//  NSLoggerCocoaLumberjackConnectorPlugin.m
//

#import "NSLoggerCocoaLumberjackConnectorPlugin.h"

#import "DDTTYLogger.h"
#import "DDNSLoggerLogger.h"
#import "DDFileLogger.h"


@implementation NSLoggerCocoaLumberjackConnectorPlugin

#pragma mark Initialization

- (void)pluginInitialize {

    
    NSString * applicationDocumentsDirectory = [[[[NSFileManager defaultManager]    
     URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
     DDLogFileManagerDefault *documentsFileManager = [[DDLogFileManagerDefault alloc]
         initWithLogsDirectory:applicationDocumentsDirectory];
     
        /* log to a file retained in the 'file system' */
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:documentsFileManager];

    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    
    // add Xcode console logger if not running in the App Store
    if (![self isAppStoreEnvironment]) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
    }
    
    DDLogInfo(@"NSLoggerCocoaLumberjackConnectorPlugin Plugin initialized");
}

- (BOOL)isAppStoreEnvironment {
    // cribbed from HockeyApp SDK
    BOOL appStoreEnvironment=NO;
#if !TARGET_IPHONE_SIMULATOR
    // check if we are really in an app store environment
    if (![[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"]) {
      appStoreEnvironment = YES;
    }
#endif
    return appStoreEnvironment;
}

@end

//
//  AppDelegate.m
//  sensitive lantern
//
//  Created by Maxwell on 01/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize mainViewController, settingsViewController;

+ (float) loadBrightnessSetting
{
    float brightness;
    
    brightness = [[NSUserDefaults standardUserDefaults] floatForKey:@"brightness"];
    
    if (brightness == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:1.0f forKey:@"brightness"];
    }
    return brightness;
}

+ (float) loadStrobeIntervalSetting
{
    float strobeInterval;
    
    strobeInterval = [[NSUserDefaults standardUserDefaults] floatForKey:@"strobeInterval"];
    
    if (strobeInterval == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:0.5f forKey:@"strobeInterval"];
    }
    return strobeInterval;
}

+ (float) loadSOSIntervalSetting
{
    float sosInterval;
    
    sosInterval = [[NSUserDefaults standardUserDefaults] floatForKey:@"sosInterval"];
    
    if (sosInterval == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:0.4f forKey:@"sosInterval"];
    }
    return sosInterval;
}

+ (void) writeStrobeIntervalSetting:(float)value
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"strobeInterval"];
}

+ (void) writeBrightnessSetting:(float)value
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"brightness"];
}

+ (void) writeSOSIntervalSetting:(float)value
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"sosInterval"];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device respondsToSelector:@selector(setTorchModeOnWithLevel:error:)])
    {
        self.deviceSupportsBrightness = true;
    }
    else
    {
        self.deviceSupportsBrightness = false;
    }
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    ViewController *viewController = (ViewController *) mainViewController;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSLog(@"TorchMode: %@", device.flashMode ? @"YES" :@"NO") ;
    if(viewController.flashTurnedOn && device.flashMode == AVCaptureTorchModeOn) {
        [viewController turnOnFlash];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

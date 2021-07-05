//
//  AppDelegate.h
//  sensitive lantern
//
//  Created by Maxwell on 01/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *settingsViewController;
@property bool deviceSupportsBrightness;

+ (float) loadStrobeIntervalSetting;
+ (float) loadBrightnessSetting;
+ (float) loadSOSIntervalSetting;

+ (void) writeStrobeIntervalSetting:(float)value;
+ (void) writeBrightnessSetting:(float)value;
+ (void) writeSOSIntervalSetting:(float)value;

@end

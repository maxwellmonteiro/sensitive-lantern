//
//  ViewController.h
//  sensitive lantern
//
//  Created by Maxwell on 01/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "OBShapedButton.h"
#import "AppDelegate.h"
#import <iAd/iAd.h>
#import "MyGADBannerView.h"

typedef enum OnOffType {
    ON,
    OFF
} onoff;

@interface ViewController : UIViewController <UIAccelerometerDelegate, ADBannerViewDelegate>
{
    __weak IBOutlet UIImageView *slideBar;
    __weak IBOutlet OBShapedButton *powerButton;
    __weak IBOutlet ADBannerView *bannerView;
    __weak IBOutlet MyGADBannerView *gadBannerView;
    
            
    bool _flashTurnedOn;
    float lanternMode;
    bool deviceHasFlash;
    int slideBarInitialX;
    int countSOS;
    
    bool bannerIsVisible;
    
    float _strobeInterval;
    float _brightness;
    float _sosInterval;
    
    AppDelegate *appDelegate;
    UIAcceleration *lastAcceleration;
    CMMotionManager *motionManager;
    AVAudioPlayer *playerSlideBar;
    AVAudioPlayer *playerPowerButton;
    AVCaptureDevice *device;
    AVAudioPlayer *playerSettingsButton;
    NSTimer *strobeTimer;
}

@property bool flashTurnedOn;
- (void) turnOnFlash;

@end


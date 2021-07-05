//
//  SettingsViewController.h
//  sensitive lantern
//
//  Created by Maxwell on 16/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface SettingsViewController : UIViewController
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *labelStrobe;
@property (weak, nonatomic) IBOutlet UISlider *sliderStrobe;
@property (weak, nonatomic) IBOutlet UILabel *labelBrightness;
@property (weak, nonatomic) IBOutlet UISlider *sliderBrightness;
@property (weak, nonatomic) IBOutlet UILabel *labelSOS;
@property (weak, nonatomic) IBOutlet UISlider *sliderSOS;

@end

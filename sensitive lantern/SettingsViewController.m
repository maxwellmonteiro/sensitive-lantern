//
//  SettingsViewController.m
//  sensitive lantern
//
//  Created by Maxwell on 16/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.settingsViewController = self;
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"SettingsNavBarTitle", @"InfoPlist", nil);
    self.labelStrobe.text = NSLocalizedStringFromTable(@"StrobeSlider", @"InfoPlist", nil);
    self.labelBrightness.text = NSLocalizedStringFromTable(@"BrightnessSlider", @"InfoPlist", nil);
    self.labelSOS.text = NSLocalizedStringFromTable(@"SOSSlider", @"InfoPlist", nil);
    
    self.sliderStrobe.value = [AppDelegate loadStrobeIntervalSetting];
    self.sliderSOS.value = [AppDelegate loadSOSIntervalSetting];
    self.sliderBrightness.value = [AppDelegate loadBrightnessSetting];
    
    if (![appDelegate deviceSupportsBrightness]) {
        self.labelBrightness.hidden = YES;
        self.sliderBrightness.hidden = YES;
    }
        
   /* NSInteger red = 220;
    NSInteger blue = 220;
    NSInteger green = 220;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0]];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [self setLabelStrobe:nil];
    [self setSliderStrobe:nil];
    [self setLabelBrightness:nil];
    [self setSliderBrightness:nil];
    [self setLabelStrobe:nil];
    [self setSliderStrobe:nil];
    [self setLabelSOS:nil];
    [self setSliderSOS:nil];
    [super viewDidUnload];
}

- (IBAction)sliderStrobeIntervalValueChanged:(UISlider *)sender {
    [AppDelegate writeStrobeIntervalSetting:sender.value];
}

- (IBAction)sliderSOSIntervalValueChanged:(UISlider *)sender {
    [AppDelegate writeSOSIntervalSetting:sender.value];
}

- (IBAction)sliderBrightnessValueChanged:(UISlider *)sender {
    [AppDelegate writeBrightnessSetting:sender.value];
}


@end

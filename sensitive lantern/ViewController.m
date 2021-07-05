//
//  ViewController.m
//  sensitive lantern
//
//  Created by Maxwell on 01/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize flashTurnedOn = _flashTurnedOn;

float const SWIPE_WINDOW = 41.0f;

float const MODE_SOS =      -1 * SWIPE_WINDOW;
float const MODE_LANTERN =   0 * SWIPE_WINDOW;
float const MODE_STROBE =    1 * SWIPE_WINDOW;

float const SHAKE_THRESHOLD = 1.4f;

int const SOS_PATTERN_SIZE = 34;

// SOS = ...---...
onoff sosPattern[SOS_PATTERN_SIZE] = {ON, OFF, // Enviando S
                        ON, OFF, // 
                        ON,      // 
                        OFF,     // Pausa entre letras
                        OFF,
                        OFF,
                        ON, ON, ON, OFF, // Enviando o O
                        ON, ON, ON, OFF,
                        ON, ON, ON,
                        OFF,     // Pausa entre letras
                        OFF,
                        OFF,
                        ON, OFF, // Enviando S
                        ON, OFF, //
                        ON,      //
                        OFF, OFF, OFF, OFF, OFF, OFF, OFF // Pausa entre palavras
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.mainViewController = self;
    
    _flashTurnedOn = false;
    lanternMode = MODE_LANTERN;
    slideBarInitialX = slideBar.frame.origin.x * -1;
        
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([device hasTorch] && [device hasFlash]) {
        deviceHasFlash = true;
    } else {
        deviceHasFlash = false;
    }

    // Iniciando acelerometro
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/30];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    [bannerView setDelegate:self];
    
    //Iniciando giroscopio
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startGyroUpdates];
    
    playerSlideBar = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button-48" ofType:@"wav"]] error:nil];
    [playerSlideBar prepareToPlay];
    
    playerPowerButton = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button-21" ofType:@"wav"]] error:nil];
    [playerPowerButton prepareToPlay];
    
    playerSettingsButton = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"button-27" ofType:@"wav"]] error:nil];
    [playerSettingsButton prepareToPlay];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    strobeTimer = nil;
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    [gadBannerView initGADBannerView:self];
}

- (void)viewDidUnload {
    slideBar = nil;
    device = nil;
    playerSlideBar = nil;
    playerPowerButton = nil;
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [motionManager stopGyroUpdates];
    motionManager = nil;
    powerButton = nil;
    bannerView = nil;
    gadBannerView = nil;
    gadBannerView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {        
    if(_flashTurnedOn && device.flashMode == AVCaptureTorchModeOff && strobeTimer == nil) {
        [self turnOnFlash];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    // Inicializando aqui pois assim carrego as configuracoes tanto no inicio da app, quanto apos sair da tela de ajustes
    _strobeInterval = [AppDelegate loadStrobeIntervalSetting];
    _brightness = [AppDelegate loadBrightnessSetting];
    _sosInterval = [AppDelegate loadSOSIntervalSetting];
}



- (IBAction) powerButtonPressed:(UIButton *)sender {
    if(deviceHasFlash) {
        if (!_flashTurnedOn) {
            // Mudar imagem do botao
            [self changeButtonImage: sender: @"botao-ligado.png"];
            [playerPowerButton play];
            [self turnOnFlash];
            [self setStrobeTimer];
            _flashTurnedOn = true;
        } else {
            // Mudar imagem do botao
            [self changeButtonImage: sender: @"botao-desligado.png"];
            [playerPowerButton play];
            [self stopStrobeTimer];
            [self turnOffFlash];
            _flashTurnedOn = false;
        }
    }
}

- (void)stopStrobeTimer {
    if (strobeTimer != nil) {
        [strobeTimer invalidate];
        strobeTimer = nil;
    }
}

- (void)setStrobeTimer {
    // Se existe algum timer rodando, temos que para-lo antes
    [self stopStrobeTimer];
    
    if (lanternMode == MODE_LANTERN) {        
        // Se ao retornar ao modo LANTERN o flash estava desligado temos que religa-lo
        if (_flashTurnedOn && device.flashMode == AVCaptureTorchModeOff) {
            [self turnOnFlash];
        } 
    } else if (lanternMode == MODE_STROBE) {        
        strobeTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeInterval target:self selector:@selector(doTimerStrobe:) userInfo:nil repeats:YES];
    }
    else {        
        countSOS = 0;
        strobeTimer = [NSTimer scheduledTimerWithTimeInterval:_sosInterval target:self selector:@selector(doTimerSOS:) userInfo:nil repeats:YES];
    }
}

- (void) doTimerStrobe:(NSTimer *)timer {
    if (_flashTurnedOn && deviceHasFlash) {
        if(device.flashMode == AVCaptureTorchModeOn) {
            [self turnOffFlash];
        } else if (device.flashMode == AVCaptureTorchModeOff) {
            [self turnOnFlash];
        }
    }
}

- (void) doTimerSOS:(NSTimer *)timer {    
    if (_flashTurnedOn && deviceHasFlash) {
        if (sosPattern[countSOS] == ON) {
            if (device.flashMode == AVCaptureTorchModeOff) {
                [self turnOnFlash];
            }
        } else {
            if (device.flashMode == AVCaptureTorchModeOn) {
                [self turnOffFlash];
            }
        }
        countSOS++;
        if (countSOS == SOS_PATTERN_SIZE) {
            countSOS = 0;
        }
    }
}

- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender {
    if ((slideBar.frame.origin.x + slideBarInitialX) <= (0 * SWIPE_WINDOW)) {
        
        [playerSlideBar play];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frameRect = slideBar.frame;
            CGPoint rectPoint = frameRect.origin;
            CGFloat newXPos = rectPoint.x + SWIPE_WINDOW;
            slideBar.frame = CGRectMake(newXPos, 0.0f, slideBar.frame.size.width, slideBar.frame.size.height);
        }];
        lanternMode += SWIPE_WINDOW;
        [self setStrobeTimer];
    }
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    if ((slideBar.frame.origin.x + slideBarInitialX) >= (0 * -SWIPE_WINDOW)) {
        [playerSlideBar play];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frameRect = slideBar.frame;
            CGPoint rectPoint = frameRect.origin;
            CGFloat newXPos = rectPoint.x - SWIPE_WINDOW;
            slideBar.frame = CGRectMake(newXPos, 0.0f, slideBar.frame.size.width, slideBar.frame.size.height);
        }];
        lanternMode -= SWIPE_WINDOW;
        [self setStrobeTimer];
    }
}

- (void) turnOnFlash {
    [device lockForConfiguration:nil];
    if (appDelegate.deviceSupportsBrightness) {
        [device setTorchModeOnWithLevel:_brightness error:nil];
    }
    else {
        [device setTorchMode:AVCaptureTorchModeOn];
    }
    [device setFlashMode:AVCaptureFlashModeOn];
    [device unlockForConfiguration];
}

- (void) turnOffFlash {          
    // Set torch to off
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOff];
    [device setFlashMode:AVCaptureFlashModeOff];
    [device unlockForConfiguration];
}

- (void) changeButtonImage:(UIButton *)botao :(NSString *)nomeImagem {
    [botao setImage:[UIImage imageNamed:nomeImagem] forState:UIControlStateNormal];
}

/*- (BOOL) isShaking:(UIAcceleration *)last :(UIAcceleration *)current {
    double deltaX;
    
    deltaX = fabs(last.x - current.x);
    
    if(deltaX > shakeThreshold) {
        return true;
    }    
    return false;
}*/

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    static int count;
    static bool shaking = NO;
    static float direction;
    
    if (!shaking && fabs(acceleration.x) >= SHAKE_THRESHOLD) {
        // shake comecou
        // vamo capturar a aceleracao das proximas 10 iteracoes
        shaking = YES;
        count = 10;
        direction = 0;
    }
    if (shaking) {
        if (count > 0) {
            direction += acceleration.x;
            count--;
        } else {
            if (direction > 0) {
                [self handleSwipeRight:nil];
            } else {
                [self handleSwipeLeft:nil];
            }
            shaking = NO;
        }
    }
}

- (void)orientationChanged:(NSNotification *)notification {
    static bool desligado = false;
    //{'1' : 'Portrait', '2' : 'PortraitUpsideDown', '3' : 'LandscapeLeft', '4' : 'LandscapeRight', '5' : 'FaceUp', '6' : 'FaceDown'}
    if (deviceHasFlash) {
        if([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown && device.torchMode == AVCaptureTorchModeOn) {
            [self changeButtonImage: powerButton: @"botao-desligado.png"];
            [playerPowerButton play];
            [self stopStrobeTimer];
            [self turnOffFlash];
            _flashTurnedOn = false;
            desligado = true;
        } else if (device.torchMode == AVCaptureTorchModeOff && desligado) {
            [self changeButtonImage: powerButton: @"botao-ligado.png"];
            [playerPowerButton play];
            [self turnOnFlash];
            [self setStrobeTimer];
            _flashTurnedOn = true;
            desligado = false;
        }
    }
}

- (IBAction)settingsButtonTouchedUp:(UIButton *)sender {
    [playerSettingsButton play];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [gadBannerView hide];
    if (!bannerIsVisible) {
        NSLog(@"bannerViewDidLoadAd");
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (bannerIsVisible) {
        NSLog(@"bannerView:didFailToReceiveAdWithError:");
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, 50);        
        [UIView commitAnimations];
        bannerIsVisible = NO;
    }
    if (gadBannerView.hasAd) {
        [gadBannerView show];
    }
}



@end

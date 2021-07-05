//
//  MyGADBannerView.m
//  sensitive lantern
//
//  Created by Maxwell on 19/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import "MyGADBannerView.h"

@implementation MyGADBannerView

@synthesize hasAd, isVisible;

NSString *const MY_BANNER_UNIT_ID = @"a151241bd55becf";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) initGADBannerView:(UIViewController *)_viewController
{
    hasAd = isVisible = NO;
    
    [self setDelegate:self];
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //   gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    self.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    self.rootViewController = _viewController;
    //    [self.view addSubview:gadBannerView];
    
    GADRequest *request = [GADRequest request];
  //  request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    
    // Initiate a generic request to load it with an ad.
    [self loadRequest:request];
}

- (void)show
{
    if (!isVisible)
    {
        [UIView beginAnimations:@"gadBannerOn" context:nil];
        self.frame = CGRectMake(0.0,
                                      self.rootViewController.view.frame.size.height -
                                      self.frame.size.height,
                                      self.frame.size.width,
                                      self.frame.size.height);
        [UIView commitAnimations];
        isVisible = YES;
    }
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    hasAd = YES;
}

- (void)hide
{
    if (isVisible)
    {
        [UIView beginAnimations:@"gadBannerOff" context:nil];
        self.frame = CGRectMake(0.0,
                                      self.rootViewController.view.frame.size.height +
                                      self.frame.size.height,
                                      self.frame.size.width,
                                      self.frame.size.height);
        [UIView commitAnimations];
        isVisible = NO;
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    hasAd = NO;
}

@end

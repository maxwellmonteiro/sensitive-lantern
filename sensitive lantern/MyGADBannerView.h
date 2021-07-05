//
//  MyGADBannerView.h
//  sensitive lantern
//
//  Created by Maxwell on 19/02/13.
//  Copyright (c) 2013 Maxwell. All rights reserved.
//

#import "GADBannerView.h"

@interface MyGADBannerView : GADBannerView <GADBannerViewDelegate>
{

}

@property bool hasAd;
@property bool isVisible;

- (void) initGADBannerView:(UIViewController *)viewController;
- (void)show;
- (void)hide;

@end

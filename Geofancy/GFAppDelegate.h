//
//  GFAppDelegate.h
//  Geofancy
//
//  Created by Marcus Kida on 03.10.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOS-GPX-Framework/GPX.h>

#import "AFNetworking.h"
#import "MSDynamicsDrawerViewController.h"
#import "GFGeofenceManager.h"
#import "GFCloudManager.h"
#import "GFRequestManager.h"
#import "GFWhatsUpNotifier.h"

@interface GFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (strong, nonatomic) GFGeofenceManager *geofenceManager;
@property (strong, nonatomic) GFCloudManager *cloudManager;
@property (strong, nonatomic) GFRequestManager *requestManager;
@property (strong, nonatomic) GFWhatsUpNotifier *whatsupNotifier;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@end

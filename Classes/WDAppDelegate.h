//
//  WDAppDelegate.h
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2010-2013 Steve Sprang & 2014 Vladimir Danila
//
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define BOTTOM_AD_UNIT_ID @"ca-app-pub-6270543066068054/xxxxxxxxxx"
#define INTERSTITIAL_AD_UNIT_ID @"ca-app-pub-6270543066068054/xxxxxxxxxx"
#define unlockAd_inAppPurchaseID @"yourdomain.illustdrawingpad.iap"

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface WDAppDelegate : NSObject <UIApplicationDelegate, DBSessionDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, copy) void (^performAfterDropboxLoginBlock)(void);

- (void) unlinkDropbox;

@end

extern NSString *WDDropboxWasUnlinkedNotification;


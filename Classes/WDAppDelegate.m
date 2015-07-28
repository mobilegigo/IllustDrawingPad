//
//  WDAppDelegate.m
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2010-2013 Steve Sprang & 2014 Vladimir Danila
//

#import "WDAppDelegate.h"
#import "WDBrowserController.h"
#import "WDCanvasController.h"
#import "WDColor.h"
#import "WDDrawing.h"
#import "WDDrawingManager.h"
#import "WDFontManager.h"
#import "WDGradient.h"
#import "WDInspectableProperties.h"

NSString *WDDropboxWasUnlinkedNotification = @"WDDropboxWasUnlinkedNotification";

@implementation WDAppDelegate

@synthesize window;
@synthesize performAfterDropboxLoginBlock;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
    
    
    // Load the fonts at startup. Dispatch this call at the end of the main queue;
    // It will then dispatch the real work on another queue after the app launches.
    dispatch_async(dispatch_get_main_queue(), ^{
        [WDFontManager sharedInstance];
    });
    
    [self clearTempDirectory];
    
    [self setupDefaults];
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"firstTimeLaunch"] isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"firstTimeLaunch"];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isfullPackPurchased"];
    }
    
}

- (BOOL) validFile:(NSURL *)url
{
    WDDrawing *drawing = nil;
    
    @try {
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        drawing = [unarchiver decodeObjectForKey:WDDrawingKey];
        [unarchiver finishDecoding];
    } @catch (NSException *exception) {
    } @finally {
    }
    
    return (drawing ? YES : NO);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self applicationDidFinishLaunching:application];
    
    if (launchOptions) {
        NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
        
        if (url) {
            return [self validFile:url];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            if (self.performAfterDropboxLoginBlock) {
                self.performAfterDropboxLoginBlock();
                self.performAfterDropboxLoginBlock = nil;
            }
        }
        return YES;
    }
    
    [[WDDrawingManager sharedInstance] importDrawingAtURL:url errorBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Broken Drawing",
                                                                                      @"Broken Drawing")
                                                            message:NSLocalizedString(@"IllustDrawingPad could not open the requested drawing.",
                                                                                      @"IllustDrawingPad could not open the requested drawing.")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
        [alertView show];
    } withCompletionHandler:^(WDDocument *document) {
        UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
        
        if ([navigationController.topViewController isKindOfClass:[WDCanvasController class]]) {
            WDCanvasController *canvasController = (WDCanvasController *) navigationController.topViewController;
            canvasController.document = document;
        }
    }];
    
    return YES;
}

- (void) clearTempDirectory
{
    NSFileManager   *fm = [NSFileManager defaultManager];
    NSURL           *tmpURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    NSArray         *files = [fm contentsOfDirectoryAtURL:tmpURL includingPropertiesForKeys:[NSArray array] options:0 error:NULL];
    
    for (NSURL *url in files) {
        [fm removeItemAtURL:url error:nil];
    }
}

- (void) setupDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Defaults.plist"];
    [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:defaultPath]];
    
    // Install valid defaults for various colors/gradients if necessary. These can't be encoded in the Defaults.plist.
    if (![defaults objectForKey:WDStrokeColorProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor blackColor]];
        [defaults setObject:value forKey:WDStrokeColorProperty];
    }
    
    if (![defaults objectForKey:WDFillProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor whiteColor]];
        [defaults setObject:value forKey:WDFillProperty];
    }
    
    if (![defaults objectForKey:WDFillColorProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor whiteColor]];
        [defaults setObject:value forKey:WDFillColorProperty];
    }
    
    if (![defaults objectForKey:WDFillGradientProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDGradient defaultGradient]];
        [defaults setObject:value forKey:WDFillGradientProperty];
    }
    
    if (![defaults objectForKey:WDStrokeDashPatternProperty]) {
        NSArray *dashes = @[];
        [defaults setObject:dashes forKey:WDStrokeDashPatternProperty];
    }
    
    if (![defaults objectForKey:WDShadowColorProperty]) {
        NSData *value = [NSKeyedArchiver archivedDataWithRootObject:[WDColor colorWithRed:0 green:0 blue:0 alpha:0.333f]];
        [defaults setObject:value forKey:WDShadowColorProperty];
    }
}

#pragma mark -
#pragma mark Dropbox

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if ([[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] unlinkAll];
    } 
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WDDropboxWasUnlinkedNotification object:self];
}

- (void) unlinkDropbox
{
    if (![[DBSession sharedSession] isLinked]) {
        return;
    } 
    
    NSString *title = NSLocalizedString(@"Unlink Dropbox", @"Unlink Dropbox");
    NSString *message = NSLocalizedString(@"Are you sure you want to unlink your Dropbox account?",
                                          @"Are you sure you want to unlink your Dropbox account?");
    
    NSString *unlinkButtonTitle = NSLocalizedString(@"Unlink", @"Unlink");
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", @"Cancel");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:unlinkButtonTitle, cancelButtonTitle, nil];
    alertView.cancelButtonIndex = 1;
    
    [alertView show];
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{

        NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
        return orientations;
    
}

@end

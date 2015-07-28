//
//  WDBrowserController.h
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2011-2013 Steve Sprang & 2014 Vladimir Danila
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "OCADownloader.h"
#import "WDHelpController.h"
#import "WDImportController.h"
#import "WDSamplesController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WDActionSheet.h"
#import <iAd/iAd.h>

@class WDActivityManager;
@class WDDocument;
@class WDDrawing;
@class WDFontLibraryController;
@class WDPageSizeController;
@class WDThumbnailView;

@class DBRestClient;
@class WDActivityController;
@class WDBlockingView;
@class WDExportController;
@class OCAViewController;

@interface WDBrowserController : UICollectionViewController <UIActionSheetDelegate,
                                                             UIPopoverControllerDelegate,
                                                             DBRestClientDelegate,
                                                             MFMailComposeViewControllerDelegate,
                                                             WDImportControllerDelegate,
                                                             WDSamplesControllerDelegate,
                                                             UINavigationControllerDelegate,
                                                             UIImagePickerControllerDelegate,
                                                             OCADownloaderDelegate,
                                                            WDActionSheetDelegate,
                                                            UIDocumentInteractionControllerDelegate,
                                                             UIDocumentPickerDelegate>
{
    NSMutableArray          *toolbarItems_;
    UIBarButtonItem         *emailItem_;
    UIBarButtonItem         *dropboxExportItem_;
    UIActivityIndicatorView *activityIndicator_;
    UIBarButtonItem         *activityItem_;
    UIBarButtonItem         *deleteItem_;
    UIActionSheet           *deleteSheet_;
   
    WDActionSheet  *shareSheet;
    
    UIBarButtonItem         *icloudDrive;
    
    NSMutableSet            *selectedDrawings_;
    
    UIPopoverController     *popoverController_;
    WDPageSizeController    *pageSizeController_;
    WDExportController      *exportController_;
	WDImportController		*importController_;
    UIImagePickerController *pickerController_;
    WDFontLibraryController *fontLibraryController_;
    WDSamplesController     *samplesController_;
    WDActivityController    *activityController_;
    OCAViewController       *openClipArtController_;
    
    DBRestClient            *restClient_;
    NSMutableSet            *filesBeingUploaded_;
    WDActivityManager       *activities_;

    WDBlockingView          *blockingView_;
    WDThumbnailView         *editingThumbnail_;
    
    BOOL                    everLoaded_;
    
    NSMutableSet            *downloaders_; // for downloading open clip art
    IBOutlet UICollectionView *startCollectionView;
}

- (void) startEditingDrawing:(WDDocument *)drawing;
@property (nonatomic, weak) UIViewController *currentPopoverViewController;

@end

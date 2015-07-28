//
//  WDSettingsController.h
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2011-2013 Steve Sprang & 2014 Vladimir Danila
//

#import <UIKit/UIKit.h>
#import "PurchaseViewController.h"
@class WDDrawing;

@interface WDSettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PurchaseViewDelegate> {
    IBOutlet UITableView    *table_;
    NSArray                 *configuration_;
    UITextField             *gridSpacing_;
    UITableViewCell         *unitsCell_;
    UITableViewCell         *unitsCell2_;
    NSNumberFormatter       *formatter_;
    MyManager *sharedManager;
}

@property (nonatomic, weak) WDDrawing *drawing;

- (NSString *) dimensionsString;

@end


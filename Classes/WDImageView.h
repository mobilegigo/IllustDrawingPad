//
//  WDImageView.h
//  Inkpad
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Steve Sprang & 2014 Vladimir Danila
//

#import <UIKit/UIKit.h>

@interface WDImageView : UIView

- (id) initWithImage:(UIImage *)image maxDimension:(float)maxDimension;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) float maximumDimension;

@end
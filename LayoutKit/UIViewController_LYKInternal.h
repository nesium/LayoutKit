//
//  UIViewController_LYKInternal.h
//  LayoutKit
//
//  Created by Marc Bauer on 15.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "UIViewController+LayoutKit.h"

@class LYKCSSDocument;

@interface UIViewController (LYKInternal)
@property (nonatomic, readonly) LYKCSSDocument *lyk_CSSDocument;
@end
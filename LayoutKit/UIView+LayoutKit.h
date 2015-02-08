//
//  UIView+LayoutKit.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

@class LYKStyle;

@interface UIView (LayoutKit)
@property (nonatomic, strong, readonly) LYKStyle *lyk_style;
@end
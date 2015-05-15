//
//  UIViewController+LayoutKit.h
//  LayoutKit
//
//  Created by Marc Bauer on 15.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

@interface UIViewController (LayoutKit)
@property (nonatomic, copy, setter=lyk_setCSSFilePath:) NSString *lyk_CSSFilePath;
@end
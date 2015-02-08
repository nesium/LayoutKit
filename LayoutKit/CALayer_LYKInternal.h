//
//  CALayer_LYKInternal.h
//  LayoutKit
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import QuartzCore;

@class LYKStyle;

@interface CALayer (LYKInternal)
@property (nonatomic, strong, readonly) LYKStyle *lyk_style;
@end
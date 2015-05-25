//
//  CALayer_LYKInternal.h
//  LayoutKit
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "CALayer+LayoutKit.h"

@class LYKStyle;

@interface CALayer (LYKInternal)
@property (nonatomic, strong, readonly) LYKStyle *lyk_style;
@property (nonatomic, assign, readonly) BOOL lyk_hasStyle;
@property (nonatomic, assign, setter=lyk_setRootLayer:) BOOL lyk_rootLayer;
@end
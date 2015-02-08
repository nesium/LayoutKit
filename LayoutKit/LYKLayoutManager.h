//
//  LYKLayoutManager.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import QuartzCore;

@protocol LYKLayoutManager <NSObject>
- (void)invalidateLayoutOfLayer:(CALayer *)layer;
- (void)layoutSublayersOfLayer:(CALayer *)layer;
@end
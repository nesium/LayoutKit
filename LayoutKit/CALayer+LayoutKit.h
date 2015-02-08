//
//  CALayer+LayoutKit.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import QuartzCore;

#import <LayoutKit/LYKLayoutManager.h>

@interface CALayer (LayoutKit)
@property (nonatomic, strong, setter=lyk_setLayoutManager:) id<LYKLayoutManager> lyk_layoutManager;
@end
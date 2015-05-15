//
//  LYKStyle_Internal.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

#import "LYKStyle.h"
#import "Layout.h"

@interface LYKStyle ()
@property (nonatomic, readonly) CGRect layoutedFrame;
@property (nonatomic, readonly) css_node_t *CSSNode;

- (void)prepareForLayout;
- (void)performLayout;

- (void)setNumberOfChildren:(NSUInteger)numberOfChildren;

- (void)setMeasureBlock:(CGSize (^)(CGFloat width))block;
- (void)setGetChildBlock:(LYKStyle *(^)(NSUInteger idx))block;

- (void)setChangeHandler:(void (^)(void))handler;
@end
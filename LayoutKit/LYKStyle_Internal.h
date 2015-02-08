//
//  LYKStyle_Internal.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

#import "LYKStyle.h"

@interface LYKStyle ()
@property (nonatomic, readonly) CGRect layoutedFrame;

- (void)prepareForLayout;
- (void)performLayout;

- (void)setNumberOfChildren:(NSUInteger)numberOfChildren;

- (void)setMeasureBlock:(CGSize (^)(CGFloat width))block;
- (void)setGetChildBlock:(LYKStyle *(^)(NSUInteger idx))block;

- (void)setChangeHandler:(void (^)(void))handler;
@end
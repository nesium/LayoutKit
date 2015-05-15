//
//  LYKStyle.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

#import <LayoutKit/LYKTypes.h>

@interface LYKStyle : NSObject
@property (nonatomic, assign) LYKCSSDisplay display;
@property (nonatomic, assign) LYKCSSFlexDirection direction;
@property (nonatomic, assign) LYKCSSJustification contentJustification;
@property (nonatomic, assign) LYKCSSAlign itemsAlignment;
@property (nonatomic, assign) LYKCSSAlign selfAlignment;
@property (nonatomic, assign) LYKCSSPositionType positionType;
@property (nonatomic, assign) LYKCSSWrap wrap;
@property (nonatomic, assign) CGFloat flex;
@property (nonatomic, assign) LYKCSSEdgeInsets margin;
@property (nonatomic, assign) LYKCSSEdgeInsets position;
@property (nonatomic, assign) LYKCSSEdgeInsets padding;
@property (nonatomic, assign) LYKCSSEdgeInsets border;
@property (nonatomic, assign) CGSize size;
@end
//
//  LYKTypes.h
//  LayoutKit
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

typedef struct LYKCSSEdgeInsets {
    CGFloat top, left, bottom, right;
} LYKCSSEdgeInsets;

extern const LYKCSSEdgeInsets LYKCSSInsetsZero;
extern const CGSize LYKCSSSizeZero;

typedef NS_ENUM(NSUInteger, LYKCSSDisplay) {
    LYKCSSDisplayFlex,
    LYKCSSDisplayInline
};

typedef NS_ENUM(NSUInteger, LYKCSSFlexDirection) {
    LYKCSSFlexDirectionColumn,
    LYKCSSFlexDirectionRow
};

typedef NS_ENUM(NSUInteger, LYKCSSJustification) {
    LYKCSSJustificationStart,
    LYKCSSJustificationCenter,
    LYKCSSJustificationEnd,
    LYKCSSJustificationSpaceBetween,
    LYKCSSJustificationSpaceAround
};

typedef NS_ENUM(NSUInteger, LYKCSSAlign) {
    LYKCSSAlignAuto,
    LYKCSSAlignStart,
    LYKCSSAlignCenter,
    LYKCSSAlignEnd,
    LYKCSSAlignStretch
};

typedef NS_ENUM(NSUInteger, LYKCSSPositionType) {
    LYKCSSPositionTypeRelative,
    LYKCSSPositionTypeAbsolute
};

typedef NS_ENUM(NSUInteger, LYKCSSWrap) {
    LYKCSSWrapNone,
    LYKCSSWrapWrap
};

typedef NS_ENUM(NSUInteger, LYKCSSPosition) {
    LYKCSSPositionLeft,
    LYKCSSPositionTop,
    LYKCSSPositionRight,
    LYKCSSPositionBottom
};
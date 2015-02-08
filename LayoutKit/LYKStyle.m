//
//  LYKStyle.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKStyle_Internal.h"

const LYKCSSEdgeInsets LYKCSSInsetsZero =
    (LYKCSSEdgeInsets){0.0f, 0.0f, 0.0f, 0.0f};
const CGSize LYKCSSSizeZero = (CGSize){CSS_UNDEFINED, CSS_UNDEFINED};

@implementation LYKStyle

#pragma mark - Initialization & Deallocation

- (instancetype)init
{
	if ((self = [super init])) {
        _CSSNode = new_css_node();
        init_css_node(_CSSNode);
        
        self.display = LYKCSSDisplayFlex;
        self.direction = LYKCSSFlexDirectionRow;
        self.contentJustification = LYKCSSJustificationStart;
        self.itemsAlignment = LYKCSSAlignStart;
        self.selfAlignment = LYKCSSAlignAuto;
        self.positionType = LYKCSSPositionTypeRelative;
        self.wrap = LYKCSSWrapNone;
        self.flex = 0.0f;
        self.margin = LYKCSSInsetsZero;
        self.position = LYKCSSInsetsZero;
        self.padding = LYKCSSInsetsZero;
        self.border = LYKCSSInsetsZero;
        self.size = LYKCSSSizeZero;
	}
	return self;
}

- (void)dealloc
{
    free_css_node(_CSSNode);
}



#pragma mark - Public Methods

- (void)setDirection:(LYKCSSFlexDirection)direction
{
    _CSSNode->style.flex_direction = (css_flex_direction_t)direction;
}

- (LYKCSSFlexDirection)direction
{
    return (LYKCSSFlexDirection)_CSSNode->style.flex_direction;
}

- (void)setContentJustification:(LYKCSSJustification)contentJustification
{
    _CSSNode->style.justify_content = (css_justify_t)contentJustification;
}

- (LYKCSSJustification)contentJustification
{
    return (LYKCSSJustification)_CSSNode->style.justify_content;
}

- (void)setItemsAlignment:(LYKCSSAlign)itemsAlignment
{
    _CSSNode->style.align_items = (css_align_t)itemsAlignment;
}

- (LYKCSSAlign)itemsAlignment
{
    return (LYKCSSAlign)_CSSNode->style.align_items;
}

- (void)setSelfAlignment:(LYKCSSAlign)selfAlignment
{
    _CSSNode->style.align_self = (css_align_t)selfAlignment;
}

- (LYKCSSAlign)selfAlignment
{
    return (LYKCSSAlign)_CSSNode->style.align_self;
}

- (void)setPositionType:(LYKCSSPositionType)positionType
{
    _CSSNode->style.position_type = (css_position_type_t)positionType;
}

- (LYKCSSPositionType)positionType
{
    return (LYKCSSPositionType)_CSSNode->style.position_type;
}

- (void)setWrap:(LYKCSSWrap)wrap
{
    _CSSNode->style.flex_wrap = (css_wrap_type_t)wrap;
}

- (LYKCSSWrap)wrap
{
    return (LYKCSSWrap)_CSSNode->style.flex_wrap;
}

- (void)setFlex:(CGFloat)flex
{
    _CSSNode->style.flex = flex;
}

- (CGFloat)flex
{
    return _CSSNode->style.flex;
}

- (void)setMargin:(LYKCSSEdgeInsets)margin
{
    _CSSNode->style.margin[CSS_TOP] = margin.top;
    _CSSNode->style.margin[CSS_LEFT] = margin.left;
    _CSSNode->style.margin[CSS_BOTTOM] = margin.bottom;
    _CSSNode->style.margin[CSS_RIGHT] = margin.right;
}

- (LYKCSSEdgeInsets)margin
{
    return (LYKCSSEdgeInsets){
        _CSSNode->style.margin[CSS_TOP],
        _CSSNode->style.margin[CSS_LEFT],
        _CSSNode->style.margin[CSS_BOTTOM],
        _CSSNode->style.margin[CSS_RIGHT]
    };
}

- (void)setPosition:(LYKCSSEdgeInsets)position
{
    _CSSNode->style.position[CSS_TOP] = position.top;
    _CSSNode->style.position[CSS_LEFT] = position.left;
    _CSSNode->style.position[CSS_BOTTOM] = position.bottom;
    _CSSNode->style.position[CSS_RIGHT] = position.right;
}

- (LYKCSSEdgeInsets)position
{
    return (LYKCSSEdgeInsets){
        _CSSNode->layout.position[CSS_TOP],
        _CSSNode->layout.position[CSS_LEFT],
        CSS_UNDEFINED,
        CSS_UNDEFINED
    };
}

- (void)setPadding:(LYKCSSEdgeInsets)padding
{
    _CSSNode->style.padding[CSS_TOP] = padding.top;
    _CSSNode->style.padding[CSS_LEFT] = padding.left;
    _CSSNode->style.padding[CSS_BOTTOM] = padding.bottom;
    _CSSNode->style.padding[CSS_RIGHT] = padding.right;
}

- (LYKCSSEdgeInsets)padding
{
    return (LYKCSSEdgeInsets){
        _CSSNode->style.padding[CSS_TOP],
        _CSSNode->style.padding[CSS_LEFT],
        _CSSNode->style.padding[CSS_BOTTOM],
        _CSSNode->style.padding[CSS_RIGHT]
    };
}

- (void)setBorder:(LYKCSSEdgeInsets)border
{
    _CSSNode->style.border[CSS_TOP] = border.top;
    _CSSNode->style.border[CSS_LEFT] = border.left;
    _CSSNode->style.border[CSS_BOTTOM] = border.bottom;
    _CSSNode->style.border[CSS_RIGHT] = border.right;
}

- (LYKCSSEdgeInsets)border
{
    return (LYKCSSEdgeInsets){
        _CSSNode->style.border[CSS_TOP],
        _CSSNode->style.border[CSS_LEFT],
        _CSSNode->style.border[CSS_BOTTOM],
        _CSSNode->style.border[CSS_RIGHT]
    };
}

- (void)setSize:(CGSize)size
{
    _CSSNode->style.dimensions[CSS_WIDTH] = size.width;
    _CSSNode->style.dimensions[CSS_HEIGHT] = size.height;
}

- (CGSize)size
{
    return (CGSize){
        _CSSNode->layout.dimensions[CSS_WIDTH],
        _CSSNode->layout.dimensions[CSS_HEIGHT]
    };
}
@end
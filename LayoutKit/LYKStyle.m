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

static css_dim_t measure(void *context, float width);
static css_node_t *getChild(void *context, int i);
static bool isDirty(void *context);

@implementation LYKStyle
{
    @public
        BOOL _isDirty;
        css_node_t *_CSSNode;
        CGSize (^_measureBlock)(CGFloat);
        LYKStyle *(^_getChildBlock)(NSUInteger);
        void (^_changeHandler)(void);
}

#pragma mark - Initialization & Deallocation

- (instancetype)init
{
	if ((self = [super init])) {
        _CSSNode = new_css_node();
        init_css_node(_CSSNode);
        _CSSNode->context = (__bridge void *)self;
        _CSSNode->get_child = getChild;
        _CSSNode->is_dirty = isDirty;
        _isDirty = YES;
        
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

- (void)setDisplay:(LYKCSSDisplay)display
{
    if (_display == display) {
        return;
    }
    _display = display;
    [self updateMeasureCallback];
    [self handleChange];
}

- (void)setDirection:(LYKCSSFlexDirection)direction
{
    if (_CSSNode->style.flex_direction == (css_flex_direction_t)direction) {
        return;
    }
    _CSSNode->style.flex_direction = (css_flex_direction_t)direction;
    [self handleChange];
}

- (LYKCSSFlexDirection)direction
{
    return (LYKCSSFlexDirection)_CSSNode->style.flex_direction;
}

- (void)setContentJustification:(LYKCSSJustification)contentJustification
{
    if (_CSSNode->style.justify_content == (css_justify_t)contentJustification) {
        return;
    }
    _CSSNode->style.justify_content = (css_justify_t)contentJustification;
    [self handleChange];
}

- (LYKCSSJustification)contentJustification
{
    return (LYKCSSJustification)_CSSNode->style.justify_content;
}

- (void)setItemsAlignment:(LYKCSSAlign)itemsAlignment
{
    if (_CSSNode->style.align_items == (css_align_t)itemsAlignment) {
        return;
    }
    _CSSNode->style.align_items = (css_align_t)itemsAlignment;
    [self handleChange];
}

- (LYKCSSAlign)itemsAlignment
{
    return (LYKCSSAlign)_CSSNode->style.align_items;
}

- (void)setSelfAlignment:(LYKCSSAlign)selfAlignment
{
    if (_CSSNode->style.align_self == (css_align_t)selfAlignment) {
        return;
    }
    _CSSNode->style.align_self = (css_align_t)selfAlignment;
    [self handleChange];
}

- (LYKCSSAlign)selfAlignment
{
    return (LYKCSSAlign)_CSSNode->style.align_self;
}

- (void)setPositionType:(LYKCSSPositionType)positionType
{
    if (_CSSNode->style.position_type == (css_position_type_t)positionType) {
        return;
    }
    _CSSNode->style.position_type = (css_position_type_t)positionType;
    [self handleChange];
}

- (LYKCSSPositionType)positionType
{
    return (LYKCSSPositionType)_CSSNode->style.position_type;
}

- (void)setWrap:(LYKCSSWrap)wrap
{
    if (_CSSNode->style.flex_wrap == (css_wrap_type_t)wrap) {
        return;
    }
    _CSSNode->style.flex_wrap = (css_wrap_type_t)wrap;
    [self handleChange];
}

- (LYKCSSWrap)wrap
{
    return (LYKCSSWrap)_CSSNode->style.flex_wrap;
}

- (void)setFlex:(CGFloat)flex
{
    if (_CSSNode->style.flex == flex) {
        return;
    }
    _CSSNode->style.flex = flex;
    [self handleChange];
}

- (CGFloat)flex
{
    return _CSSNode->style.flex;
}

- (void)setMargin:(LYKCSSEdgeInsets)margin
{
    if (_CSSNode->style.margin[CSS_TOP] == margin.top &&
        _CSSNode->style.margin[CSS_LEFT] == margin.left &&
        _CSSNode->style.margin[CSS_BOTTOM] == margin.bottom &&
        _CSSNode->style.margin[CSS_RIGHT] == margin.right) {
        return;
    }
    
    _CSSNode->style.margin[CSS_TOP] = margin.top;
    _CSSNode->style.margin[CSS_LEFT] = margin.left;
    _CSSNode->style.margin[CSS_BOTTOM] = margin.bottom;
    _CSSNode->style.margin[CSS_RIGHT] = margin.right;
    [self handleChange];
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
    if (_CSSNode->style.position[CSS_TOP] == position.top &&
        _CSSNode->style.position[CSS_LEFT] == position.left &&
        _CSSNode->style.position[CSS_BOTTOM] == position.bottom &&
        _CSSNode->style.position[CSS_RIGHT] == position.right) {
        return;
    }

    _CSSNode->style.position[CSS_TOP] = position.top;
    _CSSNode->style.position[CSS_LEFT] = position.left;
    _CSSNode->style.position[CSS_BOTTOM] = position.bottom;
    _CSSNode->style.position[CSS_RIGHT] = position.right;
    [self handleChange];
}

- (LYKCSSEdgeInsets)position
{
    return (LYKCSSEdgeInsets){
        _CSSNode->style.position[CSS_TOP],
        _CSSNode->style.position[CSS_LEFT],
        _CSSNode->style.position[CSS_BOTTOM],
        _CSSNode->style.position[CSS_RIGHT]
    };
}

- (void)setPadding:(LYKCSSEdgeInsets)padding
{
    if (_CSSNode->style.padding[CSS_TOP] == padding.top &&
        _CSSNode->style.padding[CSS_LEFT] == padding.left &&
        _CSSNode->style.padding[CSS_BOTTOM] == padding.bottom &&
        _CSSNode->style.padding[CSS_RIGHT] == padding.right) {
        return;
    }

    _CSSNode->style.padding[CSS_TOP] = padding.top;
    _CSSNode->style.padding[CSS_LEFT] = padding.left;
    _CSSNode->style.padding[CSS_BOTTOM] = padding.bottom;
    _CSSNode->style.padding[CSS_RIGHT] = padding.right;
    [self handleChange];
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
    if (_CSSNode->style.border[CSS_TOP] == border.top &&
        _CSSNode->style.border[CSS_LEFT] == border.left &&
        _CSSNode->style.border[CSS_BOTTOM] == border.bottom &&
        _CSSNode->style.border[CSS_RIGHT] == border.right) {
        return;
    }

    _CSSNode->style.border[CSS_TOP] = border.top;
    _CSSNode->style.border[CSS_LEFT] = border.left;
    _CSSNode->style.border[CSS_BOTTOM] = border.bottom;
    _CSSNode->style.border[CSS_RIGHT] = border.right;
    [self handleChange];
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
    if (_CSSNode->style.dimensions[CSS_WIDTH] == size.width &&
        _CSSNode->style.dimensions[CSS_HEIGHT] == size.height) {
        return;
    }
    
    _CSSNode->style.dimensions[CSS_WIDTH] = size.width;
    _CSSNode->style.dimensions[CSS_HEIGHT] = size.height;
    [self updateMeasureCallback];
    [self handleChange];
}

- (CGSize)size
{
    return (CGSize){
        _CSSNode->style.dimensions[CSS_WIDTH],
        _CSSNode->style.dimensions[CSS_HEIGHT]
    };
}



#pragma mark - Internal Methods

- (CGRect)layoutedFrame
{
    return (CGRect){
        _CSSNode->layout.position[CSS_LEFT],
        _CSSNode->layout.position[CSS_TOP],
        _CSSNode->layout.dimensions[CSS_WIDTH],
        _CSSNode->layout.dimensions[CSS_HEIGHT]
    };
}

- (css_node_t *)CSSNode
{
    return _CSSNode;
}

- (void)prepareForLayout
{
    if (!_isDirty) {
        return;
    }
    
    _CSSNode->layout.position[CSS_TOP] = 0.0f;
    _CSSNode->layout.position[CSS_LEFT] = 0.0f;
    _CSSNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
    _CSSNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
}

- (void)performLayout
{
    layoutNode(_CSSNode, _CSSNode->style.dimensions[CSS_WIDTH], CSS_DIRECTION_LTR);
}

- (void)setNumberOfChildren:(NSUInteger)numberOfChildren
{
    if (_CSSNode->children_count == numberOfChildren) {
        return;
    }
    _CSSNode->children_count = (int)numberOfChildren;
    _isDirty = YES;
}

- (void)setMeasureBlock:(CGSize (^)(CGFloat))block
{
    _measureBlock = [block copy];
    [self updateMeasureCallback];
}

- (void)setGetChildBlock:(LYKStyle *(^)(NSUInteger))block
{
    _getChildBlock = [block copy];
}

- (void)setChangeHandler:(void (^)(void))handler
{
    _changeHandler = [handler copy];
}



#pragma mark - Private Methods

- (void)handleChange
{
    _isDirty = YES;
    if (_changeHandler != nil) {
        _changeHandler();
    }
}

- (void)updateMeasureCallback
{
    BOOL canMeasure = _measureBlock != nil;
    canMeasure = canMeasure && _display == LYKCSSDisplayInline;
    canMeasure = canMeasure && (!isnan(_CSSNode->style.dimensions[CSS_WIDTH]) ||
    	!isnan(_CSSNode->style.dimensions[CSS_HEIGHT]));
    
    _CSSNode->measure = canMeasure
        ? measure
        : NULL;
}
@end



static css_dim_t measure(void *context, float width)
{
    LYKStyle *style = (__bridge LYKStyle *)context;
    NSCAssert(style->_measureBlock != nil, @"");
    CGSize result = style->_measureBlock(width);
    
    css_dim_t dim;
    dim.dimensions[CSS_WIDTH] = result.width;
    dim.dimensions[CSS_HEIGHT] = result.height;
    return dim;
}

static css_node_t *getChild(void *context, int i)
{
    LYKStyle *style = (__bridge LYKStyle *)context;
    NSCAssert(style->_getChildBlock != nil, @"");
    LYKStyle *childStyle = style->_getChildBlock(i);
    NSCAssert(childStyle != nil, @"");
    return childStyle->_CSSNode;
}

static bool isDirty(void *context)
{
    LYKStyle *style = (__bridge LYKStyle *)context;
    return style->_isDirty;
}
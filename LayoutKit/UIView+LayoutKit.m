//
//  UIView+LayoutKit.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "UIView+LayoutKit.h"

#import "CALayer_LYKInternal.h"
#import "LYKStyle.h"

@implementation UIView (LayoutKit)

- (void)lyk_setDisplay:(LYKCSSDisplay)display
{
    self.layer.lyk_style.display = display;
}

- (LYKCSSDisplay)lyk_display
{
    return self.layer.lyk_style.display;
}

- (void)lyk_setDirection:(LYKCSSFlexDirection)direction
{
    self.layer.lyk_style.direction = direction;
}

- (LYKCSSFlexDirection)lyk_direction
{
    return self.layer.lyk_style.direction;
}

- (void)lyk_setContentJustification:(LYKCSSJustification)contentJustification
{
    self.layer.lyk_style.contentJustification = contentJustification;
}

- (LYKCSSJustification)lyk_contentJustification
{
    return self.layer.lyk_style.contentJustification;
}

- (void)lyk_setItemsAlignment:(LYKCSSAlign)itemsAlignment
{
    self.layer.lyk_style.itemsAlignment = itemsAlignment;
}

- (LYKCSSAlign)lyk_itemsAlignment
{
    return self.layer.lyk_style.itemsAlignment;
}

- (void)lyk_setSelfAlignment:(LYKCSSAlign)selfAlignment
{
    self.layer.lyk_style.selfAlignment = selfAlignment;
}

- (LYKCSSAlign)lyk_selfAlignment
{
    return self.layer.lyk_style.selfAlignment;
}

- (void)lyk_setPositionType:(LYKCSSPositionType)positionType
{
    self.layer.lyk_style.positionType = positionType;
}

- (LYKCSSPositionType)lyk_positionType
{
    return self.layer.lyk_style.positionType;
}

- (void)lyk_setWrap:(LYKCSSWrap)wrap
{
    self.layer.lyk_style.wrap = wrap;
}

- (LYKCSSWrap)lyk_wrap
{
    return self.layer.lyk_style.wrap;
}

- (void)lyk_setFlex:(CGFloat)flex
{
    self.layer.lyk_style.flex = flex;
}

- (CGFloat)lyk_flex
{
    return self.layer.lyk_style.flex;
}

- (void)lyk_setMargin:(LYKCSSEdgeInsets)margin
{
    self.layer.lyk_style.margin = margin;
}

- (LYKCSSEdgeInsets)lyk_margin
{
    return self.layer.lyk_style.margin;
}

- (void)lyk_setPosition:(LYKCSSEdgeInsets)position
{
    self.layer.lyk_style.position = position;
}

- (LYKCSSEdgeInsets)lyk_position
{
    return self.layer.lyk_style.position;
}

- (void)lyk_setPadding:(LYKCSSEdgeInsets)padding
{
    self.layer.lyk_style.padding = padding;
}

- (LYKCSSEdgeInsets)lyk_padding
{
    return self.layer.lyk_style.padding;
}

- (void)lyk_setBorder:(LYKCSSEdgeInsets)border
{
    self.layer.lyk_style.border = border;
}

- (LYKCSSEdgeInsets)lyk_border
{
    return self.layer.lyk_style.border;
}

- (void)lyk_setSize:(CGSize)size
{
    self.layer.lyk_style.size = size;
}

- (CGSize)lyk_size
{
    return self.layer.lyk_style.size;
}
@end
//
//  UIView+LayoutKit.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

#import <LayoutKit/LYKTypes.h>

@interface UIView (LayoutKit)
@property (nonatomic, assign, setter=lyk_setDisplay:) LYKCSSDisplay lyk_display;
@property (nonatomic, assign, setter=lyk_setDirection:) LYKCSSFlexDirection lyk_direction;
@property (nonatomic, assign, setter=lyk_setContentJustification:)
    LYKCSSJustification lyk_contentJustification;
@property (nonatomic, assign, setter=lyk_setItemsAlignment:) LYKCSSAlign lyk_itemsAlignment;
@property (nonatomic, assign, setter=lyk_setSelfAlignment:) LYKCSSAlign lyk_selfAlignment;
@property (nonatomic, assign, setter=lyk_setPositionType:) LYKCSSPositionType lyk_positionType;
@property (nonatomic, assign, setter=lyk_setWrap:) LYKCSSWrap lyk_wrap;
@property (nonatomic, assign, setter=lyk_setFlex:) CGFloat lyk_flex;
@property (nonatomic, assign, setter=lyk_setMargin:) LYKCSSEdgeInsets lyk_margin;
@property (nonatomic, assign, setter=lyk_setPosition:) LYKCSSEdgeInsets lyk_position;
@property (nonatomic, assign, setter=lyk_setPadding:) LYKCSSEdgeInsets lyk_padding;
@property (nonatomic, assign, setter=lyk_setBorder:) LYKCSSEdgeInsets lyk_border;
@property (nonatomic, assign, setter=lyk_setSize:) CGSize lyk_size;
@end
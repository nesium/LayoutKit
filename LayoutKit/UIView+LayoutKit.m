//
//  UIView+LayoutKit.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "UIView+LayoutKit.h"

#import "LYKStyle.h"

@import ObjectiveC.runtime;

static void *kStyleKey;

@interface UIView ()
@property (nonatomic, strong, readwrite, setter=lyk_setStyle:) LYKStyle *lyk_style;
@end

@implementation UIView (LayoutKit)

- (void)lyk_setStyle:(LYKStyle *)style
{
    objc_setAssociatedObject(self, &kStyleKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.layer setNeedsLayout];
}

- (LYKStyle *)lyk_style
{
    LYKStyle *style = objc_getAssociatedObject(self, &kStyleKey);
    if (style == nil) {
        style = [LYKStyle new];
        self.lyk_style = style;
    }
    return style;
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    return nil;
}
@end
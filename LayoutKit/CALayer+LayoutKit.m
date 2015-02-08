//
//  CALayer+LayoutKit.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "CALayer+LayoutKit.h"
#import "CALayer_LYKInternal.h"

#import "LYKUtils.h"
#import "LYKStyle.h"

@import ObjectiveC.runtime;

static void *kLayoutManagerKey;
static void *kStyleKey;

@interface CALayer ()
@property (nonatomic, strong, readwrite, setter=lyk_setStyle:) LYKStyle *lyk_style;
@end

@implementation CALayer (LayoutKit)

+ (void)load
{
    if (self == [CALayer class]) {
        [self lyk_enableLayoutKitLayout];
    }
}

+ (void)lyk_enableLayoutKitLayout
{
    LYKMethodSwizzle([self class], @selector(layoutSublayers), @selector(lyk_layoutSublayers));
}

- (void)lyk_setLayoutManager:(id<LYKLayoutManager>)layoutManager
{
    objc_setAssociatedObject(self, &kLayoutManagerKey, layoutManager,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
    [layoutManager invalidateLayoutOfLayer:self];
}

- (id<LYKLayoutManager>)lyk_layoutManager
{
    return objc_getAssociatedObject(self, &kLayoutManagerKey);
}

- (void)lyk_setStyle:(LYKStyle *)style
{
    objc_setAssociatedObject(self, &kStyleKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
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

- (void)lyk_layoutSublayers
{
    if (self.lyk_layoutManager) {
        if (self.sublayers.count) {
            [self.lyk_layoutManager layoutSublayersOfLayer:self];
        }
    } else {
        [self lyk_layoutSublayers];
    }
}
@end
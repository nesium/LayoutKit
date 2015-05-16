//
//  UIView+LayoutKit.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "UIView+LayoutKit.h"

@import ObjectiveC.runtime;

#import "LYKStyle.h"
#import "LYKUtils.h"
#import "LYKCSSDocument.h"
#import "CALayer_LYKInternal.h"
#import "UIViewController_LYKInternal.h"

static void *kNameKey;

@implementation UIView (LayoutKit)

#pragma mark - Initialization

+ (void)load
{
    if (self == [UIView class]) {
        [self lyk_enableLayoutKitLayout];
    }
}



#pragma mark - Public Methods

- (NSString *)lyk_name
{
    return objc_getAssociatedObject(self, &kNameKey);
}

- (void)lyk_setName:(NSString *)name
{
    objc_setAssociatedObject(self, &kNameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (LYKStyle *)lyk_style
{
    return self.layer.lyk_style;
}



#pragma mark - Private Methods

+ (void)lyk_enableLayoutKitLayout
{
    LYKMethodSwizzle([self class], @selector(didMoveToWindow), @selector(lyk_didMoveToWindow));
}

- (void)lyk_didMoveToWindow
{
    if (self.lyk_name != nil) {
        [self lyk_applyStyles];
    }
    [self lyk_didMoveToWindow];
}

- (void)lyk_applyStyles
{
    UIView *superview = self;
    LYKCSSDocument *cssDocument;
    
    while (superview) {
        if ([superview.nextResponder isKindOfClass:[UIViewController class]]) {
            cssDocument = ((UIViewController *)superview.nextResponder).lyk_CSSDocument;
            if (cssDocument != nil) {
                break;
            }
        }
        superview = superview.superview;
    }
    
    if (cssDocument == nil) {
        NSLog(@"No CSS Document found for View '%@'", self.lyk_name);
        return;
    }
    
    [cssDocument applyStylesToView:self];
}
@end
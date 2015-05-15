//
//  UIViewController+LayoutKit.m
//  LayoutKit
//
//  Created by Marc Bauer on 15.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "UIViewController_LYKInternal.h"

@import ObjectiveC.runtime;

#import "LYKUtils.h"
#import "LYKCSSDocument.h"
#import "UIView+LayoutKit.h"
#import "LYKStyle_Internal.h"
#import "CALayer+LayoutKit.h"
#import "LYKFlexBoxLayoutManager.h"

static void *kCSSFilePathKey;
static void *kCSSDocumentKey;

@implementation UIViewController (LayoutKit)

#pragma mark - Initialization

+ (void)load
{
    if (self == [UIViewController class]) {
        [self lyk_enableLayoutKitLayout];
    }
}



#pragma mark - Public Methods

- (NSString *)lyk_CSSFilePath
{
    return objc_getAssociatedObject(self, &kCSSFilePathKey);
}

- (void)lyk_setCSSFilePath:(NSString *)cssFilePath
{
    objc_setAssociatedObject(self, &kCSSFilePathKey, cssFilePath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



#pragma mark - Internal Methods

- (LYKCSSDocument *)lyk_CSSDocument
{
    return objc_getAssociatedObject(self, &kCSSDocumentKey);
}



#pragma mark - Private Methods

+ (void)lyk_enableLayoutKitLayout
{
    LYKMethodSwizzle([self class], @selector(viewDidLoad), @selector(lyk_viewDidLoad));
    LYKMethodSwizzle([self class],
        @selector(viewWillLayoutSubviews), @selector(lyk_viewWillLayoutSubviews));
}

- (void)lyk_viewDidLoad
{
    NSString *filePath = self.lyk_CSSFilePath;
    
    if (filePath != nil) {
        if (!filePath.isAbsolutePath) {
            filePath = [[NSBundle mainBundle]
            	pathForResource:[filePath stringByDeletingPathExtension]
                ofType:[filePath pathExtension]];
        }
        
        NSError *err;
        LYKCSSDocument *doc = [[LYKCSSDocument alloc] initWithContentsOfFile:filePath error:&err];
        if (doc == nil) {
            @throw [NSException exceptionWithName:NSGenericException
                reason:err.localizedDescription userInfo:nil];
        }
        
        if (![doc parse:&err]) {
            @throw [NSException exceptionWithName:NSGenericException
                reason:err.localizedDescription userInfo:nil];
        }
        
        objc_setAssociatedObject(self, &kCSSDocumentKey, doc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.view.lyk_name = @"root";
        [doc applyStylesToView:self.view];
        self.view.layer.lyk_layoutManager = [LYKFlexBoxLayoutManager new];
    }
    [self lyk_viewDidLoad];
}

- (void)lyk_viewWillLayoutSubviews
{
    self.view.lyk_style.size = self.view.frame.size;
    
    [self lyk_viewWillLayoutSubviews];
}
@end
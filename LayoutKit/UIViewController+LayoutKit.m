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
    }
    [self lyk_viewDidLoad];
}
@end
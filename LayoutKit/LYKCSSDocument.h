//
//  LYKCSSDocument.h
//  LayoutKitCSSParser
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

@interface LYKCSSDocument : NSObject
- (instancetype)initWithContentsOfFile:(NSString *)path error:(NSError **)error;

- (BOOL)parse:(NSError **)error;

- (void)applyStylesToView:(UIView *)aView;
@end
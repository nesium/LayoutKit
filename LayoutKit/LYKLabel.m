//
//  LYKLabel.m
//  LayoutKit
//
//  Created by Marc Bauer on 16.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKLabel.h"

#import "LYKUtils.h"
#import "UIView+LayoutKit.h"
#import "LYKStyle.h"
#import "CSSConsumer.h"
#import "LYKCSSUtils.h"

@interface LYKLabel () <CSSConsumer>
@end

@implementation LYKLabel

#pragma mark - Initialization & Deallocation

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
        self.lyk_style.display = LYKCSSDisplayInline;
	}
	return self;
}



#pragma mark - UIView Methods

- (UIEdgeInsets)alignmentRectInsets
{
    return (UIEdgeInsets){
        -lykCeilf(self.font.ascender - self.font.capHeight),
        0.0f,
        lykCeilf(self.font.descender),
        0.0f
    };
}



#pragma mark - CSSConsumer Methods

- (BOOL)applyCSSDeclaration:(KatanaDeclaration *)decl
{
    const char *p = decl->property;
    
    if (strcmp(p, "color") == 0) {
        self.textColor = LYKCSSColorWithValue(decl->values->data[0]);
        return YES;
    } else if (strcmp(p, "font") == 0) {
        NSAssert(decl->values->length == 2, @"Invalid font decl. Only fontSize and name allowed.");
        
        self.font = [UIFont
        	fontWithName:[NSString stringWithCString:((KatanaValue *)decl->values->data[1])->string
            	encoding:NSUTF8StringEncoding]
            size:((KatanaValue *)decl->values->data[0])->fValue];
        return YES;
    } else if (strcmp(p, "text-align") == 0) {
        const char *align = ((KatanaValue *)decl->values->data[0])->string;
        
        if (strcmp(align, "left") == 0) {
            self.textAlignment = NSTextAlignmentLeft;
        } else if (strcmp(align, "right") == 0) {
            self.textAlignment = NSTextAlignmentRight;
        } else if (strcmp(align, "center") == 0) {
            self.textAlignment = NSTextAlignmentCenter;
        } else if (strcmp(align, "justify") == 0) {
            self.textAlignment = NSTextAlignmentJustified;
        }
    
        return YES;
    }
    
    return NO;
}
@end
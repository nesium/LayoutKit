//
//  LYKCSSUtils.m
//  LayoutKit
//
//  Created by Marc Bauer on 15.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKCSSUtils.h"
#import "LYKTypes.h"
#import "ColorUtils.h"

void LYKCSSApplyBorder(KatanaDeclaration *decl, css_node_t *CSSNode, UIView *aView)
{
    float width = 0.0f;
    LYKCSSBorderStyle borderStyle = LYKCSSBorderStyleNone;
    UIColor *color;
    
    BOOL foundWidth = NO;
    BOOL foundStyle = NO;
    BOOL foundColor = NO;
    
    for (NSUInteger idx = 0; idx < decl->values->length; idx++) {
        KatanaValue *value = decl->values->data[idx];
        
        if (value->unit == KATANA_VALUE_NUMBER && idx == 0) {
            width = value->fValue;
            foundWidth = YES;
        } else if (foundStyle && LYKValueIsApplicableToColor(value)) {
            color = LYKCSSColorWithValue(value);
            foundColor = YES;
        } else if (!foundStyle && value->unit == KATANA_VALUE_IDENT) {
            const char *style = value->string;
            
            if (strcmp(style, "none")) {
                borderStyle = LYKCSSBorderStyleNone;
            } else if (strcmp(style, "solid")) {
                borderStyle = LYKCSSBorderStyleSolid;
            } else {
                NSLog(@"Unsupported border style %s", style);
            }
        }
    }
    
    if (foundStyle && borderStyle == LYKCSSBorderStyleNone) {
        width = 0.0f;
    }
    
    CSSNode->style.border[CSS_TOP] = width;
    CSSNode->style.border[CSS_LEFT] = width;
    CSSNode->style.border[CSS_BOTTOM] = width;
    CSSNode->style.border[CSS_RIGHT] = width;
    
    aView.layer.borderWidth = width;
    aView.layer.borderColor = color.CGColor;
}

void LYKCSSApplyPaddingOrMargin(KatanaDeclaration *decl, float values[])
{
    switch (decl->values->length) {
        case 1:
            values[CSS_TOP] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_LEFT] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_BOTTOM] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_RIGHT] = ((KatanaValue *)decl->values->data[0])->fValue;
            break;
        
        case 2:
            values[CSS_TOP] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_LEFT] = ((KatanaValue *)decl->values->data[1])->fValue;
            values[CSS_BOTTOM] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_RIGHT] = ((KatanaValue *)decl->values->data[1])->fValue;
            break;
            
        case 3:
            values[CSS_TOP] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_LEFT] = ((KatanaValue *)decl->values->data[1])->fValue;
            values[CSS_BOTTOM] = ((KatanaValue *)decl->values->data[2])->fValue;
            values[CSS_RIGHT] = ((KatanaValue *)decl->values->data[1])->fValue;
            break;
            
        case 4:
            values[CSS_TOP] = ((KatanaValue *)decl->values->data[0])->fValue;
            values[CSS_LEFT] = ((KatanaValue *)decl->values->data[1])->fValue;
            values[CSS_BOTTOM] = ((KatanaValue *)decl->values->data[2])->fValue;
            values[CSS_RIGHT] = ((KatanaValue *)decl->values->data[3])->fValue;
            break;
    }
}

UIColor *LYKCSSColorWithValue(KatanaValue *value)
{
    UIColor *color;
    
    switch (value->unit) {
        case KATANA_VALUE_IDENT:
            color = [UIColor colorWithString:[NSString stringWithCString:value->string
                encoding:NSUTF8StringEncoding]];
            break;
        
        case KATANA_VALUE_PARSER_HEXCOLOR:
            color = [UIColor colorWithString:[@"#" stringByAppendingString:
                [NSString stringWithCString:value->string encoding:NSUTF8StringEncoding]]];
            break;
        
        case KATANA_VALUE_PARSER_FUNCTION:
            if (strcmp(value->function->name, "rgb(") == 0 ||
                strcmp(value->function->name, "rgba(") == 0) {
                CGFloat colorValues[4] = (CGFloat[4]){0.0f, 0.0f, 0.0f, 1.0f};
                CGFloat const kMaxLength = 4;
                CGFloat *currentValue = &colorValues[0];
                NSUInteger valueCount = 0;
                
                for (NSUInteger idx = 0;
                    idx < value->function->args->length && valueCount < kMaxLength; idx++) {
                    KatanaValue *arg = value->function->args->data[idx];
                    if (arg->unit == KATANA_VALUE_NUMBER) {
                        *currentValue = arg->fValue;
                        currentValue++;
                        valueCount++;
                    }
                }
                
                color = [UIColor colorWithRed:(colorValues[0] / 255.0f)
                    green:(colorValues[1] / 255.0f)
                    blue:(colorValues[2] / 255.0f)
                    alpha:colorValues[3]];
                break;
            }
        
        default:
            NSLog(@"Unsupported unit for color");
            break;
    }
    
    return color;
}

BOOL LYKValueIsApplicableToColor(KatanaValue *value)
{
    switch (value->unit) {
        case KATANA_VALUE_IDENT:
        case KATANA_VALUE_PARSER_HEXCOLOR:
        case KATANA_VALUE_PARSER_FUNCTION:
            return YES;
        
        default:
            return NO;
    }
}
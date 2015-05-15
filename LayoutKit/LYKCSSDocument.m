//
//  LYKCSSDocument.m
//  LayoutKitCSSParser
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKCSSDocument.h"

#import "katana.h"
#import "UIView+LayoutKit.h"
#import "LYKStyle_Internal.h"
#import "ColorUtils.h"
#import "LYKCSSUtils.h"

static void LYKEnumerateKatanaArrayWithBlock(KatanaArray *arr,
    void (^block)(void *obj, NSUInteger idx, BOOL *stop)) {
    BOOL stop = NO;
    for (NSUInteger idx = 0; idx < arr->length && !stop; idx++) {
        block(arr->data[idx], idx, &stop);
    }
};

@implementation LYKCSSDocument
{
    NSString *_content;
    FILE *_fileHandle;
    
    KatanaOutput *_parsedStyleSheet;
}

#pragma mark - Initialization & Deallocation

- (instancetype)initWithContentsOfFile:(NSString *)path error:(NSError **)error
{
    if ((self = [super init])) {
        _parsedStyleSheet = NULL;
        
        _fileHandle = fopen([path cStringUsingEncoding:NSUTF8StringEncoding], "r");
        if (!_fileHandle) {
            NSLog(@"No file at path %@", path);
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    if (_parsedStyleSheet != NULL) {
        katana_destroy_output(_parsedStyleSheet);
    }
}



#pragma mark - Public Methods

- (BOOL)parse:(NSError **)error
{
    _parsedStyleSheet = katana_parse_in(_fileHandle);
    katana_dump_output(_parsedStyleSheet);
    return YES;
}

- (void)applyStylesToView:(UIView *)aView
{
    LYKEnumerateKatanaArrayWithBlock(&_parsedStyleSheet->stylesheet->rules,
    ^(void *obj, NSUInteger idx, BOOL *stop) {
        if (((KatanaRule *)obj)->type != KatanaRuleStyle) {
            return;
        }
        [self applyRule:(KatanaStyleRule *)obj toView:aView];
    });
}



#pragma mark - Private Methods

- (void)applyRule:(KatanaStyleRule *)rule toView:(UIView *)aView
{
    BOOL (^matchSelector)(KatanaArray *, UIView *, NSUInteger);
    __block BOOL (__weak ^weakMatchSelector)(KatanaArray *, UIView *, NSUInteger);
    
    matchSelector = ^BOOL (KatanaArray *selArray, UIView *view, NSUInteger idx) {
        KatanaSelector *sel = selArray->data[idx];
        
        if (strcmp(sel->tag->local,
            [view.lyk_name cStringUsingEncoding:NSUTF8StringEncoding]) != 0) {
            return NO;
        }
        
        if (idx == 0) {
            return YES;
        }
        
        UIView *superview = view.superview;
        if (superview == nil) {
            return NO;
        }
        
        return weakMatchSelector(selArray, superview, idx - 1);
    };
    
    if (!matchSelector(rule->selectors, aView, rule->selectors->length - 1)) {
        return;
    }
    
    LYKStyle *style = aView.lyk_style;
    css_node_t *CSSNode = style.CSSNode;
    
    LYKEnumerateKatanaArrayWithBlock(rule->declarations, ^(void *obj, NSUInteger idx, BOOL *stop) {
        KatanaDeclaration *decl = (KatanaDeclaration *)obj;
        KatanaValue *firstValue = decl->values->data[0];
        
        const char *p = decl->property;
        
        if (strcmp(p, "display") == 0) {
            if (strcmp(firstValue->string, "flex")) {
                style.display = LYKCSSDisplayFlex;
            } else if (strcmp(firstValue->string, "inline")) {
                style.display = LYKCSSDisplayInline;
            }
        } else if (strcmp(p, "background-color") == 0) {
            aView.backgroundColor = LYKCSSColorWithValue(firstValue);
        } else if (strcmp(p, "width") == 0) {
            CSSNode->style.dimensions[CSS_WIDTH] = firstValue->fValue;
        } else if (strcmp(p, "height") == 0) {
            CSSNode->style.dimensions[CSS_HEIGHT] = firstValue->fValue;
        } else if (strcmp(p, "top") == 0) {
            CSSNode->style.position[CSS_TOP] = firstValue->fValue;
        } else if (strcmp(p, "left") == 0) {
            CSSNode->style.position[CSS_LEFT] = firstValue->fValue;
        } else if (strcmp(p, "padding") == 0) {
            LYKCSSApplyPaddingOrMargin(decl, CSSNode->style.padding);
        } else if (strcmp(p, "padding-top") == 0) {
            CSSNode->style.padding[CSS_TOP] = firstValue->fValue;
        } else if (strcmp(p, "padding-left") == 0) {
            CSSNode->style.padding[CSS_LEFT] = firstValue->fValue;
        } else if (strcmp(p, "padding-bottom") == 0) {
            CSSNode->style.padding[CSS_BOTTOM] = firstValue->fValue;
        } else if (strcmp(p, "padding-right") == 0) {
            CSSNode->style.padding[CSS_RIGHT] = firstValue->fValue;
        } else if (strcmp(p, "margin") == 0) {
            LYKCSSApplyPaddingOrMargin(decl, CSSNode->style.margin);
        } else if (strcmp(p, "margin-top") == 0) {
            CSSNode->style.margin[CSS_TOP] = firstValue->fValue;
        } else if (strcmp(p, "margin-left") == 0) {
            CSSNode->style.margin[CSS_LEFT] = firstValue->fValue;
        } else if (strcmp(p, "margin-bottom") == 0) {
            CSSNode->style.margin[CSS_BOTTOM] = firstValue->fValue;
        } else if (strcmp(p, "margin-right") == 0) {
            CSSNode->style.margin[CSS_RIGHT] = firstValue->fValue;
        } else if (strcmp(p, "flex-direction") == 0) {
            if (strcmp(firstValue->string, "column") == 0) {
                CSSNode->style.flex_direction = CSS_FLEX_DIRECTION_COLUMN;
            } else if (strcmp(firstValue->string, "row") == 0) {
                CSSNode->style.flex_direction = CSS_FLEX_DIRECTION_ROW;
            } else if (strcmp(firstValue->string, "column-reverse") == 0) {
                CSSNode->style.flex_direction = CSS_FLEX_DIRECTION_COLUMN_REVERSE;
            } else if (strcmp(firstValue->string, "row-reverse") == 0) {
                CSSNode->style.flex_direction = CSS_FLEX_DIRECTION_ROW_REVERSE;
            }
        } else if (strcmp(p, "justify-content") == 0) {
            if (strcmp(firstValue->string, "flex-start") == 0) {
                CSSNode->style.justify_content = CSS_JUSTIFY_FLEX_START;
            } else if (strcmp(firstValue->string, "flex-end") == 0) {
                CSSNode->style.justify_content = CSS_JUSTIFY_FLEX_END;
            } else if (strcmp(firstValue->string, "center") == 0) {
                CSSNode->style.justify_content = CSS_JUSTIFY_CENTER;
            } else if (strcmp(firstValue->string, "space-between") == 0) {
                CSSNode->style.justify_content = CSS_JUSTIFY_SPACE_BETWEEN;
            } else if (strcmp(firstValue->string, "space-around") == 0) {
                CSSNode->style.justify_content = CSS_JUSTIFY_SPACE_AROUND;
            }
        } else if (strcmp(p, "align-self") == 0) {
            if (strcmp(firstValue->string, "auto") == 0) {
            } else if (strcmp(firstValue->string, "flex-start") == 0) {
                CSSNode->style.align_self = CSS_ALIGN_FLEX_START;
            } else if (strcmp(firstValue->string, "flex-end") == 0) {
                CSSNode->style.align_self = CSS_ALIGN_FLEX_END;
            } else if (strcmp(firstValue->string, "center") == 0) {
                CSSNode->style.align_self = CSS_ALIGN_CENTER;
            } else if (strcmp(firstValue->string, "baseline") == 0) {
                
            } else if (strcmp(firstValue->string, "stretch") == 0) {
                CSSNode->style.align_self = CSS_ALIGN_STRETCH;
            }
        } else if (strcmp(p, "border") == 0) {
            LYKCSSApplyBorder(decl, CSSNode, aView);
        } else {
            NSLog(@"Unsupported property %s", p);
        }
    });
}
@end
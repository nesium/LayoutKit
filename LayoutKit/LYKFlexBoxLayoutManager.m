//
//  LYKFlexBoxLayoutManager.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKFlexBoxLayoutManager.h"

#import "LYKStyle_Internal.h"
#import "UIView+LayoutKit.h"

static css_node_t *getChild(void *context, int i);
static bool isDirty(void *context);
static css_dim_t measure(void *context, float width);

static css_node_t *getChild(void *context, int i)
{
    CALayer *layer = (__bridge CALayer *)context;
    CALayer *sublayer = layer.sublayers[i];
    UIView *view = sublayer.delegate;
    view.lyk_style.CSSNode->context = (__bridge void *)sublayer;
    view.lyk_style.CSSNode->is_dirty = isDirty;
    
    if (view.lyk_style.display == LYKCSSDisplayInline) {
        view.lyk_style.CSSNode->measure = measure;
    }
    return view.lyk_style.CSSNode;
}

static bool isDirty(void *context)
{
    return true;
}

static css_dim_t measure(void *context, float width)
{
    CALayer *layer = (__bridge CALayer *)context;
    UIView *view = layer.delegate;
    
    css_dim_t dim;
    dim.dimensions[CSS_WIDTH] = 100.0f;
    CGSize requiredSize = [view sizeThatFits:(CGSize){200.0f, CGFLOAT_MAX}];
    dim.dimensions[CSS_HEIGHT] = requiredSize.height;
    return dim;
}

@implementation LYKFlexBoxLayoutManager

#pragma mark - LYKLayoutManager Methods

- (void)invalidateLayoutOfLayer:(CALayer *)layer
{
    UIView *view = layer.delegate;
    view.lyk_style.CSSNode->context = (__bridge void *)layer;
    view.lyk_style.CSSNode->get_child = getChild;
    view.lyk_style.CSSNode->is_dirty = isDirty;
    
    if (view.lyk_style.display == LYKCSSDisplayInline) {
        view.lyk_style.CSSNode->measure = measure;
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    UIView *view = layer.delegate;
    view.lyk_style.CSSNode->children_count = (int)layer.sublayers.count;
    
    __block void (__weak ^weakPrepareLayerForLayout)(CALayer *);
    
    void (^prepareLayerForLayout)(CALayer *) = ^(CALayer *theLayer) {
        UIView *theView = theLayer.delegate;
        theView.lyk_style.CSSNode->layout.position[CSS_TOP] = 0.0f;
        theView.lyk_style.CSSNode->layout.position[CSS_LEFT] = 0.0f;
        theView.lyk_style.CSSNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        theView.lyk_style.CSSNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
        
        for (CALayer *sublayer in theLayer.sublayers) {
            weakPrepareLayerForLayout(sublayer);
        }
    };
    
    weakPrepareLayerForLayout = prepareLayerForLayout;
    
    __block void (__weak ^weakApplyLayoutToLayer)(CALayer *);
    
    void (^applyLayoutToLayer)(CALayer *) = ^(CALayer *theLayer) {
        UIView *theView = theLayer.delegate;
        theView.frame = (CGRect){
        	theView.lyk_style.position.left,
            theView.lyk_style.position.top,
            theView.lyk_style.size
        };
        
        for (CALayer *sublayer in theLayer.sublayers) {
            weakApplyLayoutToLayer(sublayer);
        }
    };
    
    weakApplyLayoutToLayer = applyLayoutToLayer;
    
    prepareLayerForLayout(layer);
    layoutNode(view.lyk_style.CSSNode, view.lyk_style.CSSNode->style.dimensions[CSS_WIDTH]);
    applyLayoutToLayer(layer);
}
@end
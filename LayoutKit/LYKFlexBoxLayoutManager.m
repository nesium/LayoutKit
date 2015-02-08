//
//  LYKFlexBoxLayoutManager.m
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKFlexBoxLayoutManager.h"

#import "LYKStyle_Internal.h"
#import "CALayer+LayoutKit.h"
#import "CALayer_LYKInternal.h"

@implementation LYKFlexBoxLayoutManager

#pragma mark - LYKLayoutManager Methods

- (void)invalidateLayoutOfLayer:(CALayer *)layer {}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    __block void (__weak ^weakPrepareLayerForLayout)(CALayer *);
    __weak __typeof(self)weakSelf = self;
    __weak CALayer *weakRootLayer = layer;
    
    void (^prepareLayerForLayout)(CALayer *) = ^(CALayer *theLayer) {
        __weak CALayer *weakLayer = theLayer;
        
        [theLayer.lyk_style setNumberOfChildren:theLayer.sublayers.count];
        
        [theLayer.lyk_style prepareForLayout];
        
        [theLayer.lyk_style setMeasureBlock:^CGSize(CGFloat width) {
            return [weakSelf preferredSizeOfLayer:weakLayer width:width];
        }];
        
        [theLayer.lyk_style setGetChildBlock:^LYKStyle *(NSUInteger idx) {
            return [weakSelf styleForSublayerAtIndex:idx parentLayer:weakLayer];
        }];
        
        [theLayer.lyk_style setChangeHandler:^{
            [weakSelf handleChangeInLayer:weakLayer rootLayer:weakRootLayer];
        }];
        
        for (CALayer *sublayer in theLayer.sublayers) {
            weakPrepareLayerForLayout(sublayer);
        }
    };
    
    weakPrepareLayerForLayout = prepareLayerForLayout;
    
    __block void (__weak ^weakApplyLayoutToLayer)(CALayer *);
    
    void (^applyLayoutToLayer)(CALayer *) = ^(CALayer *theLayer) {
        theLayer.frame = theLayer.lyk_style.layoutedFrame;
        
        for (CALayer *sublayer in theLayer.sublayers) {
            weakApplyLayoutToLayer(sublayer);
        }
    };
    
    weakApplyLayoutToLayer = applyLayoutToLayer;
    
    prepareLayerForLayout(layer);
    [layer.lyk_style performLayout];
    applyLayoutToLayer(layer);
}



#pragma mark - Private Methods

- (CGSize)preferredSizeOfLayer:(CALayer *)layer width:(CGFloat)width
{
    UIView *view = layer.delegate;
    return [view sizeThatFits:(CGSize){width, CGFLOAT_MAX}];
}

- (LYKStyle *)styleForSublayerAtIndex:(NSUInteger)idx parentLayer:(CALayer *)parentLayer
{
    CALayer *sublayer = parentLayer.sublayers[idx];
    return sublayer.lyk_style;
}

- (void)handleChangeInLayer:(CALayer *)childLayer rootLayer:(CALayer *)rootLayer
{
    // TODO: Improve invalidation
    [rootLayer setNeedsLayout];
}
@end
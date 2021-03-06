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
        if (!theLayer.lyk_hasStyle) {
            return;
        }
        
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
        
        NSUInteger childrenCount = 0;
        for (CALayer *sublayer in theLayer.sublayers) {
            if (sublayer.lyk_hasStyle) {
                weakPrepareLayerForLayout(sublayer);
                childrenCount++;
            }
        }
        
        [theLayer.lyk_style setNumberOfChildren:childrenCount];
    };
    
    weakPrepareLayerForLayout = prepareLayerForLayout;
    
    __block void (__weak ^weakApplyLayoutToLayer)(CALayer *);
    
    void (^applyLayoutToLayer)(CALayer *) = ^(CALayer *theLayer) {
        for (CALayer *sublayer in theLayer.sublayers) {
            if (!sublayer.lyk_hasStyle) {
                continue;
            }
            
            UIView *view = sublayer.delegate;
            sublayer.frame = [view alignmentRectForFrame:sublayer.lyk_style.layoutedFrame];
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
    CGSize size = [view sizeThatFits:(CGSize){width, CGFLOAT_MAX}];
    return [view frameForAlignmentRect:(CGRect){0.0f, 0.0f, size}].size;
}

- (LYKStyle *)styleForSublayerAtIndex:(NSUInteger)idx parentLayer:(CALayer *)parentLayer
{
    // Needs optimization
    NSInteger currentIdx = -1;
    for (CALayer *sublayer in parentLayer.sublayers) {
        LYKStyle *style = sublayer.lyk_styleIfExists;
        
        if (style != nil) {
            currentIdx++;
        }
        
        if (currentIdx == idx) {
            return style;
        }
    }
    
    return nil;
}

- (void)handleChangeInLayer:(CALayer *)childLayer rootLayer:(CALayer *)rootLayer
{
    // TODO: Improve invalidation
    [rootLayer setNeedsLayout];
}
@end
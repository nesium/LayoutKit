//
//  ViewController.m
//  LayoutKitExample
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "ViewController.h"

@import LayoutKit;

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - Initialization & Deallocation

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
        self.lyk_CSSFilePath = @"styles.css";
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
//    [self test2];
}

- (void)test1
{
    UIView *containerView = [UIView new];
    containerView.lyk_name = @"container";
    
    containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:containerView];
    
    for (NSUInteger idx = 0; idx < 3; idx++) {
        UIView *subview = [UIView new];
        subview.lyk_name = @"item";
        [containerView addSubview:subview];
    }
    
//    UIView *parent = containerView.subviews[1];
//    parent.lyk_direction = LYKCSSFlexDirectionColumn;
//    parent.lyk_padding = (LYKCSSEdgeInsets){3.0f, 3.0f, 1.0f, 3.0f};
//    parent.lyk_selfAlignment = LYKCSSAlignStart;
//    
//    for (NSUInteger idx = 0; idx < 5; idx++) {
//        UIView *subview = [UIView new];
//        subview.backgroundColor = [UIColor greenColor];
//        subview.lyk_size = (CGSize){NAN, 10.0f};
//        subview.lyk_margin = (LYKCSSEdgeInsets){0.0f, 0.0f, 2.0f, 0.0f};
//        subview.lyk_selfAlignment = LYKCSSAlignStretch;
//        [parent addSubview:subview];
//    }
//    
//    UILabel *label = [UILabel new];
//    label.text = @"Hello World";
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.backgroundColor = [UIColor yellowColor];
//    label.lyk_selfAlignment = LYKCSSAlignCenter;
//    label.lyk_display = LYKCSSDisplayInline;
//    label.lyk_size = (CGSize){50.0f, NAN};
//    [containerView addSubview:label];
}

- (void)test2
{
//    UIView *containerView = [UIView new];
//    containerView.backgroundColor = [UIColor lightGrayColor];
//    containerView.layer.lyk_layoutManager = [LYKFlexBoxLayoutManager new];
//    containerView.lyk_direction = LYKCSSFlexDirectionColumn;
//    containerView.lyk_display = LYKCSSDisplayInline;
//    containerView.lyk_size = (CGSize){NAN, NAN};
//    containerView.lyk_position = (LYKCSSEdgeInsets){180.0f, 10.0f, 0.0f, 0.0f};
//    containerView.lyk_padding = (LYKCSSEdgeInsets){5.0f, 10.0f, 5.0f, 10.0f};
//    containerView.lyk_contentJustification = LYKCSSJustificationStart;
//    [self.view addSubview:containerView];
//    
//    for (NSUInteger idx = 0; idx < 3; idx++) {
//        UIView *subview = [UIView new];
//        subview.backgroundColor = [UIColor redColor];
//        subview.lyk_size = (CGSize){60.0f, 30.0f};
//        subview.lyk_margin = (LYKCSSEdgeInsets){0.0f, 0.0f, 10.0f, 0.0f};
//        [containerView addSubview:subview];
//    }
//    
//    UILabel *label = [UILabel new];
//    label.text = @"Hello World";
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.backgroundColor = [UIColor yellowColor];
//    label.lyk_selfAlignment = LYKCSSAlignCenter;
//    label.lyk_display = LYKCSSDisplayInline;
//    label.lyk_size = (CGSize){50.0f, NAN};
//    [containerView addSubview:label];
}
@end
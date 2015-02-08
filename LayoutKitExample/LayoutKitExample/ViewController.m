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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor lightGrayColor];
    containerView.layer.lyk_layoutManager = [LYKFlexBoxLayoutManager new];
    containerView.lyk_style.size = (CGSize){300.0f, 100.0f};
    containerView.lyk_style.position = (LYKCSSEdgeInsets){50.0f, 10.0f, 0.0f, 0.0f};
    containerView.lyk_style.padding = (LYKCSSEdgeInsets){5.0f, 10.0f, 5.0f, 10.0f};
    containerView.lyk_style.contentJustification = LYKCSSJustificationSpaceAround;
    [self.view addSubview:containerView];
    
    for (NSUInteger idx = 0; idx < 3; idx++) {
        UIView *subview = [UIView new];
        subview.backgroundColor = [UIColor redColor];
        subview.lyk_style.size = (CGSize){60.0f, NAN};
        subview.lyk_style.selfAlignment = LYKCSSAlignStretch;
        [containerView addSubview:subview];
    }
    
    UILabel *label = [UILabel new];
    label.text = @"Hello World";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColor yellowColor];
    label.lyk_style.selfAlignment = LYKCSSAlignCenter;
    label.lyk_style.display = LYKCSSDisplayInline;
    label.lyk_style.size = (CGSize){50.0f, NAN};
    [containerView addSubview:label];
}
@end
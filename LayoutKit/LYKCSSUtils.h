//
//  LYKCSSUtils.h
//  LayoutKit
//
//  Created by Marc Bauer on 15.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

#import "katana.h"
#import "Layout.h"

void LYKCSSApplyBorder(KatanaDeclaration *decl, css_node_t *CSSNode, UIView *aView);
void LYKCSSApplyPaddingOrMargin(KatanaDeclaration *decl, float values[]);
UIColor *LYKCSSColorWithValue(KatanaValue *value);

BOOL LYKValueIsApplicableToColor(KatanaValue *value);
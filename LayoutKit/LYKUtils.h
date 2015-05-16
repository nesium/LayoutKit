//
//  LYKUtils.h
//  LayoutKit
//
//  Created by Marc Bauer on 07.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import UIKit;

void LYKMethodSwizzle(Class c, SEL origSEL, SEL overrideSEL);

CGFloat lykFloorf(CGFloat value);
CGFloat lykCeilf(CGFloat value);
CGFloat lykRoundf(CGFloat value);
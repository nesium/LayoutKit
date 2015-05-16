//
//  CSSConsumer.h
//  LayoutKit
//
//  Created by Marc Bauer on 16.05.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import Foundation;

#import "katana.h"

@protocol CSSConsumer <NSObject>
- (BOOL)applyCSSDeclaration:(KatanaDeclaration *)decl;
@end
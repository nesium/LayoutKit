//
//  LYKCSSParserDelegate.h
//  LayoutKitCSSParser
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import Foundation;

@class PKParser;
@class PKAssembly;

@protocol LYKCSSParserDelegate <NSObject>
- (void)parserWillMatchDeclaration:(PKParser *)parser;
- (void)parser:(PKParser *)parser didMatchDeclaration:(PKAssembly *)assembly;
- (void)parserWillMatchRule:(PKParser *)parser;
- (void)parser:(PKParser *)parser didMatchRule:(PKAssembly *)assembly;
@end
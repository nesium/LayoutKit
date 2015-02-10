//
//  LYKCSSDocument.h
//  LayoutKitCSSParser
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

@import Foundation;

@interface LYKCSSDocument : NSObject
- (instancetype)initWithContentsOfFile:(NSString *)path error:(NSError **)error;
- (instancetype)initWithString:(NSString *)aString;

- (BOOL)parse:(NSError **)error;
@end
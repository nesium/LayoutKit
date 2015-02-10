//
//  LYKCSSDocument.m
//  LayoutKitCSSParser
//
//  Created by Marc Bauer on 08.02.15.
//  Copyright (c) 2015 nesiumdotcom. All rights reserved.
//

#import "LYKCSSDocument.h"

#import "LYKCSSParser.h"
#import "LYKCSSParserDelegate.h"

@interface LYKCSSDocument () <LYKCSSParserDelegate>
@end

@implementation LYKCSSDocument
{
    LYKCSSParser *_parser;
    NSString *_content;
}

#pragma mark - Initialization & Deallocation

- (instancetype)initWithContentsOfFile:(NSString *)path error:(NSError **)error
{
    NSString *str = [[NSString alloc] initWithContentsOfFile:path
        encoding:NSUTF8StringEncoding error:error];
    if (str == nil) {
        return nil;
    }
    return [self initWithString:str];
}

- (instancetype)initWithString:(NSString *)aString
{
    if ((self = [super init])) {
        _content = [aString copy];
        _parser = [[LYKCSSParser alloc] initWithDelegate:self];
    }
    return self;
}



#pragma mark - Public Methods

- (BOOL)parse:(NSError **)error
{
    if (![_parser parseString:_content error:error]) {
        NSLog(@"%@", *error);
       return NO;
    }
    return YES;
}



#pragma mark - LYKCSSParserDelegate Methods

- (void)parserWillMatchDeclaration:(PKParser *)parser
{
}

- (void)parser:(PKParser *)parser didMatchDeclaration:(PKAssembly *)assembly
{
    NSLog(@"DECL");
}

- (void)parserWillMatchRule:(PKParser *)parser
{
}

- (void)parser:(PKParser *)parser didMatchRule:(PKAssembly *)assembly
{
    NSLog(@"RULE");
}
@end
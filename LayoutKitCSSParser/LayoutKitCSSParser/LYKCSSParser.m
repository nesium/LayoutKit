#import "LYKCSSParser.h"
#import <PEGKit/PEGKit.h>
    
	#import "LYKCSSParserDelegate.h"

	@interface PKToken ()
	@property (nonatomic, readwrite) NSUInteger lineNumber;
	@end


@interface LYKCSSParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *declaration_memo;
@property (nonatomic, retain) NSMutableDictionary *rule_memo;
@property (nonatomic, retain) NSMutableDictionary *selector_memo;
@property (nonatomic, retain) NSMutableDictionary *value_memo;
@end

@implementation LYKCSSParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@":"] = @(LYKCSS_TOKEN_KIND_COLON);
        self.tokenKindTab[@";"] = @(LYKCSS_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"}"] = @(LYKCSS_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"{"] = @(LYKCSS_TOKEN_KIND_OPEN_CURLY);

        self.tokenKindNameTab[LYKCSS_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[LYKCSS_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[LYKCSS_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[LYKCSS_TOKEN_KIND_OPEN_CURLY] = @"{";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.declaration_memo = [NSMutableDictionary dictionary];
        self.rule_memo = [NSMutableDictionary dictionary];
        self.selector_memo = [NSMutableDictionary dictionary];
        self.value_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_declaration_memo removeAllObjects];
    [_rule_memo removeAllObjects];
    [_selector_memo removeAllObjects];
    [_value_memo removeAllObjects];
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)__expr {
    
    [self execute:^{
    
	PKTokenizer *t = self.tokenizer;
	t.numberState.allowsFloatingPoint = YES;
	t.numberState.allowsScientificNotation = NO;

    }];
    while ([self speculate:^{ [self declaration_]; }]) {
        [self declaration_]; 
    }

}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__declaration {
    
    [self execute:^{
    
	[self fireDelegateSelector:@selector(parserWillMatchDeclaration:)];

    }];
    [self selector_]; 
    [self match:LYKCSS_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    while ([self speculate:^{ [self rule_]; }]) {
        [self rule_]; 
    }
    [self match:LYKCSS_TOKEN_KIND_CLOSE_CURLY discard:NO]; 
    [self execute:^{
    
	[self fireDelegateSelector:@selector(parser:didMatchDeclaration:)];

    }];

}

- (void)declaration_ {
    [self parseRule:@selector(__declaration) withMemo:_declaration_memo];
}

- (void)__rule {
    
    [self execute:^{
    
	[self fireDelegateSelector:@selector(parserWillMatchRule:)];

    }];
    [self selector_]; 
    [self match:LYKCSS_TOKEN_KIND_COLON discard:YES]; 
    [self value_]; 
    [self match:LYKCSS_TOKEN_KIND_SEMI_COLON discard:YES]; 
    [self execute:^{
    
	[self fireDelegateSelector:@selector(parser:didMatchRule:)];

    }];

}

- (void)rule_ {
    [self parseRule:@selector(__rule) withMemo:_rule_memo];
}

- (void)__selector {
    
    [self matchWord:NO]; 

}

- (void)selector_ {
    [self parseRule:@selector(__selector) withMemo:_selector_memo];
}

- (void)__value {
    
    [self matchWord:NO]; 

}

- (void)value_ {
    [self parseRule:@selector(__value) withMemo:_value_memo];
}

@end
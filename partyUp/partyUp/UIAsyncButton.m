//
//  UIAsyncButton.m
//  Pods
//
//  Created by Bruno Neves on 5/7/14.
//
//

#import "UIAsyncButton.h"

@implementation UIAsyncButton{
    NSString* label;
    UIActivityIndicatorView* loader;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(cliqued:) forControlEvents:UIControlEventTouchUpInside];
        [self initButton];

    }
    return self;
}

- (id) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self addTarget:self action:@selector(cliqued:) forControlEvents:UIControlEventTouchUpInside];
        [self initButton];
    }
    return self;
}

-(void) initButton{
    label = self.titleLabel.text;
}

-(void) cliqued:(id)sender{
    [self disableButton];
    [self createLoader];
}

-(void) disableButton{
    self.enabled = NO;
    [self setTitle:@"" forState:UIControlStateNormal];
}

-(void) reset{
    self.enabled = YES;
    [self setTitle:label forState:UIControlStateNormal];
    [loader stopAnimating];
}

-(void) createLoader{
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIGraphicsEndImageContext();
    loader.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [loader startAnimating];
    [self addSubview:loader];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  AboutViewController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 7/9/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURL *aboutFile = [[NSBundle mainBundle] URLForResource:@"about" withExtension:@"html"];
    NSString *aboutContent = [NSString stringWithContentsOfURL:aboutFile encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:aboutContent baseURL:baseURL];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebViewDelegate

// open URLs externally:
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
@end

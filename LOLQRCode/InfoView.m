//
//  InfoView.m
//  LOLQRCode
//
//  Created by Jerry Zhu on 8/8/12.
//  Copyright (c) 2012 Jerry Zhu. All rights reserved.
//

#import "InfoView.h"

@interface InfoView ()

@end

@implementation InfoView
@synthesize infoWebView = _infoWebView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"info"] ofType:@"html"];
//    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
//    NSString *htmlString = [[NSString alloc] initWithData:
//                            [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    [self.infoWebView loadHTMLString:htmlString baseURL:nil];
    [self.infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"html"]isDirectory:NO]]];

}

- (void)viewDidUnload
{
    [self setInfoWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

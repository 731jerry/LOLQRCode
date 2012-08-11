//
//  InfoView.h
//  LOLQRCode
//
//  Created by Jerry Zhu on 8/8/12.
//  Copyright (c) 2012 Jerry Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIViewController 

@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

- (IBAction)returnAndRedrawQR:(id)sender;

@end

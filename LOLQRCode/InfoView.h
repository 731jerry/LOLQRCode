//
//  InfoView.h
//  LOLQRCode
//
//  Created by Jerry Zhu on 8/8/12.
//  Copyright (c) 2012 Jerry Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoView;
@protocol InfoViewDelegate <NSObject>
 - (void)redrawQR:(InfoView *)sender;
@end

@interface InfoView : UIViewController 

@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

@property (nonatomic, assign) IBOutlet id <InfoViewDelegate> delegate;
@end

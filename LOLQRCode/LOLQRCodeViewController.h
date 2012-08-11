//
//  LOLQRCodeViewController.h
//  LOLQRCode
//
//  Created by Jerry Zhu on 8/8/12.
//  Copyright (c) 2012 Jerry Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZbarSDK.h"
#import "GradientButton.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DejalActivityView.h"

@interface LOLQRCodeViewController : UIViewController < ZBarReaderDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    GradientButton *generateQRCodeButton;
    GradientButton *saveImageButton;
    GradientButton *scanQRCodeButton;
    GradientButton *mmsImageButton;
    GradientButton *mailImageButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UILabel *warnningLabel;

@property (nonatomic, retain) IBOutlet GradientButton *generateQRCodeButton;
@property (nonatomic, retain) IBOutlet GradientButton *saveImageButton;
@property (nonatomic, retain) IBOutlet GradientButton *scanQRCodeButton;
@property (nonatomic, retain) IBOutlet GradientButton *mmsImageButton;
@property (nonatomic, retain) IBOutlet GradientButton *mailImageButton;
- (IBAction)generateQRCode:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)scanQRCode:(id)sender;
- (IBAction)ResponderTextField:(id)sender;
- (IBAction)sendImageViaMessage:(id)sender;

- (IBAction)sendImageViaMail:(id)sender;
@end

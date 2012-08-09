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

@interface LOLQRCodeViewController : UIViewController < ZBarReaderDelegate,UIAlertViewDelegate >{
    GradientButton *generateQRCodeButton;
    GradientButton *saveImageButton;
    GradientButton *scanQRCodeButton;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UILabel *warnningLabel;

@property (nonatomic, retain) IBOutlet GradientButton *generateQRCodeButton;
@property (nonatomic, retain) IBOutlet GradientButton *saveImageButton;
@property (nonatomic, retain) IBOutlet GradientButton *scanQRCodeButton;

- (IBAction)generateQRCode:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)scanQRCode:(id)sender;
- (IBAction)ResponderTextField:(id)sender;

@end

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
#import "BlockAlertView.h"

@interface LOLQRCodeViewController : UIViewController < ZBarReaderDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UITextFieldDelegate>{
    GradientButton *generateQRCodeButton; // “生成” 按钮
    GradientButton *saveImageButton; // 保存图片 按钮
    GradientButton *scanQRCodeButton; // 扫描按钮
    GradientButton *mmsImageButton; // 发送短信按钮
    GradientButton *mailImageButton; // 发送邮件按钮
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView; // 二维码图片
@property (weak, nonatomic) IBOutlet UITextField *inputText; // 输入要转化成二维码的文字
@property (weak, nonatomic) IBOutlet UILabel *warnningLabel; // 显示被扫描出来的二维码

@property (nonatomic, retain) IBOutlet GradientButton *generateQRCodeButton; 
@property (nonatomic, retain) IBOutlet GradientButton *saveImageButton;
@property (nonatomic, retain) IBOutlet GradientButton *scanQRCodeButton;
@property (nonatomic, retain) IBOutlet GradientButton *mmsImageButton;
@property (nonatomic, retain) IBOutlet GradientButton *mailImageButton;

- (IBAction)generateQRCode:(id)sender; // 生成二维码
- (IBAction)saveImage:(id)sender; // 保存图片
- (IBAction)scanQRCode:(id)sender; // 扫描二维码
- (IBAction)ResponderTextField:(id)sender; // 收回虚拟键盘
- (IBAction)sendImageViaMessage:(id)sender; // 通过短信发送生成的二维码图片
- (IBAction)sendImageViaMail:(id)sender; // 通过邮件发送二维码吗图片

- (IBAction)dismissKeyboard:(id)sender; // 点击其他部位 收回虚拟键盘 与dismissKeyboardButton关联
- (IBAction)test:(id)sender;

@end

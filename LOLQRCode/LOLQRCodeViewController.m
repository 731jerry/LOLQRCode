//
//  LOLQRCodeViewController.m
//  LOLQRCode
//
//  Created by Jerry Zhu on 8/8/12.
//  Copyright (c) 2012 Jerry Zhu. All rights reserved.
//

#import "LOLQRCodeViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface LOLQRCodeViewController ()
@property (nonatomic) BOOL isImageSaved;
@end

@implementation LOLQRCodeViewController
@synthesize imageView = _imageView;
@synthesize inputText = _inputText;
@synthesize warnningLabel = _warnningLabel;
 
@synthesize generateQRCodeButton = _generateQRCodeButton;
@synthesize saveImageButton = _saveImageButton;
@synthesize scanQRCodeButton = _scanQRCodeButton;
@synthesize mmsImageButton = _mmsImageButton;
@synthesize mailImageButton = _mailImageButton;

@synthesize isImageSaved = _isImageSaved;

#pragma mark -
#pragma mark initialize
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.buttonEquals = [[[CustomButton alloc] initWithTextAndHSB:@"" target:self selector:@selector(buttonTapped:) hue:0.075f saturation:0.9f brightness:0.96f] autorelease];
    [self.generateQRCodeButton useBlackStyle];
    [self.saveImageButton useBlackStyle];
    [self.scanQRCodeButton useGreenConfirmStyle];
    [self.mmsImageButton useSimpleOrangeStyle];
    [self.mailImageButton useSimpleOrangeStyle];
    
    self.isImageSaved = NO;
    
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setInputText:nil];
    [self setWarnningLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark -
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    self.imageView.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    self.warnningLabel.text =  symbol.data ;
    
    if ([predicate evaluateWithObject:self.warnningLabel.text]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"It will use the browser to this URL。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
        //[alert release];
        
        
        
    }
    else if([ssidPre evaluateWithObject:self.warnningLabel.text]){
        
        NSArray *arr = [self.warnningLabel.text componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        self.warnningLabel.text=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:self.warnningLabel.text
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=2;
        [alert show];
        //[alert release];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"图片已经保存到您的相册里面...", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好的呢", nil)
                                              otherButtonTitles:nil];
        [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.0];
        [alert show];
    }
    //show_alert_view(@"This picture has been saved to your photo album.", @"Picture Saved");
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"图片保存错误", nil)
                                                        message:NSLocalizedString(@"可能是二维码没有成功生成 也可能是其他原因", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好吧 再试一次", nil)
                                              otherButtonTitles:nil];
        [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.0];
        [alert show];
    }
    //show_alert_view(@"Please try it again later.", @"Saving Failed");
}

- (IBAction)generateQRCode:(id)sender {
    self.imageView.image = [QRCodeGenerator qrImageForString:self.inputText.text imageSize:self.imageView.bounds.size.width];
    if (self.warnningLabel.text != self.inputText.text) {
        self.isImageSaved = NO;
    }
    self.warnningLabel.text = self.inputText.text;
}

- (IBAction)scanQRCode:(id)sender {
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最后读取并显示了条形码的图片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
}

- (IBAction)ResponderTextField:(id)sender {
    [self.inputText resignFirstResponder];
}

- (IBAction)saveImage:(id)sender {
    if (!self.isImageSaved) {
        //[DejalKeyboardActivityView activityViewWithLabel:@"Loading..."];
        [self performSelector:@selector(displayActivityView) withObject:nil afterDelay:0.0];
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        self.isImageSaved = YES;
        //NSLog(@"save...");
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"图片已经被保存 不必再去保存 可以之前在相机胶卷里面查看", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好的呢", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark -
#pragma mark refresh view
// 显示刷新界面 
- (IBAction)displayActivityView{
    UIView *viewToUse = self.view;
    [DejalBezelActivityView activityViewForView:viewToUse];
    
}

// 移除刷新界面
- (void)removeActivityView{
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark -
#pragma mark send via mail

- (IBAction)sendImageViaMail:(id)sender {
    [self showMailPicker];
}

-(void)showMailPicker {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass !=nil) {
        if ([mailClass canSendMail]) {
            [self displayMailComposerSheet];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持邮件功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
    }else{
        
    }
    
}
-(void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate =self;
    [picker setSubject:@"二维码图片"];
    // Set up recipients
//    NSArray *toRecipients = [NSArray arrayWithObject:@"first@qq.com"];
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@qq.com",@"third@qq.com", nil];
//    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@qq.com"];
//    
//    [picker setToRecipients:toRecipients];
//    [picker setCcRecipients:ccRecipients];
//    [picker setBccRecipients:bccRecipients];
   
    if (self.imageView.image) {
        //发送图片附件
        NSData *imageData =  UIImagePNGRepresentation(self.imageView.image);
        [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"image"];
    
    
        //发送txt文本附件
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"txt"];
        //NSData *myData = [NSData dataWithContentsOfFile:path];
        //[picker addAttachmentData:myData mimeType:@"text/txt" fileName:@"MyText.txt"];
        //发送doc文本附件
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"doc"];
        //NSData *myData = [NSData dataWithContentsOfFile:path];
        //[picker addAttachmentData:myData mimeType:@"text/doc" fileName:@"MyText.doc"];
        //发送pdf文档附件
        /*
        NSString *path = [[NSBundlemainBundle] pathForResource:@"CodeSigningGuide"ofType:@"pdf"];
         NSData *myData = [NSDatadataWithContentsOfFile:path];
         [pickeraddAttachmentData:myData mimeType:@"file/pdf"fileName:@"rainy.pdf"];
         */
    
        NSString *emailBody =[NSString stringWithFormat:@"我分享了文件给您的二维码图片"] ;
        [picker setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:picker animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                        message:NSLocalizedString(@"二维码图片没有成功生成", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好吧 去生成图片", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        caseMFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        caseMFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        caseMFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        caseMFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark send via message

- (IBAction)sendImageViaMessage:(id)sender {
    //[self showSMSPicker];
    if (self.isImageSaved) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"要使用短信发送图片 请先保存图片", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好吧 先去保存", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)showSMSPicker{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"此设备不支持该项功能", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"好吧", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"此设备不支持该项功能", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好吧", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    if (self.imageView.image) {
    
//    NSString *smsBody =[NSString stringWithFormat:@"我分享了文件给您，地址是"];
//    picker.body=smsBody;
    
//    NSData *imageData =  UIImagePNGRepresentation(self.imageView.image);
//    NSString *imageString = [[NSString alloc]initWithBytes:[imageData bytes] length:[imageData length] encoding:NSASCIIStringEncoding];
//    picker.body = imageString;
    [self presentModalViewController:picker animated:YES];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                        message:NSLocalizedString(@"二维码图片没有成功生成", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好吧 去生成图片", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	
	//feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			NSLog(@"Result: Mail sending canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: Mail sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: Mail sending failing");
			break;
		default:
			NSLog(@"Result: Mail not sending");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
@end

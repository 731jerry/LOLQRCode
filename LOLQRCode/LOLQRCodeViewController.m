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

@end

@implementation LOLQRCodeViewController
@synthesize imageView = _imageView;
@synthesize inputText = _inputText;
@synthesize warnningLabel = _warnningLabel;
 
@synthesize generateQRCodeButton = _generateQRCodeButton;
@synthesize saveImageButton = _saveImageButton;
@synthesize scanQRCodeButton = _scanQRCodeButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.buttonEquals = [[[CustomButton alloc] initWithTextAndHSB:@"" target:self selector:@selector(buttonTapped:) hue:0.075f saturation:0.9f brightness:0.96f] autorelease];
    [self.generateQRCodeButton useBlackStyle];
    [self.saveImageButton useBlackStyle];
    [self.scanQRCodeButton useGreenConfirmStyle];
    
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

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
        [alert show];
    }
    //show_alert_view(@"This picture has been saved to your photo album.", @"Picture Saved");
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"图片保存错误", nil)
                                                        message:NSLocalizedString(@"可能是二维码没有成功生成 也可能是其他原因", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"好吧 再试一次", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    //show_alert_view(@"Please try it again later.", @"Saving Failed");
}

- (IBAction)generateQRCode:(id)sender {
    self.imageView.image = [QRCodeGenerator qrImageForString:self.inputText.text imageSize:self.imageView.bounds.size.width];
    self.warnningLabel.text = self.inputText.text;
}

- (IBAction)saveImage:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
@end

//
//  BlockAlertView.h
//
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : NSObject {
@protected
    UIView *view;
    NSMutableArray *blocks;
    CGFloat height;
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, readwrite) BOOL vignetteBackground;


//@property (nonatomic)    UIView *view;
//@property (nonatomic, strong)    NSMutableArray *blocks;
//@property (nonatomic)    CGFloat height;

@end

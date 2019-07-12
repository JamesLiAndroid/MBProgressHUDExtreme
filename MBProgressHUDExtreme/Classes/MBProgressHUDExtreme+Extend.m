//
//  MBProgressHUDExtreme+Extend.m
//  MBProgressHUDExtreme
//
//  Created by James Li on 2019/7/12.
//

#import "MBProgressHUDExtreme+Extend.h"
#import <objc/message.h>

// 延时消失时间
CGFloat const delayTime = 1.2;

@implementation MBProgressHUDExtreme (Extend)

static char cancelationKey;

NS_INLINE MBProgressHUDExtreme *createNew(UIView *view) {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    return [MBProgressHUDExtreme showHUDAddedTo:view animated:YES];
}

NS_INLINE MBProgressHUDExtreme *settHUD(UIView *view, NSString *title, BOOL autoHidden) {
    MBProgressHUDExtreme *hud = createNew(view);
    //文字
    hud.label.text = title;
    //支持多行
    hud.label.numberOfLines = 0;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //设置默认风格
    if (NHDefaultHudStyle == 1) {
        hud.hudContentStyle(NHHUDContentBlackStyle);
        
    } else if (NHDefaultHudStyle == 2) {
        hud.hudContentStyle(NHHUDContentCustomStyle);
    }
    
    if (autoHidden) {
        // x秒之后消失
        [hud hideAnimated:YES afterDelay:delayTime];
    }
    
    return hud;
}

/**
 单例模式
 */
+ (MBProgressHUDExtreme *)shareInstance {
    static MBProgressHUDExtreme *hud;
    if (hud == nil) {
        hud = [[MBProgressHUDExtreme alloc] init];
    }
    return hud;
}

- (MBProgressHUDExtreme *)showOnlyLoadToView:(UIView *)view {
    return settHUD(view, nil, NO);
}

- (void)showOnlyTextToView:(UIView *)view title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
}

- (void)showOnlyTextToView:(UIView *)view title:(NSString *)title detail:(NSString *)detail {
    MBProgressHUDExtreme *hud = settHUD(view, title, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
}

- (void)showSuccess:(NSString *)success toView:(UIView *)view {
    MBProgressHUDExtreme *hud = settHUD(view, success, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[self loadImage:@"success.png"]];
}


- (void)showError:(NSString *)error toView:(UIView *)view {
    MBProgressHUDExtreme *hud = settHUD(view, error, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[self loadImage:@"error.png"]];
}


- (void)showTitleToView:(UIView *)view postion:(NHHUDPostion)postion title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

//纯标题 + 详情 + 自定背景风格 - 自动消失
- (void)showDetailToView:(UIView *)view
                 postion:(NHHUDPostion)postion
                   title:(NSString *)title
                  detail:(NSString *)detail {
    MBProgressHUDExtreme *hud = settHUD(view, title, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

- (void)showTitleToView:(UIView *)view
                postion:(NHHUDPostion)postion
           contentStyle:(NHHUDContentStyle)contentStyle
                  title:(NSString *)title {
    
    MBProgressHUDExtreme *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    hud.hudPostion(postion);
}


- (MBProgressHUDExtreme *)showLoadToView:(UIView *)view title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}


- (void)showTitleToView:(UIView *)view
           contentStyle:(NHHUDContentStyle)contentStyle
                  title:(NSString *)title
             afterDelay:(NSTimeInterval)delay {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    [hud hideAnimated:YES afterDelay:delay];
}

- (MBProgressHUDExtreme *)showTitleToView:(UIView *)view
                      contentStyle:(NHHUDContentStyle)contentStyle
                             title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    return hud;
}


- (MBProgressHUDExtreme *)showDownToView:(UIView *)view
                    progressStyle:(NHHUDProgressStyle)progressStyle
                            title:(NSString *)title
                         progress:(NHCurrentHud)progress {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    if (progressStyle == NHHUDProgressDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
    } else if (progressStyle == NHHUDProgressDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
        
    } else if (progressStyle == NHHUDProgressAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (progress) {
        progress(hud);
    }
    return hud;
}

- (MBProgressHUDExtreme *)showDownToView:(UIView *)view
                    progressStyle:(NHHUDProgressStyle)progressStyle
                            title:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                         progress:(NHCurrentHud)progress
                      cancelation:(NHCancelation)cancelation {
    
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    
    if (progressStyle == NHHUDProgressDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
    } else if (progressStyle == NHHUDProgressDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
        
    } else if (progressStyle == NHHUDProgressAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    
    [hud.button setTitle:cancelTitle ?: NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:hud action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    hud.cancelation = cancelation;
    if (progress) {
        progress(hud);
    }
    return hud;
}


- (void)showCustomView:(UIImage *)image toView:(UIView *)toView title:(NSString *)title {
    
    MBProgressHUDExtreme *hud = settHUD(toView, title, YES);
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
}


- (MBProgressHUDExtreme *)showModelSwitchToView:(UIView *)toView
                                   title:(NSString *)title
                               configHud:(NHCurrentHud)configHud {
    MBProgressHUDExtreme *hud = settHUD(toView, title, NO);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}


- (MBProgressHUDExtreme *)showDownNSProgressToView:(UIView *)view title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeDeterminate;
    return hud;
}


- (MBProgressHUDExtreme *)showDownWithNSProgress:(NSProgress *)Progress
                                   toView:(UIView *)view title:(NSString *)title
                                configHud:(NHCurrentHud)configHud {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}


- (MBProgressHUDExtreme *)showLoadToView:(UIView *)view
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = backgroundColor;
    return hud;
}

- (MBProgressHUDExtreme *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                            title:(NSString *)title {
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.contentColor = contentColor;
    return hud;
}

- (MBProgressHUDExtreme *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.contentColor = contentColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}


- (MBProgressHUDExtreme *)showLoadToView:(UIView *)view
                       titleColor:(UIColor *)titleColor
                   bezelViewColor:(UIColor *)bezelViewColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    
    MBProgressHUDExtreme *hud = settHUD(view, title, NO);
    hud.label.textColor = titleColor;
    hud.bezelView.backgroundColor = bezelViewColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}

- (MBProgressHUDExtreme *)createHudToView:(UIView *)view title:(NSString *)title configHud:(NHCurrentHud)configHud {
    MBProgressHUDExtreme *hud = settHUD(view, title, YES);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}


- (void)hideHUD {
    [MBProgressHUDExtreme hideHUDForView:nil];
}


#pragma mark -- sett // gett
- (void)didClickCancelButton {
    if (self.cancelation) {
        self.cancelation(self);
    }
}

- (void)setCancelation:(NHCancelation)cancelation {
    objc_setAssociatedObject(self, &cancelationKey, cancelation, OBJC_ASSOCIATION_COPY);
}

- (NHCancelation)cancelation {
    return objc_getAssociatedObject(self, &cancelationKey);
}

- (MBProgressHUDExtreme *(^)(UIColor *))hudBackgroundColor {
    return ^(UIColor *hudBackgroundColor) {
        self.backgroundView.color = hudBackgroundColor;
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(UIView *))toView {
    return ^(UIView *view){
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(NSString *))title {
    return ^(NSString *title){
        self.label.text = title;
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(NSString *))details {
    return ^(NSString *details){
        self.detailsLabel.text = details;
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(NSString *))customIcon {
    return ^(NSString *customIcon) {
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:customIcon]];
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(UIColor *))titleColor {
    return ^(UIColor *titleColor){
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(UIColor *))progressColor {
    return ^(UIColor *progressColor) {
        UIColor *titleColor = self.label.textColor;
        self.contentColor = progressColor;
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(UIColor *))allContentColors {
    return ^(UIColor *allContentColors) {
        self.contentColor = allContentColors;
        return self;
    };
}


- (MBProgressHUDExtreme *(^)(UIColor *))bezelBackgroundColor {
    return ^(UIColor *bezelViewColor){
        self.bezelView.backgroundColor = bezelViewColor;
        return self;
    };
}


- (MBProgressHUDExtreme *(^)(NHHUDContentStyle))hudContentStyle {
    return ^(NHHUDContentStyle hudContentStyle){
        if (hudContentStyle == NHHUDContentBlackStyle) {
            self.contentColor = [UIColor whiteColor];
            self.bezelView.backgroundColor = [UIColor blackColor];
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            
        } else if (hudContentStyle == NHHUDContentCustomStyle) {
            self.contentColor = NHCustomHudStyleContentColor;
            self.bezelView.backgroundColor = NHCustomHudStyleBackgrandColor;
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            
        } else if (hudContentStyle == NHHUDContentDefaultStyle){
            self.contentColor = [UIColor blackColor];
            self.bezelView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            
        }
        return self;
    };
}


- (MBProgressHUDExtreme *(^)(NHHUDPostion))hudPostion {
    return ^(NHHUDPostion hudPostion){
        if (hudPostion == NHHUDPostionTop) {
            self.offset = CGPointMake(0.f, -MBProgressMaxOffset);
        } else if (hudPostion == NHHUDPostionCenten) {
            self.offset = CGPointMake(0.f, 0.f);
        } else {
            self.offset = CGPointMake(0.f, MBProgressMaxOffset);
        }
        return self;
    };
}

- (MBProgressHUDExtreme *(^)(NHHUDProgressStyle))hudProgressStyle {
    return ^(NHHUDProgressStyle hudProgressStyle){
        if (hudProgressStyle == NHHUDProgressDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;
            
        } else if (hudProgressStyle == NHHUDProgressAnnularDeterminate) {
            self.mode = MBProgressHUDModeAnnularDeterminate;
            
        } else if (hudProgressStyle == NHHUDProgressCancelationDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;
            
        } else if (hudProgressStyle == NHHUDProgressDeterminateHorizontalBar) {
            self.mode = MBProgressHUDModeDeterminateHorizontalBar;
            
        }
        return self;
    };
}

/**
 在库中，与ViewController无关的部分
 加载图片，需要注意路径问题
 */
- (UIImage *)loadImage:(NSString *)imgName{
    // 两种加载图片的方法
    // 使用以下方法，使imgName不带后缀，且可以按照分辨率加载，前提是有足够的图片资源，2x、3x图片都存在
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSString *imageNameReal = [@"MBProgressHUDExtreme.bundle/" stringByAppendingString:imgName];
//    NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:imageNameReal];
//    //NSString *path = [bundle pathForResource:imgName ofType:@"png" inDirectory:@"HTUIKit.bundle"];
//    return  [UIImage imageWithContentsOfFile:path];
    // 使用该方法，务必使imgName为完整的图片名称
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:imgName ofType:nil inDirectory:@"MBProgressHUDExtreme.bundle"];
    return  [UIImage imageWithContentsOfFile:path];
}
@end

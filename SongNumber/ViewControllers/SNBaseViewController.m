//
//  SNBaseViewController.m
//  SongNumber
//
//  Created by Hai_Apple on 2/9/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import "SNBaseViewController.h"

@interface SNBaseViewController ()

@end

@implementation SNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //notify view
    float x_center = ([UIScreen mainScreen].bounds.size.height - 300)/2;
    _notifyView = [[UILabel alloc]initWithFrame:CGRectMake(x_center, 120, 300, 100)];
    _notifyView.numberOfLines = 4;
    _notifyView.textColor = [UIColor whiteColor];
    _notifyView.font = [UIFont systemFontOfSize:15];
    _notifyView.textAlignment = NSTextAlignmentCenter;
    _notifyView.layer.cornerRadius = 7;
    _notifyView.layer.borderColor = [UIColor grayColor].CGColor;
    _notifyView.layer.backgroundColor = [[UIColor colorWithRed:196/255 green:196/255 blue:196/255 alpha:0.75] CGColor];
    _notifyView.alpha = 0;
    [self.view addSubview:_notifyView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)hideNotifyView:(void(^)())complete
{
    [UIView animateWithDuration:2.5 animations:^{
        _notifyView.alpha = 0;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

-(void)showNotifyView:(NSString*)content complete:(void(^)())complete
{
    _notifyView.layer.zPosition = 100;
    _notifyView.text = content;
    
    //Update notify frame
    CGRect notifyFrame = _notifyView.frame;
    CGSize fixedSize = [content sizeWithFont:_notifyView.font];
    notifyFrame.size = CGSizeMake(fixedSize.width +20, fixedSize.height + 10);
    float x_center = ([UIScreen mainScreen].bounds.size.height - notifyFrame.size.width)/2;
    float y_center = ([UIScreen mainScreen].bounds.size.width - notifyFrame.size.height)/2;
    notifyFrame.origin.x = x_center;
    notifyFrame.origin.y = y_center;
    _notifyView.frame = notifyFrame;
    
    [UIView animateWithDuration:0.2 animations:^{
        _notifyView.alpha = 1;
    } completion:^(BOOL finished) {
        [self hideNotifyView:nil];
        if (complete) {
            complete();
        }
    }];
    
}

-(void)showLoading
{
    // The hud will dispable all input on the window
    _loadingView = [[MBProgressHUD alloc] init];
    [self.view addSubview:_loadingView];
    _loadingView.labelText = @"Loading data...";
    
    [_loadingView show:YES];
}

-(void)hideLoading
{
    if (_loadingView) {
        [_loadingView hide:YES afterDelay:2];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
